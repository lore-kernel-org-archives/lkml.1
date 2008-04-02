Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYDBVZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYDBVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYDBVZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:25:19 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:50180
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbYDBVZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:25:18 -0400
Date: Wed, 2 Apr 2008 23:25:15 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: EMM: Fixup return value handling of emm_notify()
Message-ID: <20080402212515.GS19189@duo.random>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com> <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0804021202450.28436@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021202450.28436@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 12:03:50PM -0700, Christoph Lameter wrote:
> +			/*
> +			 * Callback may return a positive value to indicate a count
> +			 * or a negative error code. We keep the first error code
> +			 * but continue to perform callbacks to other subscribed
> +			 * subsystems.
> +			 */
> +			if (x && result >= 0) {
> +				if (x >= 0)
> +					result += x;
> +				else
> +					result = x;
> +			}
>  		}
> +

Now think of when one of the kernel janitors will micro-optimize
PG_dirty to be returned by invalidate_page so a single set_page_dirty
will be invoked... Keep in mind this is a kernel internal APIs, ask
Greg if we can change it in order to optimize later in the future. I
think my #v9 is optimal enough while being simple at the same time,
but anyway it's silly to be hardwired to such an interface that worst
of all requires switch statements instead of proper pointer to
functions and a fixed set of parameters and retval semantics for all
methods.
