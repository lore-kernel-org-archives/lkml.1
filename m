Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZKEI1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZKEI1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbZKEI1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:27:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41208 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbZKEI1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:27:35 -0500
Date: Thu, 5 Nov 2009 09:27:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Remove rss batching from copy_page_range()
Message-ID: <20091105082735.GP31511@one.firstfloor.org>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1> <alpine.DEB.1.10.0911041415480.7409@V090114053VZO-1> <87my3280mb.fsf@basil.nowhere.org> <alpine.DEB.1.10.0911041640340.17859@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911041640340.17859@V090114053VZO-1>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 05:02:12PM -0500, Christoph Lameter wrote:
> On Wed, 4 Nov 2009, Andi Kleen wrote:
> 
> > > With per cpu counters in mm there is no need for batching
> > > mm counter updates anymore. Update counters directly while
> > > copying pages.
> >
> > Hmm, but with all the inlining with some luck the local
> > counters will be in registers. That will never be the case
> > with the per cpu counters.
> 
> The function is too big for that to occur and the counters have to be

If it's only called once then gcc doesn't care about size.

> preserved across function calls. The code is shorter with the patch
> applied:

I see. Thanks for the data.

-Andi
