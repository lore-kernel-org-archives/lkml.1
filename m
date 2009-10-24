Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZJXDyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZJXDyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 23:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZJXDyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 23:54:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49305 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZJXDyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 23:54:37 -0400
Date: Sat, 24 Oct 2009 05:54:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Message-ID: <20091024035438.GY32470@one.firstfloor.org>
References: <1256167297.4768.14.camel@localhost.localdomain> <20091021174804.3885db37@infradead.org> <20091022004919.GT32470@one.firstfloor.org> <20091021194822.72895c46@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091021194822.72895c46@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 07:48:22PM -0700, Arjan van de Ven wrote:
> On Thu, 22 Oct 2009 02:49:19 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > you're pretty much the first now who touches ->comm from
> > > not-the-thread-itself.... are you sure that is safe?
> > 
> > It's not, there is no locking. On the other hand nothing should crash,
> > just users might see half rewritten data.
> 
> .. with strings this is tricky though.. if the new string is longer
> than the old one the terminating zero might just be missed etc.

Good point.
He needs to first set the last byte to zero to avoid that.
But better probably to do a proper lock on all readers. Or not add
this feature at all (does it have a strong use case?)
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
