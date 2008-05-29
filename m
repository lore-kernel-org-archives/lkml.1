Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbYE2V3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbYE2V3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbYE2V3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:29:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56803 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753998AbYE2V3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:29:31 -0400
Date: Thu, 29 May 2008 14:29:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Frysinger <vapier.adi@gmail.com>
cc: David Howells <dhowells@redhat.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <8bd0f97a0805291351t43ea6d2eue1cdde531aa2fc2c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805291428240.7562@schroedinger.engr.sgi.com>
References: <2874.1211980355@redhat.com>  <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
  <24762.1211983758@redhat.com>  <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com>
  <7613.1211996335@redhat.com>  <8bd0f97a0805281335q7a26be97ie83feef6e7da2276@mail.gmail.com>
  <29553.1212066208@redhat.com>  <8bd0f97a0805291325w7d435e89h4de614547fb1bc7f@mail.gmail.com>
  <Pine.LNX.4.64.0805291329270.7207@schroedinger.engr.sgi.com>
 <8bd0f97a0805291351t43ea6d2eue1cdde531aa2fc2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Mike Frysinger wrote:

> > You should not have to do this. This is the default alignment that also
> > SLOB needs to follow. We need to align structures correctly for access to
> > long long's.
> 
> are you saying that slob is broken ?  i see in mm/slob.c:
> #ifndef ARCH_KMALLOC_MINALIGN
> #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
> #endif
> -mike

It should be long long instead.

SLUB:

#ifndef ARCH_KMALLOC_MINALIGN
#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
#endif

SLAB:

#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
 
