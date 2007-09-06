Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbXIFIXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbXIFIXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 04:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXIFIXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 04:23:13 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4025 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753515AbXIFIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 04:23:12 -0400
Date: Thu, 6 Sep 2007 16:23:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Satyam Sharma <satyam@infradead.org>
Cc: Florian Lohoff <flo@rfc822.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
Message-ID: <20070906082301.GB21929@gondor.apana.org.au>
References: <20070902184439.GA14306@paradigm.rfc822.org> <6bffcb0e0709021659o3856cd06gabc054c949a84397@mail.gmail.com> <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 10:32:33AM +0530, Satyam Sharma wrote:
> 
> > > [  382.529041]  [<c02c8abc>] dev_close+0x24/0x67
> > > [  382.529052]  [<e01f402b>] ieee80211_master_stop+0x4a/0x6d [mac80211]

This is where the bug is.  You cannot call dev_close from an
atomic context as i33380211_master_stop does it within spin
locks.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
