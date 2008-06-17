Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYFQSev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYFQSev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbYFQSen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:34:43 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45889 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYFQSem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:34:42 -0400
Date: Tue, 17 Jun 2008 19:33:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [PATCH][RFC] fix kernel BUG at mm/migrate.c:719! in 2.6.26-rc5-mm3
In-Reply-To: <1213724798.8707.41.camel@lts-notebook>
Message-ID: <Pine.LNX.4.64.0806171925200.21436@blonde.site>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> 
 <20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp> <1213724798.8707.41.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, Lee Schermerhorn wrote:
> 
> Now I wonder if the assertion that newpage count == 1 could be violated?
> I don't see how.  We've just allocated and filled it and haven't
> unlocked it yet, so we should hold the only reference.  Do you agree?

Disagree: IIRC, excellent example of the kind of assumption
that becomes invalid with Nick's speculative page references.

Someone interested in the previous use of the page may have
incremented the refcount, and in due course will find that
it's got reused for something else, and will then back off.

Hugh
