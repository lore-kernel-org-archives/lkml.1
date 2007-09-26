Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXIZSfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXIZSfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXIZSfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:35:00 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34360 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbXIZSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:34:59 -0400
Date: Wed, 26 Sep 2007 19:34:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] LBS: fix uninitialized swapper_space
In-Reply-To: <Pine.LNX.4.64.0709241414270.30982@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0709261926060.8443@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0709212144210.13529@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0709241414270.30982@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Christoph Lameter wrote:
> On Fri, 21 Sep 2007, Hugh Dickins wrote:
> 
> > Swapping crashed immediately: must initialize new fields of swapper_space.
> 
> Thanks for finding that. It may be better though to use the new
> mapping_setup() function instead? That way there is no #ifdef.

Probably better, yes.  In -mm Peter is doing an #ifdef CONFIG_SWAP
bdi_init() on swapper_space.  Would make sense to do both together,
perhaps move them to a swapper_space_init() in swap_state.c, saving
his #ifdef too.  I suggest leave such cleanups until one or the
other is mainlined.

Hugh
