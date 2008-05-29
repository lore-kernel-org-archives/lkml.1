Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYE2UbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYE2UbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbYE2Uaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:30:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60096 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760270AbYE2Uah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:30:37 -0400
Date: Thu, 29 May 2008 13:30:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Frysinger <vapier.adi@gmail.com>
cc: David Howells <dhowells@redhat.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <8bd0f97a0805291325w7d435e89h4de614547fb1bc7f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805291329270.7207@schroedinger.engr.sgi.com>
References: <2874.1211980355@redhat.com>  <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
  <24762.1211983758@redhat.com>  <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com>
  <7613.1211996335@redhat.com>  <8bd0f97a0805281335q7a26be97ie83feef6e7da2276@mail.gmail.com>
  <29553.1212066208@redhat.com> <8bd0f97a0805291325w7d435e89h4de614547fb1bc7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Mike Frysinger wrote:

> On Thu, May 29, 2008 at 9:03 AM, David Howells wrote:
> > Mike Frysinger <vapier.adi@gmail.com> wrote:
> >> > I fixed it by setting ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN.
> >>
> >> what was the change exactly ?
> >
> > The attached patch.
> >
> > diff --git a/include/asm-frv/mem-layout.h b/include/asm-frv/mem-layout.h
> > +#define        ARCH_KMALLOC_MINALIGN           8
> > +#define        ARCH_SLAB_MINALIGN              8
> 
> yeah, we were already doing that ... and the problem we had that i
> referred to seems to be merged already into mainline, so you shouldnt
> run into it unless you're using older kernel versions

You should not have to do this. This is the default alignment that also 
SLOB needs to follow. We need to align structures correctly for access to 
long long's.


