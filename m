Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbXIFMj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbXIFMj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbXIFMjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:39:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50928 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbXIFMjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:39:16 -0400
Date: Thu, 6 Sep 2007 18:22:24 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Johannes Berg <johannes@sipsolutions.net>
cc: Herbert Xu <herbert@gondor.apana.org.au>, Florian Lohoff <flo@rfc822.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
       Michael Wu <flamingice@sourmilk.net>
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
In-Reply-To: <1189080575.28781.65.camel@johannes.berg>
Message-ID: <alpine.LFD.0.999.0709061818270.3781@enigma.security.iitk.ac.in>
References: <20070902184439.GA14306@paradigm.rfc822.org> 
 <6bffcb0e0709021659o3856cd06gabc054c949a84397@mail.gmail.com> 
 <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in> 
 <20070906082301.GB21929@gondor.apana.org.au>
 <1189080575.28781.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Sep 2007, Johannes Berg wrote:

> On Thu, 2007-09-06 at 16:23 +0800, Herbert Xu wrote:
> > On Thu, Sep 06, 2007 at 10:32:33AM +0530, Satyam Sharma wrote:
> > > 
> > > > > [  382.529041]  [<c02c8abc>] dev_close+0x24/0x67
> > > > > [  382.529052]  [<e01f402b>] ieee80211_master_stop+0x4a/0x6d [mac80211]
> > 
> > This is where the bug is.  You cannot call dev_close from an
> > atomic context as i33380211_master_stop does it within spin
> > locks.
> 
> Hah, I suspected as much but didn't have a chance to look yet. I had
> plans to replace that sub_if_list with an RCU list and not require the
> lock there, but that's far off.

Unless I missed something obvious (let me know if that's the case! :-)
an RCU-protected list would suffer the same fate. list_for_each_xxx_rcu()
must be under rcu_read_lock() which == preempt_disable() ...
