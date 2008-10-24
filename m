Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYJXScL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYJXScL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYJXSb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:31:57 -0400
Received: from outbound-mail-149.bluehost.com ([67.222.38.39]:41795 "HELO
	outbound-mail-149.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752605AbYJXSb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:31:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=gzIw7kVgVqLb6kXu49BwBN81DScZekHFy7U5K1cTFEJBe4lw9gVQRG0bVOFjSUfVPU0oUG5VKWKyBcLAmn2QLat2yzyo8K0RgvckcEtushdhlE2JVpQ2SjKsc0//36bg;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
Subject: Re: [Bug] pci allocation resources problems on x86_64
Date: Fri, 24 Oct 2008 11:31:54 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49019FE4.50001@free.fr> <4901A4C2.5020805@free.fr>
In-Reply-To: <4901A4C2.5020805@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241131.55129.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 24, 2008 3:34 am Mathieu Taillefumier wrote:
> Hi
>
> Sorry, the first files iomem and ioports are not the right one (I used
> the mem option to check if it has any effects). Please find the right
> one in attachments. Sorry again for this mistake.
>
> regards
>
> Mathieu
>
> > Hi,
> >
> > The kernel does not seems to allocate the pci resources correctly on
> > sony laptop (VGN-SZ71 series) when pcmcia slot is used.
> >
> > I track down this bug for long now and I was able to identify where it
> > is probably coming from. The laptop I am using possess a pcmcia card
> > slot  that I am using for a tvcard. The kernel is a x86_64 bits kernel
> > (2.6.27.2) and the laptop has 4G of memory. In this case the
> > initialization of the tv-card is pure garbage and the kernel oops
> > after that. Now if I start the laptop with 2G and the same kernel then
> > everything works fine. From that I can assume that the problem does
> > not come from the tvcard driver and maybe not from the pcmcia driver
> > (although I am not completely sure). After discussing on the dvb
> > mailling list we arrive to the conclusion that the problem is probably
> > coming from pci allocation ressources.
> >
> > additional informations :
> >
> > Configurations that work
> >
> > - x86_64 kernels with 2G of memory
> > - x86 kernels with 4G of memory without PAE activated nor 64 bits
> > resources allocations option activated.
> >
> > Config that do not work
> >
> > - x86_64 kernels with 4G of memory
> > - x86 kernels with 4G of memory with 64bits resources allocation
> > activated (without PAE).
> >
> > The problem can be reproduced with kernel-next and the kernel-git so
> > far and probably with earlier kernels although I have try this
> >
> > cat /proc/version
> > Linux version 2.6.27.2-intel-nogem (root@coesite) (gcc version 4.3.1
> > (GCC) ) #4 SMP Wed Oct 22 12:05:55 CEST 2008
> > the lspci output are in one of the files and different dmesg are
> > included. the dmesg-diff give the differences between the working one
> > and the buggy one.
> >
> > I would like to help debugging this

Ultimately we need to do better at grabbing space for PCI allocations on x86.  
I was hoping we'd have some patches in 2.6.28 that would help here, but they 
weren't ready in time.  Can you file a kernel.org bug for this problem with 
the files attached?  I'll try to find time to put together some 
improvements...

-- 
Jesse Barnes, Intel Open Source Technology Center

