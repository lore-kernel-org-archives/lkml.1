Return-Path: <linux-kernel-owner+w=401wt.eu-S1945938AbXBIAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945938AbXBIAiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945945AbXBIAiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:38:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:28963 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945938AbXBIAiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:38:14 -0500
Date: Thu, 8 Feb 2007 16:38:01 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc][patch 0/3] a faster buffered write deadlock fix?
Message-ID: <20070209003801.GX14799@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208105437.26443.35653.sendpatchset@linux.site>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 02:07:15PM +0100, Nick Piggin wrote:
> The problem is that the existing aops interface is crap. "correct, fast,
> compatible -- choose any 2"

Agreed. There's lots of problems with the interface (imho), but my biggest
two issues are the page lock being held on ->prepare_write() /
->commit_write() and the fact that the file system only sees the write one
page at a time


> So I have finally finished a first slightly-working draft of my new aops
> op (perform_write) proposal. I would be interested to hear comments about
> it.  Most of my issues and concerns are in the patch headers themselves,
> so reply to them.

I like ->perform_write(). It allows the file system to make re-use of the
checks in the generic write path, but gives a maximum amount of information
about the overall operation to be done. There's an added advantage in that
some file systems (ocfs2 is one of these) want to be more careful about
ordering page locks, which should be much easier with it.

If this goes in, it could probably be helpful to me in some of the code I'm
currently writing which needs to be better about page lock / cluster lock
ordering and wants to see as much of the (allocating) writes as possible.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
