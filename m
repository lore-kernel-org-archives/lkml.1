Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXHTXTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXHTXTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXHTXTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:19:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37064 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752621AbXHTXTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:19:48 -0400
Date: Mon, 20 Aug 2007 16:19:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 7/7] Switch of PF_MEMALLOC during writeout
In-Reply-To: <p73ps1hztwp.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708201618060.32662@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com> <20070820215317.441134723@sgi.com>
 <p73ps1hztwp.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Aug 2007, Andi Kleen wrote:

> Christoph Lameter <clameter@sgi.com> writes:
> 
> > Switch off PF_MEMALLOC during both direct and kswapd reclaim.
> > 
> > This works because we are not holding any locks at that point because
> > reclaim is essentially complete. The write occurs when the memory on
> > the zones is at the high water mark so it is unlikely that writeout
> > will get into trouble. If so then reclaim can be called recursively to
> > reclaim more pages.
> 
> What would stop multiple recursions in extreme low memory cases? Seems 
> risky to me and risking stack overflow.  Perhaps define another flag to catch that?

Right. I am not sure exactly how to handle that. There is also the issue 
of the writes being deferred. I thought maybe of using pdflush to writeout 
the pages? Maybe increase priority of the pdflush so that it runs 
immediately when notified. Shrink_page_list would gather the dirty pages 
in pvecs and then forward to a pdflush. That may make the whole thing much 
cleaner.

Opinions?


