Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbYCZSYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbYCZSYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758370AbYCZSY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:24:28 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23124 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbYCZSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:24:27 -0400
Message-ID: <47EA94C9.4060308@hp.com>
Date: Wed, 26 Mar 2008 14:24:09 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, npiggin@suse.de, dgc@sgi.com
Subject: IO CPU Affinity: more results...
References: <47EA437F.2070703@hp.com> <47EA4C6F.1010208@hp.com> <20080326132806.GD15355@kernel.dk>
In-Reply-To: <20080326132806.GD15355@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current blk.git origin/io-cpu-affinity sources:

After 60 successful passes on a 4-way ia64:

 60 0 mkfs untar make 
 60 1 mkfs untar make 

   Part RQ     Min     Avg     Max     Dev
  ----- -- ------- ------- ------- -------
   mkfs  0  81.233  81.810  82.599   0.330 
   mkfs  1  81.083  81.854  82.973   0.405
 
  untar  0  17.075  17.676  18.098   0.273 
  untar  1  16.975  17.570  18.128   0.288
 
   make  0  24.231  24.380  24.541   0.085 
   make  1  24.116  24.312  24.459   0.073 
  ----- -- ------- ------- ------- -------
   comb  0 122.898 123.866 125.002   0.516 
   comb  1 122.620 123.736 125.156   0.521 
  ===== == ======= ======= ======= =======
   psys  0   2.12%   2.19%   2.28%   0.035 
   psys  1   1.92%   2.00%   2.25%   0.049 


so:

1. It's working pretty solidly on ia64
2. We still see reduced combined times w/ rq=1 (albeit, not much - and certainly nothing definitive with the relatively high standard deviations).
3. We see large reduction in %system to do the same work - 8% less

And here's something else I've noticed: It seems that as the runs go on, the makes happen quicker (in general). I've got some graphs on free.linux.hp.com - they are a bit busy, but here are some pointers:

1. Black stuff is for rq=0, red stuff is for rq=1
2. Solid horizontal line indicates the set average.
3. Lower numbers for /all/ graphs are better
4. Open circles represent individual test run points
5. Hashed-line w/ shaded large circles represents localized averages: each circle is the average of the surrounding 5 data points.

The last thing is key: you'll see on 

http://free.linux.hp.com/~adb/jens/make.png

The black hashed line (rq=0) tends to bop around the average, whilst the red hashed line (rq=1) seems to show a downwards trend. (I need to run this a lot longer to see if it holds up.) Note: this trending-downwards does /not/ appear in the mkfs & untar parts of the operations. /Every/ time I've had extended runs with rq=1 I see this trend. 

Note: %sys doesn't really fluctuate much at all - as can be seen by: 

http://free.linux.hp.com/~adb/jens/psys.png

The other graphs include:

http://free.linux.hp.com/~adb/jens/mkfs.png
http://free.linux.hp.com/~adb/jens/untar.png
http://free.linux.hp.com/~adb/jens/comb.png

Alan D. Brunelle
HP / OSLO / S&P

