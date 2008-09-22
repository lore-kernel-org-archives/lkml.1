Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYIVRh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYIVRh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYIVRhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:37:18 -0400
Received: from quackingmoose.com ([63.73.180.143]:49024 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751652AbYIVRhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:37:16 -0400
Date: Mon, 22 Sep 2008 10:37:15 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: chucklever@gmail.com
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>,
       Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [NFS] blocks of zeros (NULLs) in NFS files in kernels >= 2.6.20
Message-ID: <20080922173715.GE12483@merfinllc.com>
References: <20080905191939.GG22796@merfinllc.com> <56258A29-95D5-4A8C-A097-014B8FEDFB8F@oracle.com> <20080911184951.GB19054@merfinllc.com> <200809221805.48463.hpj@urpla.net> <1222101322.7615.6.camel@localhost> <20080922170414.GC12483@merfinllc.com> <76bd70e30809221026g7bde774pbffa35881682ea4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76bd70e30809221026g7bde774pbffa35881682ea4b@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sep 22 01:26 PM, Chuck Lever wrote:
> Why can't you use O_SYNC | O_APPEND ?

In our case, some of the writers are not in our control.  Another case
we see the issue is you spawn a job:

   job 1> out 2> err &
   tail -f out err

--

Also, we actually do like caching the writes (b/c log files do not need
to be checked immediately after being written).   We just wish the cache
could be written out in-order.

If there's no way to make that happen... we can reorganize our
file-system, exports, mounts, etc so that the log file directory is
mounted with the sync option.   

However, the problem *might* be annoying and wide-spread enough to
warrant a change.

Anyway, thanks!

				Regards,
				=a=





-- 
===================
Aaron Straus
aaron@merfinllc.com
