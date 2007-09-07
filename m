Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXIGVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXIGVAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758475AbXIGVAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 17:00:13 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:35675 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbXIGVAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 17:00:11 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Bernd Schubert <bs@q-leap.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 1/2)
References: <200709051546.06224.bs@q-leap.de>
	<20070905083529.a1c8a0a9.randy.dunlap@oracle.com>
	<200709051941.56145.bs@q-leap.de>
	<200709081415.54211.nickpiggin@yahoo.com.au>
Date: Fri, 07 Sep 2007 23:00:00 +0200
In-Reply-To: <200709081415.54211.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Sat, 8 Sep 2007 14:15:53 +1000")
Message-ID: <87hcm6chtb.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Anyway, there are fixes for this deadlock in Andrew's -mm tree, but
> also a workaround for the NFSD problem in git commit 29dbb3fc. Did
> you try a later kernel to see if it is fixed there?

I had a chance to look up that commit (git clone took a while so sorry
for writing 2 mails). It is present in 2.6.23-rc5 so I already noticed
it when merging our patch in 2.6.23-rc5.

Upon closer reading of the patch though I see that it will indeed
prevent writes by the nfsd to be split smaller than PAGE_SIZE and it
will cause filemap_copy_from_user[_iovec] to be called with a source
spanning multiple pages.

So the commit 29dbb3fc should have a simmilar, slightly better even,
gain for the nfsd and other kernel space segments. But it will not
improve writes from user space, where ~14% of the commits were saved
during a days work for me.


Now I have a question about fault_in_pages_readable(). Can I call that
for multiple pages and then call __grab_cache_page() without risking
one of the pages from getting lost again and causing a deadlock?

MfG
        Goswin
