Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489Ab0AEOMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0AEOMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152Ab0AEOLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:11:50 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38416 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab0AEOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:11:48 -0500
Date: Tue, 5 Jan 2010 06:11:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/9] Add rcustring ADT for RCU protected strings v2
Message-ID: <20100105141146.GD6836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100105315.789846878@firstfloor.org> <20100105021526.17EF2B17C2@basil.firstfloor.org> <20100105053252.GB6836@linux.vnet.ibm.com> <20100105104746.GB1778@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105104746.GB1778@basil.fritz.box>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 11:47:46AM +0100, Andi Kleen wrote:
> On Mon, Jan 04, 2010 at 09:32:52PM -0800, Paul E. McKenney wrote:
> > > +/*
> > > + * Get a local private copy of a RCU protected string.
> > > + * Mostly useful to get a string that is stable while sleeping.
> > > + * Caller must free returned string.
> > > + */
> > > +char *access_rcu_string(char **str, int size, gfp_t gfp)
> > > +{
> > > +	char *copy = kmalloc(size, gfp);
> > > +	if (!str)
> > > +		return NULL;
> > > +	rcu_read_lock();
> > > +	strlcpy(copy, rcu_dereference(*str), size);
> > 
> > What if "str" is non-NULL, but "*str" is NULL?  Or is that disallowed
> > somehow?
> 
> I would consider it disallowed, all the strings have some default value.
> Empty string would be ""
> 
> If we allowed it the caller couldn't easily distingush error from expected NULL.

OK, then:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul
