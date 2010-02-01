Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0BAOdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:33:17 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:60109 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab0BAOdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:33:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xEnYeXfZIEUHINtNFhg6txcC1ufBLNP+XsFGrhu0afD9L1rQw9BognxhQv7dX7naIf
         YhX+pTkUmwpsdR/tX+W/Mxw012gVVVMrTgIM4iAnZ1OVTBnyrm9U74UxddbGmHYr1Smi
         O9eF2xnSg3Y2FAkPl9qN4MXUaloq2wkTi4dqI=
MIME-Version: 1.0
In-Reply-To: <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz>
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz>
	 <20100130171804.GA2348@liondog.tnic>
	 <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz>
Date: Mon, 1 Feb 2010 14:57:01 +0100
Message-ID: <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com>
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
From: Borislav Petkov <petkovbb@googlemail.com>
To: zhiyi <zhuang@cs.otago.ac.nz>
Cc: linux-kernel@vger.kernel.org, Zhiyi Huang <hzy@cs.otago.ac.nz>,
       jkmair@cs.otago.ac.nz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 11:59 PM, zhiyi <zhuang@cs.otago.ac.nz> wrote:
> My module worked for a kernel 2.6.29 with CONFIG_NR_CPUS=64 on my dual
> quad-core AMD Opteron. The value of nr_cpu_ids I got from the same module
> was correct (8).

This could mean that your include/generated/autoconf.h, which is used by
external modules, is not updated and contains CONFIG_NR_CPUS=8. Do

make mrproper

in your kernel directory by moving your .config out of the way first and
then rebuild your kernel and external module(s). nr_cpu_ids should pick
up the updated CONFIG_NR_CPUS value from your .config.

-- 
Regards/Gruss,
Boris
