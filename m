Return-Path: <linux-kernel-owner+w=401wt.eu-S966228AbXIKGs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966228AbXIKGs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXIKGsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:48:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60461 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbXIKGsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:48:18 -0400
Date: Tue, 11 Sep 2007 08:49:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [RFC] kbuild - introduce vdir to make life easier for x86_64
Message-ID: <20070911064942.GA3663@uranus.ravnborg.org>
References: <20070910191138.GA31541@uranus.ravnborg.org> <200709110040.41605.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709110040.41605.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 12:40:41AM +0200, Andi Kleen wrote:
> 
> > The below are the minimal clean-up - a bit more could be done.
> > 
> > Comments?
> 
> Looks good in principle. My only suggestion would be to name it something
> differently than vdir. I know that's what GNU make calls it, but it's still
> pretty cryptic. How about just fallback-dir ? 
fallback-dir is better.
vdir came from make's vpath but then very few knows about vpath anyway so that 
was not the best source of inspiration.

 
> Also what would be nice (I don't know if it's doable in make) would
> be a separate variable (e.g. other-obj-... := ) that contains the fallback
> names and that is double checked against the fallback directory.
My first attempt was along these lines but I dropped it for two reasons:
1) Mixing obj-y and other-obj-y assinment broke all assumptions on linkorder.
   It would not be possible to link objexts in order a1.o, a2.o, a3.o if a1.o
   and a3.o were assigned to obj-y and a2.o was assigned to other-obj-y. 

2) It needed a decent amouth of unreadable gmake-foo to introduce
   a second variable. And the learning curve for kbuild internals are alreay
   to steep so I try to avoid additional complexity.

I'm a bit reluctant to just enable the fallback-dir functionality.
There is no point in adding this for the sake of x86 if we merge
i386 and x86_64 a few days after.

	Sam
