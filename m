Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZJ0NyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZJ0NyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZJ0NyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:54:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:56643 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbZJ0NyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:54:09 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH] Avoid livelock for fsync
Date: Tue, 27 Oct 2009 19:26:14 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.3-1-desktop; KDE/4.3.1; x86_64; ; )
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>, npiggin@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       hch@infradead.org, chris.mason@oracle.com
References: <20091026181314.GE7233@duck.suse.cz>
In-Reply-To: <20091026181314.GE7233@duck.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910271926.15176.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009 23:43:14 Jan Kara wrote:
>   Hi,
> 
>   on my way back from Kernel Summit, I've coded the attached patch which
> implements livelock avoidance for write_cache_pages. We tag patches that
> should be written in the beginning of write_cache_pages and then write
> only tagged pages (see the patch for details). The patch is based on Nick's
> idea.

As I understand, livelock can be caused only by dirtying new pages.

So theoretically, if a process can dirty pages faster than we can tag pages 
for writeback, even now isn't there a chance for livelock? But if it is really 
a very fast operation and livelock is not possible, why not hold the tree_lock 
during the entire period of tagging the pages for writeback i.e., call 
tag_pages_for_writeback() under mapping->tree_lock? Would it cause 
deadlock/starvation or some other serious problems?

Thanks
Nikanth
