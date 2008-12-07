Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYLGUcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYLGUcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 15:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYLGUb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 15:31:56 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41282 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752342AbYLGUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 15:31:54 -0500
Date: Sun, 7 Dec 2008 13:39:16 -0500
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Harald Arnesen <skogtun.harald@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [ext4] Documentation patch
Message-ID: <20081207183916.GB15998@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Harald Arnesen <skogtun.harald@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <8763m3u9kv.fsf@basilikum.skogtun.org> <20081201165700.GA26680@infradead.org> <493425DC.1010008@redhat.com> <20081201205828.GA20069@mit.edu> <20081206222534.GJ1323@mit.edu> <493B0BAD.10004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493B0BAD.10004@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good points.  OK, how about this?
     	      
  - When comparing performance with other filesystems, it's always
    important to try multiple workloads; very often a subtle change in a
    workload parameter can completely change the ranking of which
    filesystems do well compared to others.  When comparing versus ext3,
    note that ext4 enables write barriers by default, while ext3 does
    not enable write barriers by default.  So it is useful to use
    explicitly specify whether barriers are enabled or not when via the
    '-o barriers=[0|1]' mount option for both ext3 and ext4 filesystems
    for a fair comparison.  When tuning ext3 for best benchmark numbers,
    it is often worthwhile to try changing the data journaling mode; '-o
    data=writeback,nobh' can be faster for some workloads.  (Note
    however that running mounting with data=writeback can potentially
    leave stale data exposed in recently written files in case of an
    unclean shutdown, which could be a security exposure in some
    situations.)  Configuring the filesystem with a large journal can
    also be helpful for metadata-intensive workloads.

							- Ted
