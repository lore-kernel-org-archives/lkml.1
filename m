Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZJGQrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZJGQrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759552AbZJGQrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:47:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:15824 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759501AbZJGQrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:47:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,520,1249282800"; 
   d="scan'208";a="733887493"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Wang, Shane" <shane.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 7 Oct 2009 09:47:10 -0700
Subject: RE: [GIT PULL] x86/txt for v2.6.32
Thread-Topic: [GIT PULL] x86/txt for v2.6.32
Thread-Index: AcpGXfNApoKOcynAREahhmB5dzCyPQBDKLew
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D9AC1C49D6@orsmsx506.amr.corp.intel.com>
References: <20090928211745.GA2119@elf.ucw.cz> <4AC1AA61.8070408@intel.com>
 <20090929171318.GC14405@elf.ucw.cz> <20090929191951.18315e94@infradead.org>
 <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
 <20090930065448.GB11652@elf.ucw.cz>
 <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
 <20091003201959.GA16047@elf.ucw.cz>
 <20091003203619.GA27182@khazad-dum.debian.net> <ada4oqgp5qx.fsf@cisco.com>
 <20091006081258.GB1469@ucw.cz>
In-Reply-To: <20091006081258.GB1469@ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Tuesday, October 06, 2009 1:13 AM
>
> On Sat 2009-10-03 13:44:22, Roland Dreier wrote:
> >
> >  > > > So I modify the RAM content so that BIOS does not think measured
> >  > > > environment existed before suspend?
> >
> >  > And it is ridiculously easy to pull off, too:
> >  > http://www.engadget.com/2008/02/21/cold-boot-disk-encryption-attack-is-shockingly-
> effective/
> >  >
> >  > Shows the attack being used to read sensitive keys, but you can use it also
> >  > to *modify* system running state (it will be more difficult, as you need to
> >  > remove and replace the RAM while on S3 instead of S5, but it should be
> >  > doable by someone who knows what he is doing).
> >
> > I believe the whole point of this TXT / S3 handling is that the resume
> > from S3 will then be able to detect that the contents of RAM have been
> > modified while the system was asleep.
>
> ...and you are able to read out any keys, etc. Maybe that's expected &
> ok, but Doc*/intel_txt.txt does not actually tell me what it protects
> against and is pretty much useless... making patches impossible to
> review.
>
> So... what does txt protect?

>From Documentation/intel_txt.txt:
        Intel TXT in Brief:
        o  Provides dynamic root of trust for measurement (DRTM)
        o  Data protection in case of improper shutdown
        o  Measurement and verification of launched environment

Intel TXT doesn't protect anything itself--it provides a foundation for software to provide protections and security.  tboot and the associated Linux patches do this.  The section of intel_txt.txt titled "Value Proposition for Linux or "Why should you care?"" tries to describe what is provided.

> Data integrity only?

Data integrity, yes, but not only.  The code also provides for DRTM-based measurements, data protection in case of improper shutdown, etc.

> Data privacy, too?

No.

> Who is it designed to protect against?
>
> Remote attacker?

Yes.

> Local user trying to subvert it?

No.

> ...and has soldering iron he's willing to use?
>
> ...and has soldering iron, osciloscope and PCI analyzer he's willing to use?

No and no.

> > TXT simply produces a reasonably trustworthy measurement of system
> > state.  If you modify RAM while the system is asleep, then you will not
> > be able to produce a measurement showing an unmodified system state.
>
> Well, actually I see some auditing to be done in proposed patches.

All comments are welcome.

Joe
