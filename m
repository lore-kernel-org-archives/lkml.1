Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYBFTsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYBFTsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYBFTsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:48:38 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37738 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYBFTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:48:37 -0500
Date: Wed, 6 Feb 2008 19:48:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       Mika Lawando <rzryyvzy@trashmail.net>
Subject: Re: What is the limit size of tmpfs /dev/shm ?
In-Reply-To: <47AA0A2E.30701@zytor.com>
Message-ID: <Pine.LNX.4.64.0802061938120.32204@blonde.site>
References: <47A9CA0E.3030507@wpkg.org> <Pine.LNX.4.64.0802061517380.8470@blonde.site>
 <47AA0A2E.30701@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, H. Peter Anvin wrote:
> Hugh Dickins wrote:
> > 
> > Don't forget that tmpfs overflows into swap, so you could save money
> > by adding adding more swap and cutting down on the RAM: though of
> > course that will perform very poorly once it's actually using the
> > swap, probably not the direction you want to go in.
> 
> It can still outperform conventional disk filesystems, however, mostly because
> it doesn't have to worry one iota about consistency.

In theory, yes, and should be true in practice before it hits swap.
But I think you'll find our swap handling is too primitive for tmpfs
to perform well once we hit swap.  Most filesystems pay considerable
attention to good performance within their constraints of correctness.
Whereas with tmpfs we've just never worried about the performance once
swapping.  It's used so you don't lose your data, but if you're really
expecting to be going to disk very much, better start with a filesystem
really designed for that.

Hugh
