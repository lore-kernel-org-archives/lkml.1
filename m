Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYISRqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYISRqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbYISRqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:46:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:41281 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbYISRql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:46:41 -0400
Subject: Re: Populating multiple ptes at fault time
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <48D17E75.80807@redhat.com>
References: <48D142B2.3040607@goop.org>  <48D17E75.80807@redhat.com>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 10:45:03 -0700
Message-Id: <1221846303.8077.27.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-17 at 15:02 -0700, Avi Kivity wrote:
> Jeremy Fitzhardinge wrote:
> > Minor faults are easier; if the page already exists in memory, we should
> > just create mappings to it.  If neighbouring pages are also already
> > present, then we can can cheaply create mappings for them too.
> >
> >   
> 
> One problem is the accessed bit.  If it's unset, the shadow code cannot 
> make the pte present (since it has to trap in order to set the accessed 
> bit); if it's set, we're lying to the vm.
> 
> This doesn't affect Xen, only kvm.

Other archs too. On powerpc, !accessed -> not hashed (or not in the TLB
for SW loaded TLB platforms). 

Ben.


