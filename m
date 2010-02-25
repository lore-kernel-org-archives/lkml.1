Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab0BYQDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:03:48 -0500
Received: from trinity.fluff.org ([89.16.178.74]:59332 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250Ab0BYQDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:03:46 -0500
Date: Thu, 25 Feb 2010 16:03:44 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: viresh kumar <viresh.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       viresh.kumar@st.com
Subject: Re: QUERY: How to call board specific initialization function
	before map_io or timer_init
Message-ID: <20100225160344.GG30679@trinity.fluff.org>
References: <22dbbef21002250507s12664df5q36e50a8f9e0bc3b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22dbbef21002250507s12664df5q36e50a8f9e0bc3b9@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 06:37:37PM +0530, viresh kumar wrote:
> Hello,
> 
> I need to call my board specific initialization routine before
> timer_init or map_io is called.
> I tried to see that in earlier architectures and found most of
> architecture call machine
> specific init function from map_io or init_irq or init_machine.
> 
> Situation: I need to register my clock framework with
> arch/arm/common/clkdev framework
> before actually initializing timer. So i can't do this in
> "init_machine" as timer_init is called
> before that.

One method would be to use an init call from <linux/init.h> which is
called before these are done (you'll have to work out which one is
suitable for yourself).

Either that or ensure that your boards always call a specific
routine in their init sequence to ensure clocks are registered before
the timer needs them.

If I remeber correctly, map_io() is actually called before the timers
are initialised, so you could add your clocks there.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

