Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbXJDQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbXJDQjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbXJDQjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:39:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbXJDQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:39:10 -0400
Date: Thu, 4 Oct 2007 09:38:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: gurudas pai <gurudas.pai@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG at arch/i386/mm/highmem.c:15!  on
 2.6.23-rc8/rc9
In-Reply-To: <Pine.LNX.4.64.0710041647090.17987@blonde.wat.veritas.com>
Message-ID: <alpine.LFD.0.999.0710040920400.23684@woody.linux-foundation.org>
References: <47048A0C.4020608@oracle.com> <200710040053.19570.nickpiggin@yahoo.com.au>
 <200710040139.04201.nickpiggin@yahoo.com.au> <4704BA1F.4070408@oracle.com>
 <Pine.LNX.4.64.0710041647090.17987@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Oct 2007, Hugh Dickins wrote:
> 
> Very helpful, thanks.  Guru, please try the appended patch, I think
> you'll find it fixes it for you (it did for me, once I'd puzzled out
> why I was failing to reproduce the problem - tests on ext3 don't work).
> Thank you so much for reporting this just in time!

Ouch.

The patch looks obviously correct, to the point that I don't understand 
how this bug happened in the first place.  It seems to have been 
introduced by Nick in d0217ac04ca6591841e5665f518e38064f4e65bd ("mm: fault 
feedback #1") if I read it right.

So "do_nonlinear_fault()" would effectively end up unmapping the PTE 
twice, right? And if I understand the problem right, this wasn't noticed 
immediately, because it probably only matters on:

 - CONFIG_HIGHPTE
*and*
 - a filesystem that allows VM_NONLINEAR, which became very rare with 
   dirty accounting.

Correct?

			Linus
