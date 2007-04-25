Return-Path: <linux-kernel-owner+w=401wt.eu-S1423361AbXDYSP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423361AbXDYSP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423364AbXDYSP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:15:29 -0400
Received: from ns.suse.de ([195.135.220.2]:54462 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423361AbXDYSP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:15:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 09/25] xen: Account for time stolen by Xen
Date: Wed, 25 Apr 2007 20:15:06 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
References: <20070423215638.563901986@goop.org> <200704251115.49966.ak@suse.de> <462F9A4E.5050905@goop.org>
In-Reply-To: <462F9A4E.5050905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252015.06269.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 20:13:34 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >> +
> >> +	do {
> >> +		state_time = state->state_entry_time;
> >> +		barrier();
> >>     
> >
> > Should be likely rmb
> 
> We discussed this, and decided that it wasn't necessary.  The state is
> always updated by the current CPU, so if it changes under our feet it
> will be because we were preempted, and so that should shoot down any
> speculated reads.

Then the barrier shouldn't be needed at all? 

Anyways needs comments

-Andi
