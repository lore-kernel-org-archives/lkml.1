Return-Path: <linux-kernel-owner+w=401wt.eu-S965741AbXBTAfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741AbXBTAfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965745AbXBTAfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:35:16 -0500
Received: from lazybastard.de ([212.112.238.170]:54293 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965741AbXBTAfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:35:14 -0500
Date: Tue, 20 Feb 2007 00:30:59 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Sorin Faibish <sfaibish@emc.com>, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070220003059.GJ7813@lazybastard.org>
References: <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 February 2007 00:57:50 +0100, Juan Piernas Canovas wrote:
> 
> I understand the problem that you describe with respect to the GC, but 
> let me explain why I think that it has a small impact on DualFS.
> 
> Actually, the GC may become a problem when the number of free segments is 
> 50% or less. If your LFS always guarantees, at least, 50% of free 
> "segments" (note that I am talking about segments, not free space), the 
> deadlock problem disappears, right? This is a quite naive solution, but it 
> works.

I don't see how you can guarantee 50% free segments.  Can you explain
that bit?

> In a traditional LFS, with data and meta-data blocks, 50% of free segments 
> represents a huge amount of wasted disk space. But, in DualFS, 50% of free 
> segments in the meta-data device is not too much. In a typical Ext2, 
> or Ext3 file system, there are 20 data blocks for every meta-data block 
> (that is, meta-data blocks are 5% of the disk blocks used by files). 
> Since files are implemented in DualFS in the same way, we can suppose the 
> same ratio for DualFS (1).

This will work fairly well for most people.  It is possible to construct
metadata-heavy workloads, however.  Many large directories containing
symlinks or special files (char/block devices, sockets, fifos,
whiteouts) come to mind.  Most likely noone of your user will ever want
that, but a malicious attacker might.

That, btw, brings me to a completely unrelated topic.  Having a fixed
ratio a metadata to data is simple to implement, but allowing this ratio
to dynamically change would be nicer for administration.  You can add
that to the Christmas wishlist for the nice boys, if you like.

> Remember, I am supposing a naive implementation of the cleaner. With a 
> cleverer one, the meta-data device can be smaller, and the amount of
> disk space finally wasted can be smaller too. The following paper proposes 
> some improvements:
> 
> - Jeanna Neefe Matthews, Drew Roselli, Adam Costello, Randy Wang, and
>   Thomas Anderson.  "Improving the Performance of Log-structured File
>   Systems with Adaptive Methods".  Proc. Sixteenth ACM Symposium on
>   Operating Systems Principles (SOSP), October 1997, pages 238 - 251.
> 
> BTW, I think that what they propose is very similar to the two-strategies 
> GC that you propose in a separate e-mail.

Will have to read it up after I get some sleep.  It is late.

> The point of all the above is that you must improve the common case, and 
> manage the worst case correctly. And that is the idea behind DualFS :)

A fine principle to work with.  Surprisingly, what is the worst case for
you is the common case for LogFS, so maybe I'm more interested in it
than most people.  Or maybe I'm just more paranoid.

Anyway, keep up the work.  It is an interesting idea to pursue.

Jörn

-- 
He who knows that enough is enough will always have enough.
-- Lao Tsu
