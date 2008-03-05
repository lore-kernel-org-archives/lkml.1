Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYCEQzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYCEQzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYCEQzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:55:23 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:51997 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYCEQzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:55:22 -0500
Date: Wed, 5 Mar 2008 17:53:39 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080305175339.2059226b@mjolnir.drzeus.cx>
In-Reply-To: <20080305154856.GC553@one.firstfloor.org>
References: <20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<20080304172918.GA27332@one.firstfloor.org>
	<20080304183032.17084e39@mjolnir.drzeus.cx>
	<20080304174315.GB27332@one.firstfloor.org>
	<20080304190446.775165e3@mjolnir.drzeus.cx>
	<20080304183406.GC27332@one.firstfloor.org>
	<20080305070454.3df78593@mjolnir.drzeus.cx>
	<20080305154856.GC553@one.firstfloor.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008 16:48:56 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Start: You discovered at some point where you currently have code a variable 
> is not updated yet.
> Fact: You have some new code that runs before that point
> Information: The variable is updated later eventually in the idle exit path.
> Fact II: You require the variable to be updated in your new code

For some value of "require". The code will do what it's supposed to do anyway, just in a sub-optimal way (it will avoid a deep sleep even though it didn't need to).

> Possible solutions: 
> (1) you move your new code in a point of the idle exit path after the variable 
> is updated 

But I don't use jiffies in the idle exit path, only the entry path.

> (2) you move the code that updates the variable earlier before your code

Which basically leaves this option. I.e. guarantee that jiffies are updated between one cpuidle reflect and the subsequent select.

> Solution: I described the first variant which is likely easier.
> How: I told you where it is updated, so that shouldn't be too difficult. 
> Action: Implement solution (1) or (2) 
> Action: Test if it works
> Check: If test succeeded exit 
> Otherwise: Restart at Start
> 

Now you're just being a smart-ass. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
