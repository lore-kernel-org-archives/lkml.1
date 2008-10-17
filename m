Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYJQRfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYJQRfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbYJQRfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:35:17 -0400
Received: from lazybastard.de ([212.112.238.170]:44941 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbYJQRfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:35:14 -0400
Date: Fri, 17 Oct 2008 19:34:55 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed read-only filesystem
Message-ID: <20081017173455.GB8076@logfs.org>
References: <E1KqrTW-0001x8-3h@dylan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1KqrTW-0001x8-3h@dylan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 October 2008 16:42:50 +0100, Phillip Lougher wrote:
> 
> Codewise all of the packed bit-fields and the swap macros have been removed in
> favour of aligned structures and in-line swapping using leXX_to_cpu().  The
> code has also been extensively restructured, reformatted to kernel coding
> standards and commented.

Excellent!  The data structures look good and I don't see a reason for
another format change.  Which means the main reason against merging the
code has gone.  Your style differs from other kernel code and in a
number of cases it would be nice to be more consistent with existing
conventions.  It would certainly help others when reading the code.  And
of course, one way to do so it to just merge and wait for some janitors
to notice squashfs and send patches. :)

I have to admit I am scared of this function:
+int squashfs_read_metadata(struct super_block *s, void *buffer,
+                               long long block, unsigned int offset,
+                               int length, long long *next_block,
+                               unsigned int *next_offset)

It takes seven parameters, five of which look deceptively similar to me.
Almost every time I see a call to this function, my mind goes blank.

There must be some way to make this function a bit more agreeable.  One
option is to fuse the "block" and "offset" parameters into a struct and
just pass two sets of this struct.  Another would be to combine the two
sets of addresses into a single one.  A quick look at some of the
callers shows seems to favor that approach.

	squashfs_read_metadata(..., block, offset, ..., &block, &offset)
Could become
	squashfs_read_metadata(..., &block, &offset, ...)

But again, such a change is no showstopper for mainline inclusion.

> Anyway that's my case for inclusion.  If any readers want Squashfs
> mainlined it's probably now a good time to offer support!

Please no.  A large amount of popular support would only bring you into
the reiser4 league.  Bad arguments don't improve when repeated.

Support in the form of patches would be a different matter, though.

Jörn

-- 
Mac is for working,
Linux is for Networking,
Windows is for Solitaire!
-- stolen from dc
