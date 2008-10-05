Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYJEVK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYJEVK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYJEVKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:10:47 -0400
Received: from ozlabs.org ([203.10.76.45]:52474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbYJEVKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:10:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 3/4] cpu alloc: The allocator
Date: Mon, 6 Oct 2008 07:10:43 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
References: <20080929193500.470295078@quilx.com> <20081003003342.4d592c1f.akpm@linux-foundation.org> <48E614A0.60209@linux-foundation.org>
In-Reply-To: <48E614A0.60209@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810060810.43511.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 22:48:32 Christoph Lameter wrote:
> Andrew Morton wrote:
> > But I'd have though that it would be possible to only allocate the
> > storage for online CPUs.  That would be a pretty significant win for
> > some system configurations?
>
> We  have tried that but currently the kernel (core and in particular arch
> code) keeps state for all possible cpus in percpu segments. Would require
> more extensive cleanup of numerous arches to do.

It shouldn't be a big win, since possible ~= online for most systems.  And 
having all the per-cpu users register online and offline cpu callbacks is 
error prone and a PITA.

Rusty.
