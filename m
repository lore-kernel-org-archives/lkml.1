Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYH1Pe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYH1Pe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYH1Pes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:34:48 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:48391 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751815AbYH1Pes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:34:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Aa/i+E7gbTdiINslOE+3yFvTfr5ABs0ZzDXuABlvhGrRTzALxBDZlHypggn3ly/eY/UDlStE7ISfand5RDJNiLl1cUxzy20+gAbyA9O+5CNFWhCTmSxTAG3VEpvAIMIBuVHkjxSWPd8fZhuEO7f5Vtm/5UZ+mbyZDNYiHF1pr2M=  ;
X-YMail-OSG: R6ppJmEVM1kp0QSKqKNFbfhjsp0YA50_fJK4xGBXpujBanSQMy_UtdDIrH6UPbTtzHMFHKpzI33poIU0d1F3sz7fp3SUv8r_PXpUgnuabVVmsyFSk.qgRu9YSRGGFNSfpyswRijqS66dxzOD9geUzNsU
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Fri, 29 Aug 2008 01:34:34 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080819103301.787700742@chello.nl> <200808290036.35817.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808290134.35093.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008 01:12, Steven Rostedt wrote:
> On Fri, 29 Aug 2008, Nick Piggin wrote:
> > On Friday 29 August 2008 00:30, Ingo Molnar wrote:
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > For this, if this time limit does kick in, we should at the very
> > > > least print something out to let the user know this happened. After
> > > > all, this is more of a safety net anyway, and if we are hitting the
> > > > limit, the user should be notified. Perhaps even tell the user that
> > > > if this behaviour is expected, to up the sysctl <var> by more.
> > >
> > > yeah, agreed, this is a reasonable suggestion. Peter, do you agree?
> >
> > Seems reasonable. But I still think it should be disabled by default
> > (it might not get caught in testing for example).
>
> Perhaps we should default it to 1sec, that way it would be hit more often,
> and educate the users of this now feature.

There only one sane default, as far as I can see.

Before anybody attacks me again because I haven't got my brain together or
am an annoying standards nitpicker:

I'm very well aware of the consequences of unlimited hogging of the CPU.
And I know exactly why people might want rt throttling. But just think for
a minute the _negative_ consequences of changing the API and remember that
is close to the #1 rule of Linux development to not break user API.

And put it this way: the sysctl is right there. Any distro that cares about
this problem will probably find this thread as #1 hit and work out how to
enable the sysctl and break the API if they are happy to do that. On the
flip side, not every application development or deployment is even going to
know about this, and it may not be trivial to catch in testing, so it could
cause failures in the field.
