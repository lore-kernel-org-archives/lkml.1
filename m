Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZKTNfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZKTNfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZKTNfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:35:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:10473 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZKTNfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:35:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xX27l0C4SaQJ6C/rpx6L1BV8YaKCtHZO8dmIs5W6SITEA+U+8ZnitKy72YAjfHZdQX
         nk/Hr6NH4b3inAgjBTodTW7angcentoDIPwwL5Y4473Gp3630JKYUaFoVt3u79HcghCe
         GKXpj+lzhkxx5K87u7DptFJelz/wf91TDTQQ8=
MIME-Version: 1.0
In-Reply-To: <4B067E1A.7000102@garzik.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.n7F.4SdALB@chimera>
	 <20091119.120550.183823935.davem@davemloft.net>
	 <40a4ed590911192359o563b104fo562f325ad9f5358e@mail.gmail.com>
	 <4B065648.6040609@garzik.org>
	 <40a4ed590911200129p6f0d048dqef10df2b311d4744@mail.gmail.com>
	 <4B067E1A.7000102@garzik.org>
Date: Fri, 20 Nov 2009 14:35:07 +0100
Message-ID: <40a4ed590911200535j2fe970fas3db14492c4c30b9d@mail.gmail.com>
Subject: Re: [Bug #14622] Second IDE device not found
From: Zeno Davatz <zdavatz@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 12:31 PM, Jeff Garzik <jeff@garzik.org> wrote:

> I use minicom and a null modem serial cable.  One of minicom's commands will
> capture everything sent to the serial port, to a file.  Other options are
> available.  Googling for "linux serial console" found several useful
> starting-point links.
>
> The basic idea is to sent console output to a serial port, and then have
> some method of reading and capturing the serial port's data.
>
> Another alternative is netconsole (google for "linux netconsole"), which
> permits output over the network.

Ok, I will try to look into this.

> Well, this goes back to David's basic request:  IDE-only or ATA-only.

I find it a bit irritating, that CONFIG_IDE is mentioned as ATA in
make menuconfig. But I'm trying to understand your point.

> You really, really, really should not to enable both at the same time.

I recompiled the kernel only with below settings all enabled.

> If you are choosing ATA-only (libata), then you should disable CONFIG_IDE
> and everything associated with CONFIG_IDE, including CONFIG_BLK_DEV_SVWKS.

I disabled CONFIG_IDE this time.

> libata will want something like
> CONFIG_ATA
> CONFIG_ATA_VERBOSE_ERROR        <-- optional, but helpful
> CONFIG_PATA_SERVERWORKS
>
> CONFIG_SCSI
> CONFIG_SCSI_LOGGING             <-- ditto
> CONFIG_SCSI_CONSTANTS           <-- ditto
> CONFIG_BLK_DEV_SD
> CONFIG_BLK_DEV_SR               <-- required only for CD-ROM support

Recompiled with above enabled. And indeed: It worked. Booting as normal.

Thank you for the detailed instructions.

Best
Zeno
