Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYIIN1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYIIN1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYIIN1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:27:43 -0400
Received: from www.tglx.de ([62.245.132.106]:42947 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYIIN1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:27:42 -0400
Date: Tue, 9 Sep 2008 15:27:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: [regression] __tick_program_event of hpet is stuck
In-Reply-To: <200809091438.57158.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0809091503460.3271@apollo.tec.linutronix.de>
References: <200809080114.36106.elendil@planet.nl> <200809080313.48910.elendil@planet.nl> <alpine.LFD.1.10.0809091248590.3271@apollo.tec.linutronix.de> <200809091438.57158.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008, Frans Pop wrote:
> On Tuesday 09 September 2008, Thomas Gleixner wrote:
> > > CE: __tick_program_event of hpet is stuck 1468f1b3c9 1468f1c751
> > > CE: increasing min_delta_ns 5000 to 10000 nsec
> > > [...]
> > > CE: __tick_program_event of hpet is stuck 33576032f74 33576035684
> > > CE: increasing min_delta_ns 10000 to 20000 nsec
> > > [...]
> > > CE: __tick_program_event of hpet is stuck 63242b30d28 63242b35b48
> > > CE: increasing min_delta_ns 20000 to 40000 nsec
> >
> > what's the highest value which you have seen ?
> 
> These are the highest I've seen, but that's possibly because I haven't 
> left the system running for longer. There's just under an hour between 
> the messages (kern.log has 00:59:17, 01:56:38, 02:51:23 for the three 
> increases listed above) with the first fairly shortly after boot.
> 
> I've just awakened the laptop from suspend and will let it sit for the 
> rest of the day. If I get any higher values I'll let you know.

It's nothing to worry about. I out the WARN_ON() there to get some
information about the validation of min_delta_ns and to see in which
range this happens.

I'm going to remove the WARN_ON() and just keep the information that
we need to increase the min_delta_ns value for safe operation.

Thanks,

	tglx
