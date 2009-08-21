Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbZHUSYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbZHUSYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbZHUSYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:24:44 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43365 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbZHUSYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:24:43 -0400
Date: Fri, 21 Aug 2009 23:54:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090821182439.GN29572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost> <4A7AD79E.4020604@redhat.com> <20090816032822.GB6888@localhost> <4A878377.70502@redhat.com> <20090816045522.GA13740@localhost> <9EECC02A4CC333418C00A85D21E89326B6611F25@azsmsx502.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <9EECC02A4CC333418C00A85D21E89326B6611F25@azsmsx502.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dike, Jeffrey G <jeffrey.g.dike@intel.com> [2009-08-17 12:47:29]:

> > Jeff, can you have a look at these stats? Thanks!
> 
> Yeah, I just did after adding some tracing which dumped out the same data.  It looks pretty much the same.  Inactive anon and active anon are pretty similar.  Inactive file and active file are smaller and fluctuate more, but doesn't look horribly unbalanced.
> 
> Below are the stats from memory.stat - inactive_anon, active_anon, inactive_file, active_file, plus some commentary on what's happening.
> 

Interesting.. there seems to be sufficient number of inactive memory,
specifically inactive_file. My biggest suspicion now is passing of
reference info from shadow page tables to host (although to be
honest, I've never looked at that code).

What do the stats for / from within kvm look like?

-- 
	Balbir
