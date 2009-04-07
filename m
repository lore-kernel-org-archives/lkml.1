Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZDGCZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZDGCZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZDGCZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:25:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:46144 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZDGCZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:25:10 -0400
Date: Tue, 7 Apr 2009 11:24:39 +0900
To: beckyb@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Subject: Re: [PATCH 5/7] swiotlb: (re)Create swiotlb_unmap_single
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1238810209-24499-6-git-send-email-beckyb@kernel.crashing.org>
References: <1238810209-24499-4-git-send-email-beckyb@kernel.crashing.org>
	<1238810209-24499-5-git-send-email-beckyb@kernel.crashing.org>
	<1238810209-24499-6-git-send-email-beckyb@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090407112247W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 07 Apr 2009 11:24:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Apr 2009 20:56:47 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> This mirrors the current swiotlb_sync_single() setup
> where the swiotlb_unmap_single() function is static to this
> file and contains the logic required to determine if we need
> to call actual sync_single.  Previously, swiotlb_unmap_page
> and swiotlb_unmap_sg were duplicating very similar code.
> The duplicated code has also been reformatted for
> readability.
> 
> Note that the swiotlb_unmap_sg code was previously doing
> a complicated comparison to determine if an addresses needed
> to be unmapped where a simple is_swiotlb_buffer() call
> would have sufficed.
> 
> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> ---
>  lib/swiotlb.c |   36 +++++++++++++++++++++++-------------
>  1 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index af2ec25..602315b 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c

I don't think 'swiotlb_unmap_single' name is appropriate.

swiotlb_unmap_single sounds like an exported function that IOMMUs can
use (and it was) however it should not be.
