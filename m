Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYAIMOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYAIMOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYAIMOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:14:32 -0500
Received: from unthought.net ([212.97.129.88]:52262 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYAIMO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:14:28 -0500
X-Greylist: delayed 1601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2008 07:14:28 EST
Date: Wed, 9 Jan 2008 12:47:46 +0100
From: Jakob Oestergaard <jakob@unthought.net>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, joe@evalesco.com
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Message-ID: <20080109114746.GF25527@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	Anton Salikhmetov <salikhmetov@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, joe@evalesco.com
References: <1199728459.26463.11.camel@codedot> <4df4ef0c0801090332y345ccb67se98409edc65fd6bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4df4ef0c0801090332y345ccb67se98409edc65fd6bf@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:32:53PM +0300, Anton Salikhmetov wrote:
> Since no reaction in LKML was recieved for this message it seemed
> logical to suggest closing the bug #2645 as "WONTFIX":
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=2645#c15

Thank you!

A quick run-down for those who don't know what this is about:

Some applications use mmap() to modify files. Common examples are databases.

Linux does not update the mtime of files that are modified using mmap, even if
msync() is called.

This is very clearly against OpenGroup specifications.

This misfeatures causes such files to be silently *excluded* from normal backup
runs.

Solaris implements this properly.

NT has the same bug as Linux, using their private bastardisation of the mmap
interface - but since they don't care about SuS and are broken in so many other
ways, that really doesn't matter.


So, dear kernel developers, can we please integrate this patch to make Linux
stop silently excluding peoples databases from their backup?

-- 

 / jakob

