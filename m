Return-Path: <linux-kernel-owner+w=401wt.eu-S1763986AbZAOVBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763986AbZAOVBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbZAOU2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:28:50 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:37166 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305AbZAOU2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:28:49 -0500
Date: Thu, 15 Jan 2009 14:27:33 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
In-Reply-To: <200901151204.23208.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0901151427060.28153@quilx.com>
References: <49649814.4040005@kernel.org> <Pine.LNX.4.64.0901121120280.30369@quilx.com>
 <m1mydwxvtx.fsf@frodo.ebiederm.org> <200901151204.23208.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Rusty Russell wrote:

> I don't think moving per-cpu areas is going to fly.  We do put complex
> datastructures in there. And you're going to need preempt_disable() on
> all per-cpu ops on many archs to make it work (assuming you use
> stop_machine to do the realloc.  Even a rough audit quickly becomes
> overwhelming: 20 of the first 1/4 of DECLARE_PER_CPUs are non-movable
> datastructures.

Ok then lets go for dynamically growing per cpu areas using 2M virtual
mappings.... At least on 64 bit that should be fine.
