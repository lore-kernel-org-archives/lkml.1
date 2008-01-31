Return-Path: <linux-kernel-owner+w=401wt.eu-S933259AbYAaKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbYAaKxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765802AbYAaKxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:53:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbYAaKxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:53:09 -0500
Date: Thu, 31 Jan 2008 05:52:09 -0500
From: Rik van Riel <riel@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, hugh@veritas.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, npiggin@suse.de,
       mztabzr@0pointer.de, mpm@selenic.com
Subject: Re: [PATCH] mm: MADV_WILLNEED implementation for anonymous memory
Message-ID: <20080131055209.6adede04@riellaptop.surriel.com>
In-Reply-To: <20080131110610.GA31090@one.firstfloor.org>
References: <1201714139.28547.237.camel@lappy>
	<20080130144049.73596898.akpm@linux-foundation.org>
	<1201769040.28547.245.camel@lappy>
	<20080131011227.257b9437.akpm@linux-foundation.org>
	<1201772118.28547.254.camel@lappy>
	<20080131014702.705f1040.akpm@linux-foundation.org>
	<1201773206.28547.259.camel@lappy>
	<p73ve5a47yr.fsf@bingen.suse.de>
	<20080131021949.92715ba4.akpm@linux-foundation.org>
	<20080131110610.GA31090@one.firstfloor.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 12:06:10 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > Yeah, the 2.5 switch to physical scanning killed us there.
> > 
> > I still don't know why my
> > allocate-swapspace-according-to-virtual-address change didn't
> > help.  Much.  Marcelo played with that a bit too.
> 
> I've been thinking about just always doing swap on > page clusters. 
> Any reason swapping couldn't be done on e.g. 1MB chunks? 

Don't malloc() and free() hopelessly fragment memory
over time, ensuring that little related data can be
found inside each 1MB chunk if the process is large
enough?  (say, firefox)
