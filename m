Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZHGB13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZHGB13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZHGB12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:27:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38726 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbZHGB11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:27:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 7 Aug 2009 10:25:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Avi Kivity <avi@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Rik van Riel <riel@redhat.com>, "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-Id: <20090807102528.e4af0c21.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A7AACF1.9040400@redhat.com>
References: <20090805024058.GA8886@localhost>
	<4A79C70C.6010200@redhat.com>
	<9EECC02A4CC333418C00A85D21E89326B651C1FE@azsmsx502.amr.corp.intel.com>
	<4A79D88E.2040005@redhat.com>
	<9EECC02A4CC333418C00A85D21E89326B651C21C@azsmsx502.amr.corp.intel.com>
	<4A7AA0CF.2020700@redhat.com>
	<20090806092516.GA18425@localhost>
	<4A7AA3FF.9070808@redhat.com>
	<20090806093507.GA24669@localhost>
	<4A7AA999.8050309@redhat.com>
	<20090806095905.GA30410@localhost>
	<4A7AACF1.9040400@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Aug 2009 13:14:09 +0300
Avi Kivity <avi@redhat.com> wrote:

> On 08/06/2009 12:59 PM, Wu Fengguang wrote:
> >> Do we know for a fact that only stack pages suffer, or is it what has
> >> been noticed?
> >>      
> >
> > It shall be the first case: "These pages are nearly all stack pages.",
> > Jeff said.
> >    
> 
> Ok.  I can't explain it.  There's no special treatment for guest stack 
> pages.  The accessed bit should be maintained for them exactly like all 
> other pages.
> 
> Are they kernel-mode stack pages, or user-mode stack pages (the 
> difference being that kernel mode stack pages are accessed through large 
> ptes, whereas user mode stack pages are accessed through normal ptes).
> 


Hmm, finally, memcg's problem ?
just as an experiment, how following works ?

 - memory.limit_in_bytes = 128MB
 - memory.memsw.limit_in_bytes = 160MB

By this, if mamory+swap usage hits 160MB, no swap more. 
But plz take care of OOM.

THanks,
-Kame

