Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZCXORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZCXORQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbZCXOHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:07:33 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:65517 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224AbZCXODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:03:30 -0400
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090324132637.GA14607@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	 <200903200248.22623.nickpiggin@yahoo.com.au>
	 <20090319164638.GB3899@duck.suse.cz>
	 <200903241844.22851.nickpiggin@yahoo.com.au>
	 <20090324123935.GD23439@duck.suse.cz> <20090324125510.GA9434@duck.suse.cz>
	 <20090324132637.GA14607@duck.suse.cz>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 10:01:45 -0400
Message-Id: <1237903305.17910.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49C8E7D0.01A0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 14:26 +0100, Jan Kara wrote:
> On Tue 24-03-09 13:55:10, Jan Kara wrote:

> >   And one more interesting thing I don't yet fully understand - I see pages
> > having PageError() set when they are removed from page cache (and they have
> > been faulted in before). It's probably some interaction with pagecache
> > readahead...
>   Argh... So the problem seems to be that get_block() occasionally returns
> ENOSPC and we then discard the dirty data (hmm, we could give at least a
> warning for that). I'm not yet sure why getblock behaves like this because
> the filesystem seems to have enough space but anyway this seems to be some
> strange fs trouble as well.
> 

Ouch.  Perhaps the free space is waiting on a journal commit?

-chris


