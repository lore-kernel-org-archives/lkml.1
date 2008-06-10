Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbYFJIXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbYFJIXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYFJIXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:23:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:5153 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYFJIX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jKBZyiI6vVUxO1tExKdVmQJcM3SP9cyiUBCx6gaUQstvBWaXOpQF2rAh69JbQ0L6+3
         XV8l/Uf6L9QAbNJqXgBi6GNobT8ujuvdDHH6923OBL4203oPSQQbBn4SdyHY5oXDMCBo
         Q2CiVRN6Uj+9H3LVOeg182gxN/634LAeJYxBo=
Message-ID: <3877989d0806100123j1734a82fgd6d6eee6146b8423@mail.gmail.com>
Date: Tue, 10 Jun 2008 16:23:28 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Roland McGrath" <roland@redhat.com>, "Petr Tesarik" <ptesarik@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC017C44B2@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
	 <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	 <20080527061209.9A24426FAA6@magilla.localdomain>
	 <1211869515.29836.2.camel@elijah.suse.cz>
	 <3877989d0806022304w35764b17p9d4c3c95eceae0f5@mail.gmail.com>
	 <48450864.6080707@suse.cz> <48455619.6040608@suse.cz>
	 <20080603210125.1724C26FC96@magilla.localdomain>
	 <1FE6DD409037234FAB833C420AA843EC017C44B2@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 5:31 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> What do you mean by "extra"?  There is a SIGTRAP sent after execve
>> completes when ptraced, even when PTRACE_SYSCALL is not being used.
>> So for an execve that succeeds under PTRACE_SYSCALL, there is a
>> ptrace_notify at syscall entry, then a SIGTRAP queued (i.e., not seen
>> by ptrace if blocked), then a ptrace_notify at syscall exit.  If
>> that's what's happening (including the blocked SIGTRAP not being seen
>> by the ptracer, i.e. strace), then there is no mystery (and no bug).
>
> This might not be the same bug ... but I do have a definite 100%
> reproducible bug (latest git kernel, old version of strace (4.5.15-1.el4.1))
>
> Run:
>
>        $ strace -o logit -f make

For this test case, utrace doesn't work too..
