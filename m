Return-Path: <linux-kernel-owner+w=401wt.eu-S2992687AbXDTJJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992687AbXDTJJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992723AbXDTJJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:09:10 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:50855 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992687AbXDTJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:09:08 -0400
Date: Fri, 20 Apr 2007 11:11:46 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070420111146.2c2e8192@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46284F2A.4000401@gmail.com>
References: <Pine.LNX.4.44L0.0704181219250.12246-100000@iolanthe.rowland.org>
	<46284F2A.4000401@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 14:27:06 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Hello, Alan.
> 
> Alan Stern wrote:
> > This doesn't solve a related problem: a subsystem wants to register
> > devices and to provide a set of mutually-exclusive services to the
> > devices' drivers.  The mutual exclusion has to be provided by a mutex or
> > something similar, and the drivers need a way to unbind even while waiting
> > to acquire the mutex.
> 
> I don't really follow why the drivers need a way to unbind even while
> waiting to acquire the mutex.  Care to enlighten me?

I guess when the driver is just being ripped out or an unbind has been
triggered or similar.

> Yeah, exactly.  My argument is that that impedance matching between
> lifetime rules must happen at some place and it's better if we can do in
> the higher layer where we can afford more effort and thus complexity.
> We're currently pushing that down to each drivers and not too many are
> getting it right.  I think it's just unrealistic to expect every and
> each driver subsystems to get it right, so some overhead at higher layer
> is acceptable and we can definitely afford much more optimization at
> higher layer.

I agree. It isn't easy to get this right, so just we should just solve
that once for all drivers.
