Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXCFTnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXCFTnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933299AbXCFTnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:43:39 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:10186 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbXCFTni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:43:38 -0500
X-AuditID: d80ac287-9ff9dbb000002978-0f-45edc4693e55 
Date: Tue, 6 Mar 2007 19:43:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Chuck Ebbert <cebbert@redhat.com>
cc: Bill Irwin <bill.irwin@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
In-Reply-To: <45EDBA1B.8050007@redhat.com>
Message-ID: <Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com>
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org>
 <20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 06 Mar 2007 19:43:37.0613 (UTC) FILETIME=[BBEBC3D0:01C76027]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Chuck Ebbert wrote:
> 
> In the 4k/4k stack i386 kernel, is there any fundamental reason it
> can't be 4k/8k? We seem to be mostly hitting problems in overflowing
> the IRQ stack... I think. Overhead would only be 4k per CPU for that.

For all of history prior to 2.6.20, there's been the fundamental
reason that even interrupt stacks need to access current_thread_info,
and that involved the (THREAD_SIZE - 1) mask.  But 2.6.20's read_pda
using %gs gets away from that: my guess is that it's now possible
for i386 to use different sized stacks.

Hugh
