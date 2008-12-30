Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYL3EXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYL3EXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 23:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYL3EXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 23:23:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:40740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYL3EXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 23:23:35 -0500
Date: Tue, 30 Dec 2008 05:23:33 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20081230042333.GC27679@wotan.suse.de>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223171259.GA11945@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 12:12:59PM -0500, Christoph Hellwig wrote:
> 
> Nick, I've seen various reports like this by Roman.  It seems to be
> caused by an interaction of the lockless pagecache with the xfs
> I/O code.  Any idea what might be wrong here:

Hmm, it could get into a loop here if there is a page in the pagecache
with a zero refcount, which might be a problem with XFS... other looping
conditions might indicate a problem iwth lockless pagecache or radix
tree. It would be very helpful to know what condition it is looping on...

