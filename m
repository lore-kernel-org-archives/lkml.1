Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbXKRUr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbXKRUr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 15:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXKRUrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 15:47:48 -0500
Received: from waste.org ([66.93.16.53]:50915 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbXKRUrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 15:47:47 -0500
Date: Sun, 18 Nov 2007 14:47:24 -0600
From: Matt Mackall <mpm@selenic.com>
To: Abhishek Rai <abhishekrai@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Mike Waychison <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Message-ID: <20071118204724.GS19691@waste.org>
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com> <20071115230219.1fe9338c.akpm@linux-foundation.org> <20071116073716.GB17536@waste.org> <d9885f0f0711180752o71561745h51f2a18d09709e27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9885f0f0711180752o71561745h51f2a18d09709e27@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2007 at 07:52:36AM -0800, Abhishek Rai wrote:
> Thanks for the suggestion Matt.
> 
> It took me some time to get compilebench working due to the known
> issue with drop_caches due to circular lock dependency between
> j_list_lock and inode_lock (compilebench triggers drop_caches quite
> frequently). Here are the results for compilebench run with options
> "-i 30 -r 30". I repeated the test 5 times on each of vanilla and mc
> configurations.
> 
> Setup: 4 cpu, 8GB RAM, 400GB disk.
> 
> Average vanilla results
> ==========================================================================
> intial create total runs 30 avg 46.49 MB/s (user 1.12s sys 2.25s)
> create total runs 5 avg 12.90 MB/s (user 1.08s sys 1.97s)
> patch total runs 4 avg 8.70 MB/s (user 0.60s sys 2.31s)
> compile total runs 7 avg 21.44 MB/s (user 0.32s sys 2.95s)
> clean total runs 4 avg 59.91 MB/s (user 0.05s sys 0.26s)
> read tree total runs 2 avg 21.85 MB/s (user 1.12s sys 2.89s)
> read compiled tree total runs 1 avg 23.47 MB/s (user 1.45s sys 4.89s)
> delete tree total runs 2 avg 13.18 seconds (user 0.64s sys 1.02s)
> no runs for delete compiled tree
> stat tree total runs 4 avg 4.76 seconds (user 0.70s sys 0.50s)
> stat compiled tree total runs 1 avg 7.84 seconds (user 0.74s sys 0.54s)
> 
> Average metaclustering results
> ==========================================================================
> intial create total runs 30 avg 45.04 MB/s (user 1.13s sys 2.42s)
> create total runs 5 avg 15.64 MB/s (user 1.08s sys 1.98s)
> patch total runs 4 avg 10.50 MB/s (user 0.61s sys 3.11s)
> compile total runs 7 avg 28.07 MB/s (user 0.33s sys 4.06s)
> clean total runs 4 avg 83.27 MB/s (user 0.04s sys 0.27s)
> read tree total runs 2 avg 21.17 MB/s (user 1.15s sys 2.91s)
> read compiled tree total runs 1 avg 22.79 MB/s (user 1.38s sys 4.89s)
> delete tree total runs 2 avg 9.23 seconds (user 0.62s sys 1.01s)
> no runs for delete compiled tree
> stat tree total runs 4 avg 4.72 seconds (user 0.71s sys 0.50s)
> stat compiled tree total runs 1 avg 6.50 seconds (user 0.79s sys 0.53s)
> 
> Overall, metaclustering does better than vanilla except in a few cases.

Well it strikes me as about half up and half down, but the ups are
indeed much more substantial. Looks quite promising.

-- 
Mathematics is the supreme nostalgia of our time.
