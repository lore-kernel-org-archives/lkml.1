Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYEDXzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYEDXzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 19:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYEDXzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 19:55:42 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:4950 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYEDXzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 19:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nN7PGR3TAg1NM7KZOcH7fhISgZKCyByQ1Nb0ASmJOLPF+6lFgEp3PD3v/HJxzBupUTTh5LWjWHYcwPR/bNNORTEphbVC3N3mT6Gnq67it33FWL5uXqqNR+0AXXIcjNnp8CR3wQPAsAsjcQIqPBjxAhmbKAAu9CUPXI9syZDs/tQ=
Message-ID: <5bdc1c8b0805041655la79c341jfe87e40f6b3e9733@mail.gmail.com>
Date: Sun, 4 May 2008 16:55:40 -0700
From: "Mark Knecht" <markknecht@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.24.4 Sonics Silicon Backplane problems in dmesg
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <481E4833.3050304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <481E4657.3080707@lwfinger.net> <481E4833.3050304@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 4:35 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Larry Finger wrote:
>
> > I'm attempting to bring up a Compaq F752US laptop running Gentoo. The
> > kernel.org 2.6.24.4, Gentoo Vanilla-sources and 2.6.24-gentoo-r4
> > kernels all fail to boot without selecting the 'noapic' option on the
> > kernel command line. If I add noapic irqpoll the machine does boot but
> > I see this problem for all 3 kernels:
> >
> > Is this possibly caused by having to choose the noapic irqpoll options?
> >
> > <SNIP>
> > WARNING: at drivers/ssb/main.c:883 ssb_tmslow_reject_bitmask()
> > Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r4 #4
> > [<c0375e3f>] ssb_tmslow_reject_bitmask+0x4b/0x56
> > [<c0376504>] ssb_device_is_enabled+0x9/0x2d
> >
>
>  The warning above is caused by the configuration of the device below. I
> found
>  and fixed this problem several months ago, but after the 2.6.24 window
> closed.
>

Thanks Larry. I downloaded 2.6.25 but hadn't had a chance to build it
yet. I'll get on that.

>
>
> > 03:00.0 Network controller: Broadcom Corporation BCM94311MCG wlan
> > mini-PCI (rev 02)
> >
>
>  The problem is fixed in the wireless-testing.git tree, and in mainline
> 2.6.25. It is unlikely that it is causing the boot problem; however that
> could be checked by trying 2.6.25.
>

Yeah, doesn't seem likely. The non-boot issue was earlier in the boot
process with messages like these:


Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1
CPU1: AMD Athlon(tm) 64 X2 Mobile Technology TK-53 stepping 01
Total of 2 processors activated (6834.25 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1

and then it just hangs.

Since I wrote the message this morning I munged through the kernel
config and came up with a config file that doesn't hang without the
options. I'll send the two config files along to the list under a
different subject line that speaks directly to this problem.

Thanks,
Mark
