Return-Path: <linux-kernel-owner+w=401wt.eu-S1161097AbXBGJfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161097AbXBGJfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161092AbXBGJfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:35:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21176 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161097AbXBGJfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:35:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=cLSBPJUXrGcOSPkcqA0AB7O4OcATl8hITi8WJe/LpdA9SQdAdwEMV6VVYAaPX8du7
	hPhZVyPelS0oG8mco9eYQ==
Date: Wed, 7 Feb 2007 01:35:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Paul Mundt <lethal@linux-sh.org>, Paul Davies <pauld@cse.unsw.edu.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3 take2] smaps: extract pte walker from smaps code
In-Reply-To: <Pine.LNX.4.64.0702070017360.26926@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0702070124210.22710@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702070017360.26926@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007, Christoph Lameter wrote:

> Clearing reference bits? Ummm... That is a pretty inaccurate measure since 
> reclaim can remove pages and revert the reference bits. It can never work 
> reliably.
> 

It's not intended to work precisely, it's intended to give a good estimate 
of task memory footprint.  There are several different scenarios that can 
interfere with getting a precise measurement via this method; then again 
/proc/pid/smaps is so expensive already because of the iteration through 
VMA's that it's not something you'd do regularly.

Any other suggestions on how to obtain this data is certainly welcome.

> Would it be possible to sync up with the people doing the page table 
> interface?
> 

(+pauld)

Is there an update on Paul Davies' implementation that would allow us to 
iterate through a set of pte's in a vm_area_struct range?

> Could we somehow consolidate smaps and numa_maps?
> 

Sure, but that's beyond the scope of this patchset.  My intention in 
extracting away a new pte_walker was to prevent having two identical 
implementations and it could easily be extracted even further to lib for 
the ioremap case that Paul mentioned.

		David
