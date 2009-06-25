Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZFYVIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZFYVIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZFYVH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:07:58 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:36201 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFYVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:07:57 -0400
Date: Thu, 25 Jun 2009 14:05:49 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Theodore Tso <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de, linux-ext4@vger.kernel.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090625210549.GM20311@mail.oracle.com>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	penberg@cs.helsinki.fi, arjan@infradead.org,
	linux-kernel@vger.kernel.org, cl@linux-foundation.org,
	npiggin@suse.de, linux-ext4@vger.kernel.org
References: <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
 <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain>
 <20090624150714.c7264768.akpm@linux-foundation.org>
 <20090625132544.GB9995@mit.edu>
 <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu>
 <20090625194423.GB6472@mit.edu>
 <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>
 <20090625203743.GD6472@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625203743.GD6472@mit.edu>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A43E6E0.00FB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 04:37:43PM -0400, Theodore Tso wrote:
> Nicely spotted.  Yeah, that's a bug; we need to do something about
> that one, too.  And what we're doing is a bit silly; it may make sense
> to use __get_free_pages if filesystem blocksize == PAGE_SIZE, but
> otherwise we should be using a sub-page allocator.  Right now, we're
> chewing up a 16k PPC page for every 4k filesystem metadata page
> allocated in journal_write_metadata_buffer(), and on x86, for the
> (admittedly uncommon) 1k block filesystem, we'd be chewing up a 4k
> page for a 1k block buffer.
> 
> 
> Both of these problems exist for both ext3 and ext4.

	And ocfs2.

Joel

-- 

Life's Little Instruction Book #337

	"Reread your favorite book."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
