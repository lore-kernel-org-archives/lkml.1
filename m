Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbXFOGis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbXFOGis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 02:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbXFOGik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 02:38:40 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:46037 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbXFOGij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 02:38:39 -0400
Message-ID: <467233AE.8020500@nttdata.co.jp>
Date: Fri, 15 Jun 2007 15:37:34 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: Toshiharu Harada <haradats@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC] TOMOYO Linux
References: <466FA71C.1020309@nttdata.co.jp>	 <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>	 <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com> <1181763466.17547.502.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1181763466.17547.502.camel@moss-spartans.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 06:37:36.0716 (UTC) FILETIME=[A98EB8C0:01C7AF17]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> On Wed, 2007-06-13 at 23:22 +0900, Toshiharu Harada wrote:
>> 2007/6/13, Stephen Smalley <sds@tycho.nsa.gov>:
>>> On Wed, 2007-06-13 at 17:13 +0900, Toshiharu Harada wrote:
>>>> Here are examples:
>>>> /bin/bash process invoked from mingetty: /sbin/mingetty /bin/bash
>>>> /bin/bash process invoked from sshd: /usr/sbin/sshd /bin/bash
>>>> /bin/bash process invoked from /bin/bash which was invoked from sshd: /usr/sbin/sshd /bin/bash /bin/bash
>>> Why can't you do this via SELinux domain transitions?  That lets you do
>>> it by equivalence class rather than per-binary, and let's you just
>>> encode the security-relevant parts of the "invocation history" aka call
>>> chain.  For example, the above could be expressed in SELinux policy
>>> already as:
>>>         domain_auto_trans(getty_t, shell_exec_t, local_shell_t)
>>>         domain_auto_trans(sshd_t, shell_exec_t, remote_shell_t)
>>>         domain_auto_trans(remote_shell_t, shell_exec_t, remote_subshell_t)
>>> or whatever you like.  But you don't have to keep extending it
>>> indefinitely when you don't need to distinguish in policy, so you might
>>> choose to entirely omit the last one, and just have it stay in
>>> remote_shell_t.
>> The above SELinux policy looks similar to the one I wrote, but
>> that is not very true.  Because in my example, path name corresponds to a file
>> while local_shell_t are bound to multiple.
>> I understand the advantages of label, but it needs to be
>> translated to human understandable form of path name.
>> So I think pathname based call chains are advantages for
>> at least auditing and profiling.
> 
> Well, not to get into a debate, but think about whether
> "/usr/sbin/sshd /bin/bash" and "/sbin/mingetty /bin/bash" is more
> understandable to an administrator than "remote shell" vs. "local shell"
> - the label-based approach lets you map the low-level detail of
> individual programs/pathnames to abstract equivalence classes that are
> more understandable, not less.  Further, think about the advantages of
> being able to encode only the security-relevant invocations, not all of
> them.

With our sample implmentation of "automated process invocation
history tracking system" (or TOMOYO Linux, in short :)),
no domain transition design and definition is needed.
All you have to do is just run the kernel.
So limiting to encode does not matter much.

> On a different note, from a quick look, it looks like TOMOYO is AppArmor
> + invocation history from a user perspective.  Plus a wider range of
> controls in your original implementation, but your LSM implementation
> seems to be just getting started and only deals with files.  So what's
> the case for having a whole separate security module vs. a small
> extension to AppArmor?

The reason we cut off various MAC controls was to make
the code as small as possible (we knew lkml readers are busy).
If AA would merge the TOMOYO Linux's "automated proccess
invocation history tracking system" and "real-time policy
learning system", I would be fine.

Cheers,
Toshiharu Harada

