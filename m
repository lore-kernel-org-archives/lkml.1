Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYHVIfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYHVIfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 04:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYHVIfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 04:35:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:54610 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYHVIfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 04:35:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wZrcUhuaZUwthQ3c92jW/y/8hejc7v3yw/OU6CawRre/UCpu99NX4gVw8BdNcJ5hxF
         Ss+NO609vmKzzCK1VmqrqGbM/ZWli+kOi76yyVQwUn73eUjSOBm5cHKP8m3LBzQoxzR7
         eScDfarW/P5L2acWpB5iIB9l84MM9xpZ7p/kU=
Message-ID: <ac9c93b10808220135v26141113ud799bc56a744c64e@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:35:19 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "Bruce Leonard" <brucle@earthlink.net>
Subject: Re: [PATCH 0/2][MTD] Support for > 2GiB MTD devices
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <10836950.1219370444356.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <10836950.1219370444356.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggest you also post this to linux-mtd@lists.infradead.org

2008/8/22 Bruce Leonard <brucle@earthlink.net>:
> All,
>
> Over the course of the last several months, I've been working on adding support to
> the kernel for MTD devices that exceed 2GiB in size.  In my particular case I
> have a need for 8GiB of NAND flash that appears as a single device.  I'm now
> ready to submit my (first ever!) patch (please be kind :)  ).
>
> Design Details:
> The problem - The size field of struct mtd_info is only 32-bits, which limits
>        the size of mtd devices to 2GiB (0x80000000).
> The solution - The size of a device can be calculated buy multiplying the number
>        of erase blocks by the erase block size.  I added a new field to struct
>        mtd_info to hold the number of erase blocks and an inline function to
>        determine the device size by returning mtd_info->size if it's non-zero
>        or returning (mtd_info->num_eraseblocks * mtd_info->erasesize).
>
> A couple of comments.  First and foremost, these patches don't completely change
> the MTD layer.  Due to my in-experience outside of what I was focused on
> (NAND/UBI/UBIFS/MTDCHAR) I felt it was best if I restricted my changes to what I
> knew.  If the community feels I need to take these changes into the rest of the
> MTD layer please advise.  Secondly, there were changes that I needed to make in
> mtd-utils, but I again only focused on the UBI sub-set.  mtd-utils no longer builds
> because of the changes (though the UBI tools still build).  But I really do NOT
> feel qualified to make changes to the rest of mtd-utils as they're tools I don't
> use and don't understand and I don't want to accidentaly break something I don't
> understand.  The changes in mtd-utils are the same changes as in
> .../include/linux/mtd/mtd.h and .../include/mtd/mtd-abi.h.  If anyone has a
> suggestion as to how I should handle mtd-utils I would appreciate it.
>
> Thanks again to everyone who's answered my endless stupid questions.
>
> Bruce
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
