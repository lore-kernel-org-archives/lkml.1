Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYIWU1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYIWU1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYIWU1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:27:14 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58179 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbYIWU1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:27:13 -0400
Date: Tue, 23 Sep 2008 13:27:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       serue@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com,
       safford@watson.ibm.com, debora@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] TPM: rcu locking
Message-ID: <20080923202701.GF6637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com> <1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com> <20080923181922.GE6637@linux.vnet.ibm.com> <1222201097.24276.12.camel@blackbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222201097.24276.12.camel@blackbox>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 05:18:17PM -0300, Rajiv Andrade wrote:
> Paul,
> 
> On Tue, 2008-09-23 at 11:19 -0700, Paul E. McKenney wrote:
> > 
> > But here we are deleting from what appears to be some other list.
> > And I don't see any insertiong into either list.
> > 
> > What am I missing here?
> > 
> >                                                         Thanx, Paul
> 
> Sorry, forgot to change list_add() to list_add_rcu() in the code section
> below:
> 
> > > +     /* Make chip available */
> > > +     spin_lock(&driver_lock);
> > > +     list_add(&chip->list, &tpm_chip_list);
> > > +     spin_unlock(&driver_lock);
> 
> I'll resubmit.

Cool!

So tpm_chip_list and the not-obviously-identical list manipulated
in tpm_remove_hardware() really are the same list?

							Thanx, Paul
