Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZIRHZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZIRHZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZIRHZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:25:00 -0400
Received: from james.oetiker.ch ([213.144.138.195]:35117 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZIRHZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:25:00 -0400
Date: Fri, 18 Sep 2009 09:24:59 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: linux-kernel@vger.kernel.org
Subject: announce: fsopbench - filesystem operations benchmark
Message-ID: <alpine.DEB.2.00.0909180901550.6162@sebohet.brgvxre.pu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As explained in a mail earlier this week I am in the process of
optimizing interactive performance for a file-server under high
write load.

To help in this venture, I have written a benchmark for measuring
the response time of filesystem operations.

  http://oss.oetiker.ch/optools/wiki/fsopbench

The benchmark program is able to generate a artificial filesystem
tree with a file size distribution similar to a home directory tree.

To simulate the write load it can fork of several writer processes
in the background.

It shows similar results on all configurations I have tested.
In the example below you see:

 * lstat: 10 times slower
 * reading the first byte of a file: 80 times slower
 * reading a directory entry: 16 times slower
 * read rate: 40 times lower

On top of that the standard deviation of the measurments goes way
up with extreme maximal wait times in the 1 second range.

Some numbers form 2.6.31 with cfq on an Areca HW Raid6 (the results
from single disks are similar but less pronounced)

Reading Only - Mode  30s Interval
-----------------------------------------------------------------
A read dir        cnt  29512    min    0.001 ms    max   14.273 ms    mean    0.081 ms    stdev   0.694
B lstat file      cnt  27797    min    0.006 ms    max   12.471 ms    mean    0.071 ms    stdev   0.571
C open file       cnt  22644    min    0.013 ms    max    0.390 ms    mean    0.019 ms    stdev   0.012
D rd 1st byte     cnt  22644    min    0.114 ms    max   23.614 ms    mean    0.591 ms    stdev   1.464
E read rate      71.492 MB/s

In-Competition with 6 Writers - Mode  30s Interval
-----------------------------------------------------------------
A read dir        cnt    625    min    0.001 ms    max  167.049 ms    mean    1.355 ms    stdev  11.462
B lstat file      cnt    589    min    0.006 ms    max  182.580 ms    mean    0.503 ms    stdev   7.747
C open file       cnt    479    min    0.014 ms    max    0.134 ms    mean    0.021 ms    stdev   0.011
D rd 1st byte     cnt    479    min    0.180 ms    max 1114.885 ms    mean   40.708 ms    stdev 143.536
E read rate       1.566 MB/s

I have been testing some patches provided by Corrado Zoccolo but no
solution has been found yet.

cheers
tobi

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
