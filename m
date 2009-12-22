Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZLVU7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZLVU7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZLVU7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:59:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46874 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZLVU7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:59:09 -0500
Date: Tue, 22 Dec 2009 12:59:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH] [1/11] Add rcustring ADT for RCU protected strings
Message-ID: <20091222205912.GD9279@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091221220.243954235@firstfloor.org> <20091221012022.9C5C4B160D@basil.firstfloor.org> <20091222024635.GA9279@linux.vnet.ibm.com> <20091222100553.GA10314@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222100553.GA10314@basil.fritz.box>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 11:05:53AM +0100, Andi Kleen wrote:
> On Mon, Dec 21, 2009 at 06:46:35PM -0800, Paul E. McKenney wrote:
> > My guess is that you will sooner or later need a size field, perhaps
> > under some debug config parameter.
> 
> That can be gotten from ksize() if needed.

Fair enough!!!

> > > +/*
> > > + * Get a local private copy of a RCU protected string.
> > > + * Mostly useful to get a string that is stable while sleeping.
> > > + * Caller must free returned string.
> > > + */
> > > +char *access_rcu_string(const char *str, int size, gfp_t gfp)
> > > +{
> > > +	char *copy = kmalloc(size, gfp);
> > > +	if (!str)
> > > +		return NULL;
> > 
> > Assuming that "str" points to the "str" field of a struct rcu_string,
> > what prevents a grace period from elapsing at this point, freeing the
> > "str" out from under us?
> 
> Yes, that's broken thanks. I'll move the reference into the read lock
> section.

Looking forward to seeing the updated version!

							Thanx, Paul
