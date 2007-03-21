Return-Path: <linux-kernel-owner+w=401wt.eu-S964781AbXCUULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbXCUULh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964817AbXCUULh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:11:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:47985 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781AbXCUULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=df/df5tC0lrZi5XpMM869n4RuhmsVp5cl2+unne3Zskk/3sJjvv3pxFnKp6Kv6GgXyzP6ratbdNY1ucaUsyo4EwXrHcPrWUfAcNOZttMApCbBiwuKsKYi/hf8hMmYCWZ8T6i9ycYfSvNgWx4gmlHJd4Fqhnk2dStmVTEM2jtV9Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Bob Tracy <rct@gherkin.frus.com>
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
Date: Wed, 21 Mar 2007 21:18:51 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz,
       John Stultz <johnstul@us.ibm.com>
References: <20070321195450.36D5EDBA1@gherkin.frus.com>
In-Reply-To: <20070321195450.36D5EDBA1@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703212118.51395.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for narrowing it down, I'm adding John to cc:.

On Wednesday 21 March 2007, Bob Tracy wrote:
> I originally wrote:
> > Platform is a Dell CPxJ 650GT notebook.  Attempts to boot 2.6.21-rc3
> > and -rc4 produce the following console output:
> > 
> > (apparently normal boot)
> > ...
> > Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> > ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> > PIIX4: IDE controller at PCI slot 0000:00:07.1
> > PIIX4: chipset revision 1
> > PIIX4: not 100% native mode: will probe irqs later
> >     ide0: BM-DMA at 0x0860-0x0867, BIOS settings: hda:DMA, hdb:pio
> >     ide1: BM-DMA at 0x0868-0x086f, BIOS settings: hdc:DMA, hdd:pio
> > (hangs here)
> > 
> > The next two lines of output for 2.6.21-rc2 and earlier are:
> > Probing IDE interface ide0...
> > hda: TOSHIBA MK3017GAP, ATA DISK drive
> 
> After nine iterations of git-bisect --> compile --> reboot over the past
> two days, the commit that caused this problem has been identified.
> 
> 6bb74df481223731af6c7e0ff3adb31f6442cfcd is first bad commit
> commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
> Author: john stultz <johnstul@us.ibm.com>
> Date:   Mon Mar 5 00:30:50 2007 -0800
> 
>     [PATCH] clocksource init adjustments (fix bug #7426)
> 
>     This patch resolves the issue found here:
>     http://bugme.osdl.org/show_bug.cgi?id=7426
> 
>     The basic summary is:
>     (omitted for brevity)
> 
>     Signed-off-by: John Stultz <johnstul@us.ibm.com>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Cc: "David S. Miller" <davem@davemloft.net>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 b259cf01f6ad791a0f58c9956e6e0111cb9aa310 0e8fbf31c0bae9ca6039fc7781b53c12f7a67592 M      arch
> :040000 040000 19bd5cf3c55c6b7947ec66b68eab643c99f15bb8 ef8fda0445287e34eeb466985901ca64191b6539 M      drivers
> :040000 040000 4f84ad7bdf509ed83efd95d174796f1a6a948b0e 51624663be2fdce8aaeb3b49e188520aa3735d90 M      include
> :040000 040000 ef82986d4590fed84b9a128da90e65f7e43f43a9 778d0cf7273d7514b436ca4e91a6948f34694972 M      kernel
> 
> -- 
> -----------------------------------------------------------------------
> Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
> rct@frus.com
> -----------------------------------------------------------------------
