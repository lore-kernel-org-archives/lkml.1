Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXFMOWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXFMOWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbXFMOWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:22:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:21837 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbXFMOWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aLUy2yZqOSX9rvS1LyAerueRcStYB55nNpNzhm3YjGk3QlTI22A8DuJDkUDQJTT+OQBfNmFSwga4yJ+VcJ/JUUXmVto4m5BHVUuKzk4RuF9RE+k5Stc8w+MZV8UnfaBrsuSCCKJGLyGnctNF2ce1QwAmV5DZcZgDOWIH/1pfCb8=
Message-ID: <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com>
Date: Wed, 13 Jun 2007 23:22:38 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Stephen Smalley" <sds@tycho.nsa.gov>
Subject: Re: [RFC] TOMOYO Linux
Cc: "Toshiharu Harada" <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FA71C.1020309@nttdata.co.jp>
	 <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/13, Stephen Smalley <sds@tycho.nsa.gov>:
> On Wed, 2007-06-13 at 17:13 +0900, Toshiharu Harada wrote:
> > Here are examples:
> > /bin/bash process invoked from mingetty: /sbin/mingetty /bin/bash
> > /bin/bash process invoked from sshd: /usr/sbin/sshd /bin/bash
> > /bin/bash process invoked from /bin/bash which was invoked from sshd: /usr/sbin/sshd /bin/bash /bin/bash
>
> Why can't you do this via SELinux domain transitions?  That lets you do
> it by equivalence class rather than per-binary, and let's you just
> encode the security-relevant parts of the "invocation history" aka call
> chain.  For example, the above could be expressed in SELinux policy
> already as:
>         domain_auto_trans(getty_t, shell_exec_t, local_shell_t)
>         domain_auto_trans(sshd_t, shell_exec_t, remote_shell_t)
>         domain_auto_trans(remote_shell_t, shell_exec_t, remote_subshell_t)
> or whatever you like.  But you don't have to keep extending it
> indefinitely when you don't need to distinguish in policy, so you might
> choose to entirely omit the last one, and just have it stay in
> remote_shell_t.

The above SELinux policy looks similar to the one I wrote, but
that is not very true.  Because in my example, path name corresponds to a file
while local_shell_t are bound to multiple.
I understand the advantages of label, but it needs to be
translated to human understandable form of path name.
So I think pathname based call chains are advantages for
at least auditing and profiling.

-- 
Toshiharu Harada
haradats@gmail.com
