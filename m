Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbYDGP46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbYDGP46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761488AbYDGP4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:56:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761489AbYDGP4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:56:31 -0400
Date: Mon, 7 Apr 2008 08:54:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [NFS] Increase size of struct fid raw buffer
In-Reply-To: <1207561677.3635.166.camel@quoit>
Message-ID: <alpine.LFD.1.00.0804070850310.11277@woody.linux-foundation.org>
References: <1207561677.3635.166.camel@quoit>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Apr 2008, Steven Whitehouse wrote:
> 
> GFS2 requires the NFS filehandle buffer to be larger than the
> minimum size as per the bug report: http://lkml.org/lkml/2007/10/24/374
> Its a pretty trivial fix for now and I've done a test which shows
> that it works ok.

I'm not seeing the point of this.

Every single instance of "struct fid" that I saw in a quick grep was 
created not as a "struct fid", but as some other data structure that was 
then cast to a "struct fid *".

So the _underlying_ size of "struct fid" seems to be pretty random, and 
totally unrelated to this declaration.

But admittedly that really was just a quick grep, and maybe I missed 
something. But it seems like this patch doesn't really change anything, 
just largely makes a change in a structure that is apparently used as an 
opaque pointer.

Is there anything that actually uses "struct fid" as an _allocation_ 
entity?

And if not, then that "_u32 raw[6]" should probably be a un-sized "_u32 
raw[]" instead, no?

		Linus
