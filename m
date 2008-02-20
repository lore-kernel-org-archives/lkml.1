Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbYBTIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbYBTIwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYBTIwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:52:12 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:62731 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254AbYBTIwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:52:10 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joel Becker <Joel.Becker@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <47BBDA20.8030105@zytor.com>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
	 <1203274161.27987.6.camel@localhost.localdomain>
	 <20080218104025.GA15899@ca-server1.us.oracle.com>
	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	 <47BBDA20.8030105@zytor.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 08:51:50 +0000
Message-Id: <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.25-rc1 xen pvops regression
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=IBC6Mn4gnMEbzucXirMA:9 a=Ryu-0yTyCeqmsvq82HsA:7 a=E_IzjT7_6dPHKvPtPR7dCpMuj8EA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 23:43 -0800, H. Peter Anvin wrote:
> Ian Campbell wrote:
> > On Mon, 2008-02-18 at 02:40 -0800, Joel Becker wrote:
> >> On Sun, Feb 17, 2008 at 06:49:21PM +0000, Ian Campbell wrote:
> > 
> >>> x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.
> > 
> >> 	This fixed it.  I'm now booting successfully.  Thank you!
> > 
> > Excellent. Jeremy, are you happy for this to go in?
> > 
> 
> NAK!
> 
> It's pretty standard for 0xf0000...0x100000 to be marked RESERVED in 
> E820 on real hardware (including the system I'm typing on right now.) 
> It is so marked to indicate that hardware cannot be mapped into that 
> space.  However, you can't rely on this fact -- heck, you can't rely on 
> E820 even existing on a real machine.  I have specimens of real-life 
> machines that go both ways.
> 
> This patch WILL break real hardware.
> 
> What's particularly damning is that it's titled "x86/xen: Do not scan 
> for DMI unless the DMI region is reserved by e820." whereas in fact it 
> changes (breaks) generic code.

Sorry, I was trying to indicate that it was a generic change which was
motivated by Xen support, but you're right it did look like I was saying
it was a Xen only change.

As far as the actual change goes I was assuming that any machine that
has DMI/SMBIOS would easily be new enough to have an E820 which could be
expected to reserve this region. Looks like I was mistaken about how
long E820 had been around and/or how reliably it is used to reserve the
tables.

Anyway, will have to think of another solution.

Ian.

-- 
Ian Campbell

Just because the message may never be received does not mean it is
not worth sending.

