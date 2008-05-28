Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYE1R1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYE1R1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYE1R0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:26:54 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33925 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751169AbYE1R0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:26:53 -0400
Date: Wed, 28 May 2008 10:26:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Howells <dhowells@redhat.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <24762.1211983758@redhat.com>
Message-ID: <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com>
References: <2874.1211980355@redhat.com> <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
 <24762.1211983758@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, David Howells wrote:

> David Howells <dhowells@redhat.com> wrote:
> 
> > Works for SLAB and SLUB.  SLOB breaks well before getting to anything these
> > patches affect.
> 
> Okay...  The problem with SLOB is that it can return large objects (8Kb in this
> case) that aren't 8-byte aligned.  This screws up FRV as it expects to be able
> to use load and store-double instructions, which fault if they don't get
> 8-byte (double register) alignment.

Right. SLAB/SLUB align to long long. SLOB needs to do the same.


