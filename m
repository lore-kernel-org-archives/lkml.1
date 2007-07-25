Return-Path: <linux-kernel-owner+w=401wt.eu-S935376AbXGYSyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376AbXGYSyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763843AbXGYSxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:53:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53617 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756741AbXGYSxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:53:47 -0400
Date: Wed, 25 Jul 2007 11:53:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Johannes Berg <johannes@sipsolutions.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] fix slub krealloc()
In-Reply-To: <1185352857.4006.4.camel@johannes.berg>
Message-ID: <Pine.LNX.4.64.0707251153050.8731@schroedinger.engr.sgi.com>
References: <1184773331.4002.4.camel@johannes.berg> 
 <20070723133206.2220db7e@schroedinger.engr.sgi.com> 
 <20070723134713.2b1218bd.akpm@linux-foundation.org> 
 <20070723143724.1d0b26eb@schroedinger.engr.sgi.com> <1185352857.4006.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Johannes Berg wrote:

> > 
> > There is no use of ZERO_OR_NULL ptr in krealloc. Linus added a check to
> > ksize() instead so that ksize(NULL) returns 0 instead of failing.
> 
> However, this still doesn't fix the other corner case I pointed out:
> krealloc(NULL, 0, GFP_KERNEL) will give you a NULL pointer instead of a
> ZERO_SIZE_PTR afaict.

It will give you a ZERO_SIZE_PTR

void *krealloc(const void *p, size_t new_size, gfp_t flags)
{
        void *ret;
        size_t ks;

        if (unlikely(!new_size)) {
                kfree(p);
                return ZERO_SIZE_PTR;
        }



