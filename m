Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZIRRPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZIRRPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZIRRPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:15:35 -0400
Received: from mail.lang.hm ([64.81.33.126]:49996 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZIRRPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:15:35 -0400
Date: Fri, 18 Sep 2009 10:15:31 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Tobias Oetiker <tobi@oetiker.ch>
cc: linux-kernel@vger.kernel.org
Subject: Re: announce: fsopbench - filesystem operations benchmark
In-Reply-To: <alpine.DEB.2.00.0909180901550.6162@sebohet.brgvxre.pu>
Message-ID: <alpine.DEB.2.00.0909181015090.24556@asgard.lang.hm>
References: <alpine.DEB.2.00.0909180901550.6162@sebohet.brgvxre.pu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Tobias Oetiker wrote:

> Hi,
>
> As explained in a mail earlier this week I am in the process of
> optimizing interactive performance for a file-server under high
> write load.
>
> To help in this venture, I have written a benchmark for measuring
> the response time of filesystem operations.
>
>  http://oss.oetiker.ch/optools/wiki/fsopbench
>
> The benchmark program is able to generate a artificial filesystem
> tree with a file size distribution similar to a home directory tree.
>
> To simulate the write load it can fork of several writer processes
> in the background.
>
> It shows similar results on all configurations I have tested.
> In the example below you see:
>
> * lstat: 10 times slower
> * reading the first byte of a file: 80 times slower
> * reading a directory entry: 16 times slower
> * read rate: 40 times lower

lower and slower than what?

David Lang

> On top of that the standard deviation of the measurments goes way
> up with extreme maximal wait times in the 1 second range.
>
> Some numbers form 2.6.31 with cfq on an Areca HW Raid6 (the results
> from single disks are similar but less pronounced)
>
> Reading Only - Mode  30s Interval
> -----------------------------------------------------------------
> A read dir        cnt  29512    min    0.001 ms    max   14.273 ms    mean    0.081 ms    stdev   0.694
> B lstat file      cnt  27797    min    0.006 ms    max   12.471 ms    mean    0.071 ms    stdev   0.571
> C open file       cnt  22644    min    0.013 ms    max    0.390 ms    mean    0.019 ms    stdev   0.012
> D rd 1st byte     cnt  22644    min    0.114 ms    max   23.614 ms    mean    0.591 ms    stdev   1.464
> E read rate      71.492 MB/s
>
> In-Competition with 6 Writers - Mode  30s Interval
> -----------------------------------------------------------------
> A read dir        cnt    625    min    0.001 ms    max  167.049 ms    mean    1.355 ms    stdev  11.462
> B lstat file      cnt    589    min    0.006 ms    max  182.580 ms    mean    0.503 ms    stdev   7.747
> C open file       cnt    479    min    0.014 ms    max    0.134 ms    mean    0.021 ms    stdev   0.011
> D rd 1st byte     cnt    479    min    0.180 ms    max 1114.885 ms    mean   40.708 ms    stdev 143.536
> E read rate       1.566 MB/s
>
> I have been testing some patches provided by Corrado Zoccolo but no
> solution has been found yet.
>
> cheers
> tobi
>
>
