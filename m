Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZG2Pcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZG2Pcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZG2Pcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:32:35 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:42536 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZG2Pce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:32:34 -0400
Date: Wed, 29 Jul 2009 17:32:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: dwalker@fifo99.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
Message-ID: <20090729173231.012d0b89@skybase>
In-Reply-To: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com>
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 08:57:13 -0600
dwalker@fifo99.com wrote:

> On Wed, 2009-07-29 at 16:44 +0200, Martin Schwidefsky wrote:
> > On Wed, 29 Jul 2009 08:15:19 -0600
> > dwalker@fifo99.com wrote:
> > 
> > > > Remove clocksource_read, clocksource_enable and clocksource_disable
> > > > inline functions. No functional change.
> > > > 
> > > 
> > > Your still not really explaining this one, is this suppose to be
> > > cleaner? Or is this related to some other part of your clean up?
> > 
> > The only one of the three inline functions that is a bit more
> > complicated is clocksource_enable() because of the mult_orig logic. But
> > that goes away with a later patch. The function aren't accessors either,
> > they are used exclusively by the timekeeping code. In short, they are
> > useless, don't you think?
> 
> Above is what should go in your patch description .. 

Ok, sounds reasonable.
 
> The reason that I'm not totally into this one is cause these inlines
> help to document to the code..
> 
> If you have ,
> 
> struct clocksource cs;
> 
> then several lines later you have
> 
> cs->read(); 
> 
> vs,
> 
> clocksource_read(cs);
> 
> The later is completely clear, and the former isn't.. Instead of "cs"
> you could pick any obscure name, and read() isn't exactly unique.. So
> really any function in the clocksource structure has the potential for a
> helper, and the inlines don't really cost anything ..

Hmm, you have an object of type struct clocksource and you do
cs->read(cs). If that is not clear enough then I don't know what is. We
do that all over the place in the linux kernel. And I personally find
these useless wrappers rather annoying. I don't like to have to jump to
another place to find out that it just calls the read function of the
object.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

