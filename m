Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbXIGQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbXIGQCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932531AbXIGQCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:02:34 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48615
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbXIGQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:02:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
Date: Fri, 7 Sep 2007 18:01:34 +0200
User-Agent: KMail/1.9.6
Cc: paulmck@linux.vnet.ibm.com, Herbert Xu <herbert@gondor.apana.org.au>,
       satyam@infradead.org, flo@rfc822.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com, ipw3945-devel@lists.sourceforge.net,
       yi.zhu@intel.com, flamingice@sourmilk.net
References: <E1ITGb2-0006Be-00@gondolin.me.apana.org.au> <20070906154612.GD8030@linux.vnet.ibm.com> <1189171635.28781.134.camel@johannes.berg>
In-Reply-To: <1189171635.28781.134.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709071801.34909.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2007, Johannes Berg wrote:
> On Thu, 2007-09-06 at 08:46 -0700, Paul E. McKenney wrote:
> 
> > Looks good to me from an RCU viewpoint.  I cannot claim familiarity with
> > this code.  I therefore especially like the indications of where RTNL
> > is held and not!!!
> 
> :)
> 
> > Some questions below based on a quick scan.  And a global question:
> > should the comments about RTNL being held be replaced by ASSERT_RTNL()?
> 
> I don't like ASSERT_RTNL() much because it actually tries to lock it.
> I'd be much happer if it was WARN_ON(!mutex_locked(&rtnl_mutex)) or
> something equivalent.

What's the problem with trying to lock it?
In the paths where you insert this assertion, you will be locked.
So the trylock will fail and not cause any blocking or something else.
It's basically not more expensive than your mutex_locked test.
And the !mutex_locked test might not work on UP (Not sure, about
the current implementation.)
