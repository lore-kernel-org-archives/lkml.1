Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXIFI2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXIFI2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 04:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbXIFI2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 04:28:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52325 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbXIFI2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 04:28:37 -0400
Date: Thu, 6 Sep 2007 14:11:46 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Florian Lohoff <flo@rfc822.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
In-Reply-To: <20070906082301.GB21929@gondor.apana.org.au>
Message-ID: <alpine.LFD.0.999.0709061409120.3781@enigma.security.iitk.ac.in>
References: <20070902184439.GA14306@paradigm.rfc822.org>
 <6bffcb0e0709021659o3856cd06gabc054c949a84397@mail.gmail.com>
 <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in>
 <20070906082301.GB21929@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Sep 2007, Herbert Xu wrote:

> On Thu, Sep 06, 2007 at 10:32:33AM +0530, Satyam Sharma wrote:
> > 
> > > > [  382.529041]  [<c02c8abc>] dev_close+0x24/0x67
> > > > [  382.529052]  [<e01f402b>] ieee80211_master_stop+0x4a/0x6d [mac80211]
> 
> This is where the bug is.  You cannot call dev_close from an
> atomic context as i33380211_master_stop does it within spin
> locks.

Doh, of course! I must be blind ... and wait_for_completion()'s
might_sleep() clearly didn't trigger earlier because Florian must've
had CONFIG_DEBUG_SPINLOCK_SLEEP off in his .config ...
