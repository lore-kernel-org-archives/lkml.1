Return-Path: <linux-kernel-owner+w=401wt.eu-S1750855AbXCFUev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbXCFUev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXCFUeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:34:50 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:40815 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXCFUet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:34:49 -0500
Date: Tue, 6 Mar 2007 12:34:32 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Bill Irwin <bill.irwin@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Message-ID: <20070306203432.GD18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Hugh Dickins <hugh@veritas.com>, Chuck Ebbert <cebbert@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org> <20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com> <Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Chuck Ebbert wrote:
>> In the 4k/4k stack i386 kernel, is there any fundamental reason it
>> can't be 4k/8k? We seem to be mostly hitting problems in overflowing
>> the IRQ stack... I think. Overhead would only be 4k per CPU for that.

On Tue, Mar 06, 2007 at 07:43:41PM +0000, Hugh Dickins wrote:
> For all of history prior to 2.6.20, there's been the fundamental
> reason that even interrupt stacks need to access current_thread_info,
> and that involved the (THREAD_SIZE - 1) mask.  But 2.6.20's read_pda
> using %gs gets away from that: my guess is that it's now possible
> for i386 to use different sized stacks.

It's unclear to me how the PDA code differs from the methods of elder
kernels apart from the observation that newer cpu revisions have better
performance in/around segmentation relative to arithmetic operations on
%esp. I'm certainly in favor of the move; IRQ stacks could be made
rather deep and cheaply at that. I may get around to writing it this
week if no one else does it first.


-- wli
