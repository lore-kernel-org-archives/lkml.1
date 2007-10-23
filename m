Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbXJWTfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbXJWTfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXJWTfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:35:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58121 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752110AbXJWTfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:35:05 -0400
Date: Tue, 23 Oct 2007 12:35:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
In-Reply-To: <20071023181615.GA10377@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
References: <20071023181615.GA10377@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Alexey Dobriyan wrote:

> Nasty OOM killings appear during massive parallel kernel builds with
> SLUB, but not with SLAB. By nasty I mean, cc1 processes are killed --
> object files in .ccache and tree are corrupted which makes me to
> blow up them entirely.

Hmmmm... Memory is corrupted? I guess a race destroys memory? 

> 
> With SLAB this workload never went to OOM killer.
> With SLUB and pretty much all debugging enabled, it finishes to the end
> (albeit slowly).
> With SLUB and no debugging, OOM killer kicks in.

Not sure what this is. Maybe the slowing SLUB solves the race.
Could you try and boot with

slub_debug=F

to enable limited debugging?

> cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Regular Order 0 alloc .... but why is there no memory available , 
reclaimed?

