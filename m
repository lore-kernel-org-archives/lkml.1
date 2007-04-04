Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbXDDRTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbXDDRTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXDDRTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:19:34 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:5888 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbXDDRTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:19:33 -0400
X-AuditID: d80ac287-94e6abb000000c42-1f-4613de24775a 
Date: Wed, 4 Apr 2007 18:19:28 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andi Kleen <ak@suse.de>
cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mbind and alignment
In-Reply-To: <200704041352.04525.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704041808490.3891@blonde.wat.veritas.com>
References: <20070402204202.GC3316@interface.famille.thibault.fr>
 <200704041352.04525.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 17:19:32.0633 (UTC) FILETIME=[69174090:01C776DD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Andi Kleen wrote:
> > 
> > So one of those should probably be done to free people from headaches:
> > 
> > - document "start" requirement in the manual page
> > - require len to be aligned too, and document the requirements in the
> >   manual page
> > - drop the "start" requirement and just round down the page + adjust
> >   size automatically.
> 
> This annoyed me in the past too. The kernel should have done that alignment
> by itself. But changing it now would be a bad idea because it would
> produce programs that run on newer kernels but break on olders.
> Documenting it is the only sane option left.

It is annoying, but consistent with all mm's msyscall()s: they all
(I bet you'll now point me to an exception or two!) fail if start
is not page aligned, but silently round up len.  UNIX did it like
that.  Documentation is indeed the answer.

Hugh
