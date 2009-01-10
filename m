Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZAJUfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZAJUfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZAJUf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:35:27 -0500
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:5869
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbZAJUf1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:35:27 -0500
X-Trace: 176713622/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6/None/alistair@devzero.co.uk
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-MUA: KMail/1.10.3 (Linux/2.6.28-damocles; KDE/4.1.3; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAEOVaEnDlSwG/2dsb2JhbACBa85ghW8
X-IronPort-AV: E=Sophos;i="4.37,245,1231113600"; 
   d="scan'208";a="176713622"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Roman Medina-Heigl Hernandez" <roman@rs-labs.com>
Subject: Re: Oops with Gigabyte motherboard "GA-X48-DQ6" and r8168 Realtek driver
Date: Sat, 10 Jan 2009 20:35:19 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.28-damocles; KDE/4.1.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
References: <49671B77.7080705@rs-labs.com> <200901101255.07611.alistair@devzero.co.uk> <4968ED53.8060404@rs-labs.com>
In-Reply-To: <4968ED53.8060404@rs-labs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901102035.19733.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

On Saturday 10 January 2009 18:47:47 Roman Medina-Heigl Hernandez wrote:
> Alistair John Strachan escribió:
> > My advice to you is to install the very latest Debian kernel (2.6.27) in
> > which this bug has been fixed. That said, I think if you do this, you
> > won't have any further problems. Using the vendor driver instead of the
> > one in mainline probably isn't a good idea.
[snip]
> The working machine is an AMD dual core with 2 MB RAM and 1 rtl8111B NIC
> (being the non-working an Intel Quad core with 4 MB RAM and 2 rtl8111B
> NICs). So yes, as you said, the problems could be due to Quad / 4GB RAM.

Francois Romieu would be the best person to confirm, but I suspect you are 
correct and it does not surprise me that the vendor driver has the same bug.

It would manifest exactly like this -- the NIC would be basically non-
functional with 4GB RAM, but the minute it stops using the swiotlb or AMD GART 
IOMMU there was no problem.

> There's no Debian-official 2.6.27 deb packages (latest is 2.6.26),
> according to:
> http://packages.qa.debian.org/l/linux-2.6.html
> Best for etch I've found is a 2.6.26 deb package (backport).
>
> I suppose you're refering to the ultra-experimental "trunk" branch at:
> deb http://kernel-archive.buildserver.net/debian-kernel trunk main
> Right?
>
> I'll give it a try, it seems a good choice (given the circunstances).
> Another option: Do you think it worth the pain to compile a custom 2.6.28
> kernel? (in other words, do you think it contains fixes that could solve
> the strange issues I've been affected with? I don't follow kernel
> development so I cannot answer this question but perhaps you could...).

Yes, vanilla 2.6.27 and of course 2.6.28 have the fixes. There's no 
requirement to use Debian's mildly patched kernels if you don't want to. The 
reason I recommended the Debian package (though unfortunately as you point out 
it doesn't yet exist) is that it's less faff and is presumably more likely to 
work in your production environment.

Another (good) option would be to grab the Debian kernel sources (apt-get 
source linux-image-<whatever>) and then patch it with the fix, available from 
this bugzilla thread:

http://bugzilla.kernel.org/show_bug.cgi?id=9468

Then debuild it as normal (hopefully you're familiar with this process).

> Thank you very much for your comments. They are greatly appreciated.

No problem. I ran into similar problems with this hardware many months ago and 
nobody knew anything about it. It's just unfortunate that Debian are behind 
the curve in terms of kernel version.

-- 
Cheers,
Alistair.
