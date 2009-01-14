Return-Path: <linux-kernel-owner+w=401wt.eu-S1761859AbZANLac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859AbZANLac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbZANLaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:30:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36595 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbZANLaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:30:20 -0500
Date: Wed, 14 Jan 2009 12:30:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Dieter Ries <clip2@gmx.de>,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
Message-ID: <20090114113006.GE8625@elte.hu>
References: <496A085E.8020604@gmx.de> <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com> <20090112112608.GB19388@elte.hu> <200901141146.04563.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901141146.04563.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 12 January 2009 21:56:08 Ingo Molnar wrote:
> > work_on_cpu() needs to be reworked to be more generally usable.
> 
> Yes, but how?  If we don't take the hotplug lock, we are relying on the 
> callers to "prove" the cpu can't go away.  But we've already shown that 
> we can't find this by inspection :(

it appears the problem wasnt even the hotplug lock, but the fact that 
work_on_cpu() uses the generic schedule_work() method, which goes into a 
queue with all other keventsd worklets.

and keventd is used by other aspects of cpufreq as well -> creating 
workqueue-driven lock inversion scenarios - see Dieter's lockdep dump 
earlier in this thread. ( I'm amazed lockdep sees through that dependency
:-)

	Ingo
