Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYIDSOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYIDSOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYIDSO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:14:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39991 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYIDSO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:14:27 -0400
Subject: Re: [RFC v3][PATCH 7/9] Infrastructure for shared objects
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <Pine.LNX.4.64.0809040404550.5982@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040404550.5982@takamine.ncl.cs.columbia.edu>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 11:14:22 -0700
Message-Id: <1220552062.23386.35.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 04:05 -0400, Oren Laadan wrote:
> +=== Shared resources (objects)
> +
> +Many resources used by tasks may be shared by more than one task (e.g.
> +file descriptors, memory address space, etc), or even have multiple
> +references from other resources (e.g. a single inode that represents
> +two ends of a pipe).
> +
> +Clearly, the state of shared objects need only be saved once, even if
> +they occur multiple times. We use a hash table (ctx->objhash) to keep
> +track of shared objects in the following manner.
> +
> +On the first encounter, the state is dumped and the object is assigned
> +a unique identifier and also stored in the hash table (indexed by its
> +physical kenrel address). From then on the object will be found in the
> +hash and only its identifier is saved.
> +
> +On restart the identifier is looked up in the hash table; if not found
> +then the state is read, the object is created, and added to the hash
> +table (this time indexed by its identifier). Otherwise, the object in
> +the hash table is used.
> +
> +The interface for the hash table is the following:
> +
> +int cr_obj_get_by_ptr(struct cr_ctx *ctx, void *ptr, unsigned short type);
> +  [checkpoint] find the unique identifier - object reference (objref)
> +  - of the object that is pointer to by ptr (or 0 if not found).
> +
> +int cr_obj_add_ptr(struct cr_ctx *ctx, void *ptr, int *objref,
> +                  unsigned short type, unsigned short flags);
> +  [checkpoint] add the object pointed to by ptr to the hash table if
> +  it isn't already there, and fill its unique identifier (objref); will
> +  return 0 if already found in the has, or 1 otherwise.
> +
> +void *cr_obj_get_by_ref(struct cr_ctx *ctx, int objref, unsigned short type);
> +  [restart] return the pointer to the object whose unique identifier
> +  is equal to objref.
> +
> +int cr_obj_add_ref(struct cr_ctx *ctx, void *ptr, int objref,
> +                  unsigned short type, unsigned short flags);
> +  [restart] add the object with unique identifier objref, pointed to by
> +  ptr to the hash table if it isn't already there; will return 0 if
> +  already found in the has, or 1 otherwise.

Once you get to the point of putting function prototypes in
Documentation/, it's probably a good time to start using kerneldocs. :)

-- Dave

