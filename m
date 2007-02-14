Return-Path: <linux-kernel-owner+w=401wt.eu-S932406AbXBNR7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbXBNR7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932405AbXBNR7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:59:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:5193 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbXBNR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:59:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PKlYZxE6Kped2e5ggmOh2/ds7ujs3QlEXJEga4CWBkRb+Le8WlppGaptUsWpT7piS0UVUH/3N2YIwLFfAd3TEnE3+5TSrwSODvW7MgjXnbWFrZ0WkjHTaEFt207XOxoo2fODIFYVzl/bK9Ubk/uX9IuZFVio96RAMDsFCFnQJtU=
Message-ID: <1a297b360702140959p55cb6b03l86cfd3f03a641f49@mail.gmail.com>
Date: Wed, 14 Feb 2007 21:59:36 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Erik Mouw" <erik@harddisk-recovery.com>
Subject: Re: smp and irq conflict
Cc: "Lapo TIN" <lapolapolapo@tin.it>, linux-smp@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Robert Hancock" <hancockr@shaw.ca>
In-Reply-To: <20070202110853.GA16296@harddisk-recovery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45C277E0.2040604@shaw.ca> <45C0FAE300242D46@vsmtp14.tin.it>
	 <20070202110853.GA16296@harddisk-recovery.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Erik Mouw <erik@harddisk-recovery.com> wrote:
> On Fri, Feb 02, 2007 at 01:04:53AM +0100, Lapo TIN wrote:
> > I need to capture at 25 frame per second from each channel...
> > So 25 x 8 total frames per second on the pci.
>
> Each PAL frame takes about 800k, so that makes 20MB/s per channel. With
> 8 channels that makes 160 MB/s. That will most certainly overwhelm a
> normal 33 MHz 32 bit PCI bus which has a theoretical bandwidth of 132
> MB/s (90MB/s max in practice). Modern PCs have faster PCI busses
> (66MHz, 64 bit, PCI-X, or PCI-e) so there's less chance on bus
> contention.
>
> On the other hand, I suppose you will store the video streams on disk.
> That will use another 20MB/s per channel on the bus so the total
> becomes 320 MB/s. You need some careful system design in order to get
> that right. Especially look carefully at bus contention, if the system
> has multiple busses, distribute the bttv cards over those busses. Also
> be sure to have enough bandwidth for the disk subsystem.
>
> > So do you think I have to change the motherboard ?
> > What is important ? the chipset ? is there specification I need ?
>
> Last time I had to record frame-synchronous video from 3 streams (8
> years ago) PCs could hardly manage 2 streams over their bus and there
> was no way to guarantee frame sync. The only way out was to use an SGI
> Onyx2 with 3 digital video option cards and a large disk subsystem.
> That made the whole system much more expensive but at that time it was
> the only way to meet all requirements.
>
> I don't know about current PCs, bus speeds have improved. It is however
> still important how those busses are connected together and to the
> chipset. You have to figure out from your motherboard documentation if
> there is enough bandwidth available. If there isn't, get a faster
> motherboard, or consider using compressing grabber cards like the
> Hauppauge PVR 150 or PVR 500.
>

such devices can do a max of one input or 2 inputs. There are cards
that do 16/32 video inputs, do hardware MPEG4 compression and write to
disk/ stream out through the network interface.

But most such devices have proprietory drivers and have issues working
properly. Got bitten by a bug similarly, recently. The vendor was pig
headed to either fix the driver or to provide driver source.
(http://dvr.neugent.net/ They talked too much of Linux, but really
pathetic stuff overall, claimed their issue was Intellectual Property)

They claimed the Linux kernel was buggy rather than stating that their
driver was buggy.
In the end, luckily got my money back for the hardware.

Manu
