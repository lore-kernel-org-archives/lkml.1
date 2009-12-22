Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbZLVKF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbZLVKF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZLVKF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:05:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46867 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZLVKF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:05:57 -0500
Date: Tue, 22 Dec 2009 11:05:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com
Subject: Re: [PATCH] [1/11] Add rcustring ADT for RCU protected strings
Message-ID: <20091222100553.GA10314@basil.fritz.box>
References: <20091221220.243954235@firstfloor.org> <20091221012022.9C5C4B160D@basil.firstfloor.org> <20091222024635.GA9279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222024635.GA9279@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 06:46:35PM -0800, Paul E. McKenney wrote:
> My guess is that you will sooner or later need a size field, perhaps
> under some debug config parameter.

That can be gotten from ksize() if needed.

> > +/*
> > + * Get a local private copy of a RCU protected string.
> > + * Mostly useful to get a string that is stable while sleeping.
> > + * Caller must free returned string.
> > + */
> > +char *access_rcu_string(const char *str, int size, gfp_t gfp)
> > +{
> > +	char *copy = kmalloc(size, gfp);
> > +	if (!str)
> > +		return NULL;
> 
> Assuming that "str" points to the "str" field of a struct rcu_string,
> what prevents a grace period from elapsing at this point, freeing the
> "str" out from under us?

Yes, that's broken thanks. I'll move the reference into the read lock
section.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
