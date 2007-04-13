Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXDMLpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXDMLpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbXDMLpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:45:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbXDMLpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:45:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070413102518.GD31487@wotan.suse.de> 
References: <20070413102518.GD31487@wotan.suse.de>  <20070413100416.GC31487@wotan.suse.de> 
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] generic rwsems 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 13 Apr 2007 12:44:50 +0100
Message-ID: <25428.1176464690@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> I think I should put wait_lock after wait_list, so as to get a better
> packing on most 64-bit architectures.

It makes no difference.  struct lockdep_map contains at least one pointer and
so is going to be 8-byte aligned (assuming it's there at all).  struct
rw_semaphore contains at least one pointer/long, so it will be padded out to
8-byte size.

If you want to make a difference, you'd need to add __attribute__((packed))
but you would need to be very careful with that.

David
