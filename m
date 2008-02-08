Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYBHWSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYBHWSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYBHWSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:18:12 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:39888 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYBHWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:18:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bLlSryDVdASzOhkWi+idxbXSmDEyU4AZMHgbj7u0WwoYFuRThsVFs1uFlere9i9BQPlcK0X/MrhHmoOMA1h1xQvDuk3VwU5YKuJYuml1SOtZ0M4TpAMlSku2R9HPq0/eIL0wawHo3Ngr4tFmiZTiB0f4kAWH/d0d96YdwZVcec8=
Subject: Re: [PATCH] fix sparse warning from include/linux/mmzone.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
References: <1202417543.31361.5.camel@brick>
	 <20080208135154.ccdac0c1.akpm@linux-foundation.org>
	 <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 14:17:58 -0800
Message-Id: <1202509083.8067.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 14:04 -0800, Linus Torvalds wrote:
> 
> On Fri, 8 Feb 2008, Andrew Morton wrote:
> > >  #ifdef CONFIG_HIGHMEM
> > > -	int zone_idx = zone - zone->zone_pgdat->node_zones;
> > > -	return zone_idx == ZONE_HIGHMEM ||
> > > -		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
> > > +	const int highmem_off = ZONE_HIGHMEM * sizeof(*zone);
> > > +	const int movable_off = ZONE_MOVABLE * sizeof(*zone);
> > > +
> > > +	int zone_off = (unsigned long)zone - (unsigned long)zone->zone_pgdat->node_zones;
> > > +	return zone_off == highmem_off ||
> > > +		(zone_off == movable_off && zone_movable_is_highmem());
> > 
> > hrm.  For my i386 build (and that's where CONFIG_HIGHMEM really matters)
> > this patch makes mm/page_alloc.o six bytes larger, and I don't think the
> > change did much for readability.
> 
> Heh, yeah. That's a very odd way to write it.

As long as you read 'odd' as 'rather dumb'

> 
> It would probably make more sense to just write it as something like
> 
> 	struct zone *base = zone->zone_pgdat->node_zones;
> 
> 	if (zone == base + ZONE_HIGHMEM ||
> 		(zone == base + ZONE_MOVABLE && zone_movable_is_highmem());

s/if/return/ I think.  And missing a closing brace.  Unless I'm (again)
missing something.

Harvey


