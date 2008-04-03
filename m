Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbYDCKlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbYDCKlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 06:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYDCKlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 06:41:03 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14841 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbYDCKlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 06:41:01 -0400
Subject: Re: EMM: Fixup return value handling of emm_notify()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Hugh Dickins <hugh@veritas.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
In-Reply-To: <Pine.LNX.4.64.0804021427210.30516@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com>
	 <20080401205635.793766935@sgi.com> <20080402064952.GF19189@duo.random>
	 <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0804021202450.28436@schroedinger.engr.sgi.com>
	 <20080402212515.GS19189@duo.random>
	 <Pine.LNX.4.64.0804021427210.30516@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 12:40:46 +0200
Message-Id: <1207219246.8514.817.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 14:33 -0700, Christoph Lameter wrote:
> On Wed, 2 Apr 2008, Andrea Arcangeli wrote:
> 
> > but anyway it's silly to be hardwired to such an interface that worst
> > of all requires switch statements instead of proper pointer to
> > functions and a fixed set of parameters and retval semantics for all
> > methods.
> 
> The EMM API with a single callback is the simplest approach at this point. 
> A common callback for all operations allows the driver to implement common 
> entry and exit code as seen in XPMem.

It seems to me that common code can be shared using functions? No need
to stuff everything into a single function. We have method vectors all
over the kernel, we could do a_ops as a single callback too, but we
dont.

FWIW I prefer separate methods.

> I guess we can complicate this more by switching to a different API or 
> adding additional emm_xxx() callback if need be but I really want to have 
> a strong case for why this would be needed. There is the danger of 
> adding frills with special callbacks in this and that situation that could 
> make the notifier complicated and specific to a certain usage scenario. 
> 
> Having this generic simple interface will hopefully avoid such things.
> 
> 

