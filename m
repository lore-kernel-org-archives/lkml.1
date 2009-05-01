Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbZEAMHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbZEAMHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbZEAMHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:07:21 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50479 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbZEAMHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:07:20 -0400
Date: Fri, 1 May 2009 13:05:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] mm: alloc_large_system_hash check order
In-Reply-To: <49FAE12F.4020005@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0905011303490.11574@blonde.anvils>
References: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils>
 <20090430132544.GB21997@csn.ul.ie> <Pine.LNX.4.64.0905011202530.8513@blonde.anvils>
 <49FAE12F.4020005@cosmosbay.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-246501030-1241179429=:11574"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-246501030-1241179429=:11574
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 1 May 2009, Eric Dumazet wrote:
> Hugh Dickins a =C3=A9crit :
> > On Thu, 30 Apr 2009, Mel Gorman wrote:
> >> On Wed, Apr 29, 2009 at 10:09:48PM +0100, Hugh Dickins wrote:
> >>> On an x86_64 with 4GB ram, tcp_init()'s call to alloc_large_system_ha=
sh(),
> >>> to allocate tcp_hashinfo.ehash, is now triggering an mmotm WARN_ON_ON=
CE on
> >>> order >=3D MAX_ORDER - it's hoping for order 11.  alloc_large_system_=
hash()
> >>> had better make its own check on the order.
>=20
> Well, I dont know why, since alloc_large_system_hash() already take
> care of retries, halving size between each tries.

Sorry, I wasn't clear: I just meant that if we keep that
WARN_ON_ONCE(order >=3D MAX_ORDER) in __alloc_pages_slowpath(),
then we need alloc_large_system_hash() to avoid the call to
__get_free_pages() in the order >=3D MAX_ORDER case,
precisely because we're happy with the way it halves and
falls back, so don't want a noisy warning; and now that we know
that it could give that warning, it would be a shame for the
_ONCE to suppress more interesting warnings later.

I certainly did not mean for alloc_large_system_hash() to fail
in the order >=3D MAX_ORDER case, nor did the patch do so.

Hugh
--8323584-246501030-1241179429=:11574--
