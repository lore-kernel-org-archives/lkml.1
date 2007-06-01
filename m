Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXFABtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXFABtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXFABtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:49:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19533 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbXFABtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:49:11 -0400
Date: Thu, 31 May 2007 18:45:17 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601014517.GT20632@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531231354.GR20632@ca-server1.us.oracle.com> <20070601010129.GA15878@wotan.suse.de> <20070601012440.GS20632@ca-server1.us.oracle.com> <20070601013402.GB28585@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601013402.GB28585@wotan.suse.de>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 03:34:02AM +0200, Nick Piggin wrote:
> > Here's a nasty idea... Would it be valid for ->page_mkwrite to unlock the
> > page, so long as it's returned in a locked state? Though, do we even need
> > the page lock that early? It seemed to me that you were adding it for
> > consistency reasons (I could be wrong though).
> 
> You could do that, but you'd have to probably check that it is
> within i_size after you relock it, I think... yeah, that might
> be the best thing for ocfs to do for now.

Well, ocfs2 already does i_size checks in page_mkwrite, so we're covered
with respect to truncate races.

I'm still not clear though - what was the reason for adding the page locking
there in the 1st place?
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
