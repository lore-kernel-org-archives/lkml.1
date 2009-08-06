Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZHFJZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZHFJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZHFJZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:25:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:62153 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZHFJZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:25:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,332,1246863600"; 
   d="scan'208";a="172934769"
Date: Thu, 6 Aug 2009 17:25:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
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
Message-ID: <20090806092516.GA18425@localhost>
References: <20090805024058.GA8886@localhost> <4A79C70C.6010200@redhat.com> <9EECC02A4CC333418C00A85D21E89326B651C1FE@azsmsx502.amr.corp.intel.com> <4A79D88E.2040005@redhat.com> <9EECC02A4CC333418C00A85D21E89326B651C21C@azsmsx502.amr.corp.intel.com> <4A7AA0CF.2020700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7AA0CF.2020700@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 05:22:23PM +0800, Avi Kivity wrote:
> On 08/05/2009 10:18 PM, Dike, Jeffrey G wrote:
> >> How did you create that 128M memory compartment?
> >>
> >> Did you use cgroups on the host system?
> >>      
> >
> > Yup.
> >
> >    
> >> How much memory do you give your virtual machine?
> >>
> >> That is, how much memory does it think it has?
> >>      
> >
> > 256M.
> >    
> 
> So you're effectively running a 256M guest on a 128M host?
> 
> Do cgroups have private active/inactive lists?

Yes, and they reuse the same page reclaim routines with the global
LRU lists.
