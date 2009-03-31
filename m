Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZCaIra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZCaIra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZCaIrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:47:21 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:13363 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZCaIrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X+0XZA3eJcvnjj+FcStxVK12/j2wO6ZZqUoRZ6SY6WBtmPNmlOIsIbAb1ZVedEM106
         2VRFY3g7L4HZSDBjeshGZiVsEtZ3f9w73yIMdrgtVV1I99m0H/ZZCsWxqUyJlg4OJygB
         ffaJ4rF/Hhcn+B8XEbjC6tDLRrl11KWNWCxm8=
MIME-Version: 1.0
In-Reply-To: <804dabb00903302349j5bdbabeaxbbd09291b1cf6e4@mail.gmail.com>
References: <804dabb00903302349j5bdbabeaxbbd09291b1cf6e4@mail.gmail.com>
Date: Tue, 31 Mar 2009 16:47:18 +0800
Message-ID: <df9815e70903310147l1ae6675ag1fa4c2e99250cef4@mail.gmail.com>
Subject: Re: "make oldconfig" problem
From: Jike Song <albcamus@gmail.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 2:49 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> When I do "make oldconfig" on the latest linus git tree, I got:
>
> make oldconfig
> scripts/kconfig/conf -o arch/x86/Kconfig
> usr/Kconfig:145:warning: defaults for choice values not supported
> #
> # configuration written to .config
> #
>
> But checking usr/Kconfig:145:
>
> if INITRAMFS_SOURCE=""
> # The builtin initramfs is so small so we don't want to bug the user...
>
> config INITRAMFS_COMPRESSION_NONE
>        bool
>        default y
>
> endif
>
> I cannot understand the source of errors as well?   Frederic, any ideas?
>
> --
> Regards,
> Peter Teoh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Seems to be caused by
40297927575a50b1d0d308d735c445924d33fba6("bzip2/lzma: don't ask for
compression mode for the default initramfs").

I get no errors with that commit reverted.


-- 
Thanks,
Jike
