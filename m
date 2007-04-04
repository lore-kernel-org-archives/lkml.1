Return-Path: <linux-kernel-owner+w=401wt.eu-S2992847AbXDDKcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992847AbXDDKcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992844AbXDDKcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:32:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992843AbXDDKcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:32:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1175659331.690672.592289266160.qpush@grosgo> 
References: <1175659331.690672.592289266160.qpush@grosgo> 
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/14] Pass MAP_FIXED down to get_unmapped_area 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 04 Apr 2007 11:31:55 +0100
Message-ID: <23370.1175682715@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> This serie of patches moves the logic to handle MAP_FIXED down to the
> various arch/driver get_unmapped_area() implementations, and then changes
> the generic code to always call them. The hugetlbfs hacks then disappear
> from the generic code.

This sounds like get_unmapped_area() is now doing more than it says on the
tin.  As I understand it, it's to be called to locate an unmapped area when
one wasn't specified by MAP_FIXED, and so shouldn't be called if MAP_FIXED is
set.

Admittedly, on NOMMU, it's also used to find the location of quasi-memory
devices such as framebuffers and ramfs files, but that's not a great deviation
from the original intent.

Perhaps a change of name is in order for the function?

> Since I need to do some special 64K pages mappings for SPEs on cell, I need
> to work around the first problem at least. I have further patches thus
> implementing a "slices" layer that handles multiple page sizes through
> slices of the address space for use by hugetlbfs, the SPE code, and possibly
> others, but it requires that serie of patches first/

That makes it sound like there should be an "unget" too for when an error
occurs between ->get_unmapped_area() being called and ->mmap() returning
successfully.

David
