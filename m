Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYFBViN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYFBViN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYFBVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:37:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:49089 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYFBVh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,579,1204531200"; 
   d="scan'208";a="335143469"
Date: Mon, 2 Jun 2008 14:37:56 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: =?iso-8859-1?Q?J=FCrgen?= Mell <j.mell@t-online.de>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Message-ID: <20080602213756.GB25114@linux-os.sc.intel.com>
References: <200806011101.06491.j.mell@t-online.de> <87wsl9fkno.fsf@basil.nowhere.org> <200806011847.29744.j.mell@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806011847.29744.j.mell@t-online.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 06:47:29PM +0200, Jürgen Mell wrote:
> On Sonntag, 1. Juni 2008, Andi Kleen wrote:
> > j.mell@t-online.de writes:
> > > or it is restored more than
> > > once. Please keep in mind, that I am always running two Einstein
> > > processes simultaneously on my two cores!
> > > I am willing to do further testing of this problem if someone can give
> > > me a hint how to continue.
> >
> > My bet would have been actually on
> > aa283f49276e7d840a40fb01eee6de97eaa7e012 because it does some nasty
> > things (enable interrupts in the middle of __switch_to).
> >
> > I looked through the old patchkit and couldn't find any specific
> > PREEMPT problems. All code it changes should run with preempt_off
> >
> > You could verify with sticking WARN_ON_ONCE(preemptible()) into
> > all the places acc207616a91a413a50fdd8847a747c4a7324167
> > changes (__unlazy_fpu, math_state_restore) and see if that triggers
> > anywhere.
> 
> No, that did not trigger. I put the WARN_ON_ONCE into process.c, traps.c 
> and also into the __unlazy_fpu macro in i387.h but I got no messages 
> anywhere (dmesg, /var/log/messages, /var/log/warn) when the trap #8 
> occurred. 
> Meanwhile I am also running the tests on another machine to make sure it is 
> not a hardware-related problem.
> 
> Any new ideas are welcome!
> 
> Meanwhile I will go back to 2.6.20 and revert
> aa283f49276e7d840a40fb01eee6de97eaa7e012. Maybe I got on a wrong track...

2.6.20 doesn't have the commit 'aa283f49276e7d840a40fb01eee6de97eaa7e012'

As you are seeing this corruption problem starting from 2.6.20,
atleast recent(in 2.6.26 series) fpu changes don't play a role in this.

I will try to reproduce your issue.

thanks,
suresh
