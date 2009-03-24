Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZCXO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZCXO4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZCXO4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:56:24 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:46282 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZCXO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:56:23 -0400
X-SourceIP: 213.93.53.227
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>
In-Reply-To: <20090324144709.GF23439@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	 <20090324125510.GA9434@duck.suse.cz> <20090324132637.GA14607@duck.suse.cz>
	 <200903250130.02485.nickpiggin@yahoo.com.au>
	 <20090324144709.GF23439@duck.suse.cz>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 15:56:03 +0100
Message-Id: <1237906563.24918.184.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 15:47 +0100, Jan Kara wrote:
> 
> Or we could implement ext3_mkwrite() to allocate buffers already when we
> make page writeable. But it costs some performace (we have to write page
> full of zeros when allocating those buffers, where previously we didn't
> have to do anything) and it's not trivial to make it work if pagesize >
> blocksize (we should not allocate buffers outside of i_size so if i_size
> = 1024, we create just one block in ext3_mkwrite() but then we need to
> allocate more when we extend the file).

I think this is the best option, failing with SIGBUS when we fail to
allocate blocks seems consistent with other filesystems as well.

