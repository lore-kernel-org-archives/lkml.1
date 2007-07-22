Return-Path: <linux-kernel-owner+w=401wt.eu-S1765775AbXGVWDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765775AbXGVWDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932072AbXGVWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:03:09 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:8525 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761801AbXGVWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KxDmIYKvlRt07FKW6nYTfq/RTdksnmk2NmhdSntQXN5r0QdE9FWKsyEJFPzh6znMGO2XhDf0Se2+auqYlhnsVHWoGpKqYI1RSXGMbuY6F53H+nqIEP3J8QHm3Pz2fbAFDz/z3hn/et05QzFBF7100owNLM3L3rEMBZht8pBM9NI=
Message-ID: <19061b0b0707221503mc18ae4ese658748a1f499e5c@mail.gmail.com>
Date: Sun, 22 Jul 2007 23:03:06 +0100
From: Bartek <poemann@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Pata support for IDE Controller 82801G ICH7 in Linux 2.6.22
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070722213844.6a1656c3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19061b0b0707220259h207f27d7wa836b1973c547e63@mail.gmail.com>
	 <6bffcb0e0707220311v5b145050hbd911e37b6f14c80@mail.gmail.com>
	 <19061b0b0707221021p4ca776d9k737121ddf553b1ce@mail.gmail.com>
	 <6bffcb0e0707221155l5bf7702r449846be48940a42@mail.gmail.com>
	 <20070722213844.6a1656c3@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/22, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > > 00:1f.1 0101: 8086:27df (rev 02)
> >
> > Ok, this controller is supported.
> > Did you forgot about CONFIG_PATA_MPIIX=y?
>
> MPIIX is for early Intel laptop (pentium era).
>
> If the chip is in AHCI mode then CONFIG_AHCI may be what is missing
>

I made a few tests. First I booted my comp with Ubuntu Live Feisty
Fawn, checked modules which are loaded, and interesting ones are:
ata_piix, ata_generic, libata, scsi_mod, sg, sr_mod, sd_mod
ls /dev/sda* showed:
/dev/sda{1,2,3,4}.
So I recompiled the kernel with these options (marking all these
drivers as a modules, in the previous situation they were modules, as
well as compiled directly), and tried to boot. Nothing worked. The
same situation appeared: Waiting for root file system...
Second, I installed a Debian distribution kernel
(linux-image-2.6.22-1-686) and booted from it. It used an old IDE
driver, not PATA. So again no success.
According to AHCI, my chip is rather not that kind. Ubuntu does not
load any AHCI modul. In my previous kernel compilations I tried that
option as well. It did not work.

Bartek
