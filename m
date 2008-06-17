Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYFQT32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYFQT32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 15:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbYFQT3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 15:29:20 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:46811 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYFQT3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 15:29:19 -0400
Subject: Re: [PATCH][RFC] fix kernel BUG at mm/migrate.c:719! in
	2.6.26-rc5-mm3
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806171925200.21436@blonde.site>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	 <20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
	 <1213724798.8707.41.camel@lts-notebook>
	 <Pine.LNX.4.64.0806171925200.21436@blonde.site>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 17 Jun 2008 15:28:42 -0400
Message-Id: <1213730922.8707.57.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 19:33 +0100, Hugh Dickins wrote:
> On Tue, 17 Jun 2008, Lee Schermerhorn wrote:
> > 
> > Now I wonder if the assertion that newpage count == 1 could be violated?
> > I don't see how.  We've just allocated and filled it and haven't
> > unlocked it yet, so we should hold the only reference.  Do you agree?
> 
> Disagree: IIRC, excellent example of the kind of assumption
> that becomes invalid with Nick's speculative page references.
> 
> Someone interested in the previous use of the page may have
> incremented the refcount, and in due course will find that
> it's got reused for something else, and will then back off.
> 

Yeah.  Kosaki-san mentioned that we'd need some rework for the
speculative page cache work.  Looks like we'll need to drop the
VM_BUG_ON().  

I need to go read up on the new invariants we can trust with the
speculative page cache.  

Thanks,
Lee

