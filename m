Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbXEIKAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbXEIKAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbXEIKA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:00:26 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35003 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbXEIKAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:00:23 -0400
Date: Wed, 9 May 2007 18:59:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Bogus section mismatch errors?
Message-ID: <20070509095954.GA21844@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Linux Kernel List <linux-kernel@vger.kernel.org>
References: <20070508111759.GA26562@flint.arm.linux.org.uk> <20070508115220.GA29160@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508115220.GA29160@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:52:20PM +0200, Sam Ravnborg wrote:
> On Tue, May 08, 2007 at 12:17:59PM +0100, Russell King wrote:
> > WARNING: mm/built-in.o - Section mismatch:
> >  reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x1bd94)
> >  and 'cache_reap'
> > WARNING: mm/built-in.o - Section mismatch:
> >  reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x1bdcc)
> >  and 'cache_reap'
> There are in slab a function that is not marked __init that refer to a function marked
> __init. But the logic surrounding makes it OK.
> 
> I have no fix/workaround for this.
> Andres has suggested that we should mark functions/data that may refer to __init{data}
> with something like: __nowarn and __nowarndata
> 
Here's one I've started getting with the quicklist changes:

WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x1ba5c) and 'quicklist_total_size'

quicklist_total_size() is not marked __init, nor is show_mem() in
arch/sh/mm/init.c, where I've added the reference. Ideas?
