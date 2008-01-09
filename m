Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYAIMWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYAIMWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYAIMWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:22:30 -0500
Received: from unthought.net ([212.97.129.88]:53630 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYAIMW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:22:29 -0500
Date: Wed, 9 Jan 2008 13:22:28 +0100
From: Jakob Oestergaard <jakob@unthought.net>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, joe@evalesco.com
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Message-ID: <20080109122228.GG25527@unthought.net>
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
...
> 
> This bug causes backup systems to *miss* changed files.
> 

This problem is seen with both Amanda and TSM (Tivoli Storage Manager).

A site running Amanda with, say, a full backup weekly and incremental backups
daily, will only get weekly backups of their mmap modified databases.

However, large sites running TSM will be hit even harder by this because TSM
will always perform incremental backups from the client (managing which
versions to keep for how long on the server side). TSM will *never* again take
a backup of the mmap modified database.

The really nasty part is; nothing is failing. Everything *appears* to work.
Your data is just not backed up because it appears to be untouched.

So, if you run TSM (or pretty much any other backup solution actually) on
Linux, maybe you should run a
 find / -type f -print0 | xargs -0 touch
before starting your backup job. Sort of removes the point of using proper
backup software, but at least you'll get your data backed up.


-- 

 / jakob

