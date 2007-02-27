Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbXB0Om0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbXB0Om0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXB0Om0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:42:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:32386 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXB0OmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:42:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QhhoH4A0zP9NLzySiXWTeoThed/Ha5DMeup89zkq3oWm2vBgXTQC9xWiHK2DKgHBUP1v/XvTGKG3xvJwzTeJN89uX5zeQwyARvOqs7+thoZ7nCXI55RF/0B04t/phJfy2Lz3AfxLLcYFYBtf6EwngH0SHTI67e3C44WaiCncE08=
Message-ID: <84144f020702270642q4e371175y2a6c922e030e1f3b@mail.gmail.com>
Date: Tue, 27 Feb 2007 16:42:22 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Chris Rankin" <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <689096.76239.qm@web52904.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <689096.76239.qm@web52904.mail.yahoo.com>
X-Google-Sender-Auth: c55b878cd3109b75
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2/26/07, Chris Rankin <rankincj@yahoo.com> wrote:
> BUG: unable to handle kernel paging request at virtual address 6b6b6ceb

[snip]

> EIP is at module_put+0x20/0x52
> eax: 6b6b6ceb   ebx: 6b6b6b6b   ecx: 00000001   edx: e5bf0000
> esi: e9040b08   edi: 6b6b6b6b   ebp: eae0bb3c   esp: e5bf0f58
> ds: 007b   es: 007b   ss: 0068
> Process udevd (pid: 18662, ti=e5bf0000 task=e6aaa030 task.ti=e5bf0000)
> Stack: eb3ff7bc c01839fe 00000010 ed009b7c ed9291d0 c015124b 00000000 00000000
>        f7ff2208 ed009b7c f7bd0678 00000000 ed009b7c c014ed88 00000003 00000003
>        f7bd0678 f7bd06f8 c014fd81 00000003 00000007 00000003 e5bf0000 c0102bce
> Call Trace:
>  [<c01839fe>] sysfs_release+0x2d/0x4c
>  [<c015124b>] __fput+0x96/0x13c

So udevd is closing a sysfs attribute file but the pointer passed to
module_put is bogus. Looks like the sysfs dentry was already taken
down by release_sysfs_dirent(). Can you reproduce this at will? Does
the oops happen in older kernels?

                                        Pekka
