Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab0CJWPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:15:44 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58676 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0CJWPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:15:42 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/X+QvBlA/jHC7AnnldrBgZ
Date: Wed, 10 Mar 2010 14:16:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>, Viresh KUMAR <viresh.kumar@st.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Subject: Re: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr
 platform
Message-ID: <20100310221652.GS2900@atomide.com>
References: <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
 <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com>
 <4B973CF6.4030009@st.com>
 <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com>
 <4B977067.3050108@st.com>
 <20100310141645.GB22729@linux-sh.org>
 <alpine.LFD.2.00.1003101732010.22855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003101732010.22855@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [100310 08:38]:
> On Wed, 10 Mar 2010, Paul Mundt wrote:
> > On Wed, Mar 10, 2010 at 03:41:51PM +0530, Viresh KUMAR wrote:
> > > As you may have seen in spear.h files in mach folders, we have multiple hardware
> > > timers in our design (3 in spear3xx, 4 in spear6xx and each timer have two
> > > independent channels. That doubles the timers count, so it is 6 and 8).
> > > One timer (or two channels) are used by clock event and clock source, but rest of
> > > the timers are still available. So we need some way to export this functionality
> > > of our hardware. It can be considered simply as a driver for GPT.
> > > 
> > > What do you say?
> > > 
> > This is hardly a unique situation for your platform, this is true for
> > most platforms. There's no reason why clockevents couldn't just be
> > extended and drivers could then just grab unused clockevents and pin them
> > accordingly. Most of the infrastructure is already in place for something
> > like that, without really having to do anything special.
> > 
> > Having said that, most drivers have pretty lame reasons for trying to get
> > at fixed timer channels, and most of the time they can easily get by with
> > an hrtimer instead. There's also the issue that you're effectively
> > bypassing nohz by having some timer channel off on the side doing who
> > knows what. You would need a pretty compelling reason for why you are
> > sidestepping all of the existing infrastructure anyways.
> 
> Right, and that's exactly the reason why we did not add the few
> missing bits to make clock events directly usable from drivers.

Yeah still no direct users so far for the 12 hardware timers on
omaps.. I guess the only use I could see is bit banging data
over a few GPIO lines using a FIQ handler.

Another thing to consider is that most likely all hardware timers
are not able to wake up the system from idle, which would easily
cause some mysterious errors for drivers.

Tony
