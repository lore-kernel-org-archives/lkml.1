Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYAWOS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYAWOS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYAWOSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:18:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45824 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751824AbYAWOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:18:16 -0500
Date: Wed, 23 Jan 2008 08:18:14 -0600
From: Robin Holt <holt@sgi.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Robin Holt <holt@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
Message-ID: <20080123141814.GE3058@sgi.com>
References: <478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <4797384B.7080200@redhat.com> <20080123131939.GJ26420@sgi.com> <47974B54.30407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47974B54.30407@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 03:12:36PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> >> That would render the notifies useless for Xen too.  Xen needs to
> >> intercept the actual pte clear and instead of just zapping it use the
> >> hypercall to do the unmap and release the grant.
> > 
> > We are tackling that by having our own page table hanging off the
> > structure representing our seg (thing created when we do the equiv of
> > your grant call).
> 
> --verbose please.  I don't understand that "own page table" trick.  Is
> that page table actually used by the processor or is it just used to
> maintain some sort of page list?

We have a seg structure which is similar to some structure you probably
have which describes the grant.  One of the things hanging off that
seg structure is essentially a page table containing PFNs with their
respective flags (XPMEM specific and not the same as the pfn flags in
the processor page tables).

Thanks,
Robin
