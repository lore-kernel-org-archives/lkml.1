Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYLDWrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYLDWrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbYLDWqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:46:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082AbYLDWqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:46:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Thu, 4 Dec 2008 23:46:21 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812040754020.3256@nehalem.linux-foundation.org> <200812041900.27514.elendil@planet.nl>
In-Reply-To: <200812041900.27514.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812042346.21904.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of December 2008, Frans Pop wrote:
> On Thursday 04 December 2008, Linus Torvalds wrote:
> > On Thu, 4 Dec 2008, Frans Pop wrote:
> > > I've given your patch a try and the few resumes from STR I've done
> > > were all successful. That's not 100% conclusive yet, but a nice
> > > start. Some info from logs etc. below.
> >
> > Ok, but I thought you had a hard time reproducing this _anyway_, even
> > with just plain -rc7. No?
> 
> Well, I had a failure rate of about 1 in 5-10 resumes originally.
> See: http://bugzilla.kernel.org/show_bug.cgi?id=11545
> 
> Then I found the 2 workarounds and *with those in place* I got almost 100% 
> reliable resumes. Now I've removed those workarounds and with either the 
> revert or your oneliner I still get 100% success.
> From my PoV that is a very definite improvement: the machine now "feels" a 
> hell of a lot more reliable for critical use.
> 
> So I _could_ reproduce it reliably given enough suspend/resume cycles.
> But I guess this does support your suspicion that it may be a timing 
> issue: if the timing happens to be right, the resume succeeds; if it's 
> wrong I get a dead box.
> 
> > Since it's apparently STR, has anybody gotten _anything_ sane out of
> > trying to enable PM_TRACE_RTC, and then doing that
> >
> > 	echo 1 > /sys/power/pm_trace
> 
> I did try that at the beginning. That's how I ended up removing e1000e 
> before suspend. See http://bugzilla.kernel.org/show_bug.cgi?id=11545.
> 
> My next hint was that Matthew Garret, who has the same notebook, was 
> surprised at my resume problems as he did not see them. So I did a 
> comparison of our kernel configs and made some changes to mine. From
> that I found that a very low value for SND_HDA_POWER_SAVE_DEFAULT (5) 
> reduced the failure rate to practically zero.
> 
> At some point I tried keeping e1000e loaded for a bit, but that quickly 
> gave me a failure again, so I starting removing it again during suspend.
> 
> So I did have some data, but as I got no response on my BR I had no idea 
> where to go from there. I was really very happy to see Rafael's mail as 
> his description almost exactly matched what I had been seeing.
> 
> I'd be happy to run with unpatched kernels for a while and do some more 
> pm_traces, but only if someone is going to follow up and interpret the 
> results for me or provide suggestions for targeted additional debugging.

Please go for it, I'm very interested in understanding the underlying problem.

Thanks,
Rafael
