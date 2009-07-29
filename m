Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZG2O5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZG2O5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZG2O5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:57:11 -0400
Received: from fifo99.com ([67.223.236.141]:53637 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbZG2O5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:57:11 -0400
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090729164411.6d7bd9f6@skybase>
References: <200907291415.n6TEFJkA019086@d06av05.portsmouth.uk.ibm.com>
	 <20090729164411.6d7bd9f6@skybase>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 07:57:28 -0700
Message-Id: <1248879448.28841.180.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 16:44 +0200, Martin Schwidefsky wrote:
> On Wed, 29 Jul 2009 08:15:19 -0600
> dwalker@fifo99.com wrote:
> 
> > > Remove clocksource_read, clocksource_enable and clocksource_disable
> > > inline functions. No functional change.
> > > 
> > 
> > Your still not really explaining this one, is this suppose to be
> > cleaner? Or is this related to some other part of your clean up?
> 
> The only one of the three inline functions that is a bit more
> complicated is clocksource_enable() because of the mult_orig logic. But
> that goes away with a later patch. The function aren't accessors either,
> they are used exclusively by the timekeeping code. In short, they are
> useless, don't you think?

Above is what should go in your patch description .. 

The reason that I'm not totally into this one is cause these inlines
help to document to the code..

If you have ,

struct clocksource cs;

then several lines later you have

cs->read(); 

vs,

clocksource_read(cs);

The later is completely clear, and the former isn't.. Instead of "cs"
you could pick any obscure name, and read() isn't exactly unique.. So
really any function in the clocksource structure has the potential for a
helper, and the inlines don't really cost anything ..

Daniel

