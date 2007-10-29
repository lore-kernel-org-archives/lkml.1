Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbXJ2UAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbXJ2UAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbXJ2UAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:00:40 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:38457 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbXJ2UAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:00:39 -0400
Message-ID: <47263BEC.30501@zabbo.net>
Date: Mon, 29 Oct 2007 13:00:44 -0700
From: Zach Brown <zab@zabbo.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Chris Mason <chris.mason@oracle.com>, Anton Altaparmakov <aia21@cam.ac.uk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk> <20071029101001.4378a7cf@think.oraclecorp.com> <47260AB1.9000003@zabbo.net> <472631FE.9070003@google.com>
In-Reply-To: <472631FE.9070003@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Can you clarify what you mean above with an example?  I don't really
> follow.

Sure, take 'tar' as an example.  It'll read files in the order that
their names are returned from directory listing.  This can produce bad
IO patterns because the order in which the file names are returned
doesn't match the order of the file's blocks on disk.  (htree, I'm
looking at you!)

People have noticed that tar-like loads can be sped up greatly just by
sorting the files by their inode number as returned by stat(), never
mind the file blocks themselves.  One example of this is Chris Mason's
'acp'.

  http://oss.oracle.com/~mason/acp/

The logical extension of that is to use FIBMAP to find the order of file
blocks on disk and then doing IO on blocks in sorted order.  It'd take
work to write an app that does this reliably, sure.

In this use the application doesn't actually care what the absolute
numbers are.  It cares about their ordering.  File systems would be able
to chose whatever scheme they wanted for the actual values of the
results from a FIBMAP-alike as long as the sorting resulted in the right
IO patterns.

Arguing that this use is significant enough to justify an addition to
the file system API is a stretch.  I'm just sharing the observation.

- z
