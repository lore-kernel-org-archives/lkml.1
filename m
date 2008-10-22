Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbYJVTze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbYJVTze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbYJVTzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:55:07 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:40840 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018AbYJVTzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:55:05 -0400
Date: Wed, 22 Oct 2008 12:54:30 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Miklos Szeredi <miklos@szeredi.hu>
cc: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
In-Reply-To: <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0810221252570.3562@quilx.com>
References: <1223883004.31587.15.camel@penberg-laptop>
 <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site>
 <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu>
 <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu> <48F378C6.7030206@linux-foundation.org>
 <E1KpOjX-0003dt-AY@pomaz-ex.szeredi.hu> <48FC9CCC.3040006@linux-foundation.org>
 <E1Krz4o-0002Fi-Pu@pomaz-ex.szeredi.hu> <48FCCC72.5020202@linux-foundation.org>
 <E1KrzgK-0002QS-Os@pomaz-ex.szeredi.hu> <48FCD7CB.4060505@linux-foundation.org>
 <E1Ks0QX-0002aC-SQ@pomaz-ex.szeredi.hu> <48FCE1C4.20807@linux-foundation.org>
 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu> <48FE6306.6020806@linux-foundation.org>
 <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0810220822500.30851@quilx.com>
 <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Miklos Szeredi wrote:

> Why?  The kmem_cache_free() doesn't touch the contents of the object,
> does it?

Because filesystem code may be running on other processors which may be 
freeing the dentry.

>> Because the slab starts out with a series of objects left in a slab. It
>> needs to do build a list of objects etc in a way that is independent as
>> possible from the user of the slab page. It does that by locking the slab
>> page so that free operations stall until the reference has been
>> established. If it would not be shutting off frees then the objects could
>> vanish under us.
>
> It doesn't matter.  All we care about is that the dentry is on the
> lru: it's cached but unused.  Every other state (being created,
> active, being freed, freed) is uninteresting.

We cannot figure out that it is on the lru if we do not have a stable 
reference to the object.

> Sure, and all that is possible without doing this messy 2 phase thing.
> Unless I'm still missing something obvious...

Obviously one cannot free or handle an object that may be concurrently 
freed on another processor.

