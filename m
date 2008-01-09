Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYAIVZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYAIVZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYAIVY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:24:56 -0500
Received: from xspect.dk ([212.97.129.87]:38245 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYAIVYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:24:55 -0500
X-Greylist: delayed 1425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2008 16:24:55 EST
Date: Wed, 9 Jan 2008 22:01:09 +0100
From: "Klaus S. Madsen" <ksm@42.dk>
To: Rik van Riel <riel@redhat.com>
Cc: Anton Salikhmetov <salikhmetov@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Message-ID: <20080109210108.GB27738@hjernemadsen.org>
References: <1199728459.26463.11.camel@codedot> <20080109155015.4d2d4c1d@cuia.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109155015.4d2d4c1d@cuia.boston.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 15:50:15 -0500, Rik van Riel wrote:
> > Specifically, the ctime and mtime time stamps do change
> > when modifying the mapped memory and do not change when
> > there have been no write references between the mmap()
> > and msync() system calls.
> 
> As long as the ctime and mtime stamps change when the memory is
> written to, what exactly is the problem?

A "not" is missing from the sentence above. The quote above should have
read:

> > Specifically, the ctime and mtime time stamps do _not_ change when
> > modifying the mapped memory and do not change when there have been
> > no write references between the mmap() and msync() system calls.

So essentially the problem is that mtime stamps are _never_ changed when
the file is only modified through mmap. Not even when calling msync().

-- 
Kind regards,
	Klaus S. Madsen
