Return-Path: <linux-kernel-owner+w=401wt.eu-S1161137AbXCNLXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbXCNLXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161142AbXCNLXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:23:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:37755 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137AbXCNLXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=j8hkaWzUCSz4Ay62eatJlED22TKGzLtBkSR9MgiiFkpIsctfSxG2sQdSfpNkFn1XSFgA8l7yiH0IZj485VY/3sDfXx70lg2SVoUE/AdNeGKGgwQu3vaxu1Dp1eEtm4stDamAA4V5356XUpknIb22JOB70vAUL2fbfJgmF3djMVI=
Message-ID: <84144f020703140423h2562a353g40c156584943bb7@mail.gmail.com>
Date: Wed, 14 Mar 2007 13:23:02 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: gregkh@suse.de
Subject: Re: [BUG] Linux 2.6.20.2 - unable to handle kernel paging request - still accessing freed memory
Cc: linux-kernel@vger.kernel.org, "Chris Rankin" <rankincj@yahoo.com>
In-Reply-To: <170606.12059.qm@web52911.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170606.12059.qm@web52911.mail.yahoo.com>
X-Google-Sender-Auth: ec48faed5b12e937
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I think there's some sort of reference counting problem with sysfs in
2.6.20 kernels. Can you please help us debug it further?

On 3/10/07, Chris Rankin <rankincj@yahoo.com> wrote:
> It looks like 2.6.20.2 is still doing Bad Things in /sys.
>
> BUG: unable to handle kernel paging request at virtual address 6b6b6d6b

[snip]

> EIP:    0060:[<c01300ff>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.20.2 #1)
> EIP is at module_put+0x20/0x52
> eax: 6b6b6d6b   ebx: 6b6b6b6b   ecx: 00000001   edx: e7a01000
> esi: edb7e4e4   edi: 6b6b6b6b   ebp: e79fd50c   esp: e7a01f58
> ds: 007b   es: 007b   ss: 0068
> Process udevd (pid: 9656, ti=e7a01000 task=f7a46030 task.ti=e7a01000)
> Stack: eba628a0 c0183a1e 00000010 ed570870 e7a641d0 c0151263 00000000 00000000
>        f7ff2208 ed570870 f745b678 00000000 ed570870 c014eda0 00000003 00000003
>        f745b678 f745b6f8 c014fd99 00000003 00000007 00000003 e7a01000 c0102bde
> Call Trace:
>  [<c0183a1e>] sysfs_release+0x2d/0x4c
>  [<c0151263>] __fput+0x96/0x13c
>  [<c014eda0>] filp_close+0x51/0x58
>  [<c014fd99>] sys_close+0x70/0xa7
>  [<c0102bde>] sysenter_past_esp+0x5f/0x85
>  [<c0270033>] __sched_text_start+0x613/0x971

There's also some previous discussion here:

http://lkml.org/lkml/2007/3/1/114

                                           Pekka
