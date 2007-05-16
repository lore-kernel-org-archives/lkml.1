Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbXEPMzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbXEPMzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbXEPMzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:55:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55088 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758871AbXEPMzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:55:37 -0400
Date: Wed, 16 May 2007 08:53:41 -0400
From: Chris Mason <chris.mason@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Howells <dhowells@redhat.com>, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
Message-ID: <20070516125341.GS26766@think.oraclecorp.com>
References: <20070318233008.GA32597093@melbourne.sgi.com> <18993.1179310769@redhat.com> <1179317360.2859.225.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179317360.2859.225.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 08:09:19PM +0800, David Woodhouse wrote:
> On Wed, 2007-05-16 at 11:19 +0100, David Howells wrote:
> > The start and end points passed to block_prepare_write() delimit the region of
> > the page that is going to be modified.  This means that prepare_write()
> > doesn't need to fill it in if the page is not up to date. 
> 
> Really? Is it _really_ going to be modified? Even if the pointer
> userspace gave to write() is bogus, and is going to fault half-way
> through the copy_from_user()?

This is why there are so many variations on copy_from_user that zero on
faults.  One way or another, the prepare_write/commit_write pair are
responsible for filling it in.

-chris

