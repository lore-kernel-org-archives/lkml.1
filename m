Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbXF0P1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbXF0P1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbXF0P1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:27:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:47701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbXF0P1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:27:11 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: dma_mapping_ops for i386
Date: Wed, 27 Jun 2007 17:26:50 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Tony Luck <tony.luck@intel.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>
References: <46817016.7090400@goop.org> <200706270021.11434.ak@suse.de> <468270F5.7040408@goop.org>
In-Reply-To: <468270F5.7040408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271726.51013.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 16:15:17 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Ok, if you can do it without ifdefs. 
> >   
> 
> That should be OK.  All the existing i386 mapping operations would just 
> have their own ops structure, right?

I just mention it because many people's ideas of merging files
seem to add lots of ifdefs which is imho the totally wrong thing
to do.

> > And no swiotlb on i386; that is something that is completely broken
> > in upstream Xen and needs to be fixed properly anyways.
> >   
> 
> Hm, OK.  I'm not really familiar with the issues here.  What are they?  
> Looks like Jan has made a number of Xen-ish changes to lib/swiotlb.c; 
> are more changes be needed?

See the recent "quiet down swiotlb warnings" thread which uncovered
quite some corpses in Xen's current IO setup.

Xen apparently bounces for multi page IOs which get merged from block
lists because the block layer doesn't know they are not really 
continuous in machine memory.

Proper fix is to tell the block layer to not merge in the first
place instead.

And probably some similar mechanism for network drivers that limits
MTUs.

Maybe we'll still need a simple bouncing mechanism for other obscure
devices with large IOs then, but I would very much prefer if it wasn't 
swiotlb and could be solved some other way.

-Andi
