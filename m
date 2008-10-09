Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbYJISoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbYJISoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYJISoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:44:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36069 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYJISoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:44:15 -0400
Date: Thu, 9 Oct 2008 20:45:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted Execution
	Technologysupport for Linux - Overview
Message-ID: <20081009184552.GF12507@elf.ucw.cz>
References: <D936D925018D154694D8A362EEB0892005AC105B@orsmsx416.amr.corp.intel.com> <20081009125311.GD1623@ucw.cz> <20081009174427.GB6912@sequoia.sous-sol.org> <20081009175938.GA12507@elf.ucw.cz> <20081009181451.GD6912@sequoia.sous-sol.org> <20081009182149.GE12507@elf.ucw.cz> <D936D925018D154694D8A362EEB0892005B12CC8@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D936D925018D154694D8A362EEB0892005B12CC8@orsmsx416.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > You exit/reenter the trusted mode accross sleep... so any
> guarantees
> > > > "trusted" mode does are void, right?
> > >
> > > You exit from kernel to tboot on any shutdown, which handles the
> proper
> > > teardown of the measured env (meaning you also come back on via
> tboot).
> > > So things like saving tpm state, scrubbing secrets from memory, etc.
> > 
> > Aha, so instead sleep mode is useless because I'll have to remount all
> > the crypto filesystems and restart all the apps...
> 
> Sleep mode works the same as it does today (caveat S4 issue which we
> will fix), it just goes through the tboot code before putting the
> platform HW into the appropriate state.  What this process is adding is
> that on resume, tboot will get control from BIOS instead of the kernel.
> Then tboot will re-launch the TXT environment before going back to the
> kernel at the kernel's expected S3 resume vector.  The re-establishing
> of the protected environment won't disrupt the subsequent kernel resume
> process.

No, I don't get it. So presumably useful thing to do is to seal my
crypto partition so that only known-good kernel can access it?

But then, the crypto keys will be in ram during suspend/resume
(because I have the filesystem mounted) => I loose any guarantees?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
