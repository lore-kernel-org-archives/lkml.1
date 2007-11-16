Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbXKPQk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbXKPQk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXKPQkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:40:52 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42832 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbXKPQkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:40:52 -0500
Message-ID: <473DC804.1000201@hp.com>
Date: Fri, 16 Nov 2007 11:40:36 -0500
From: "Alan D. Brunelle" <alan.brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, arjan@infradead.org, jens.axboe@oracle.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>	<20071015114738.6b5a25c7.akpm@linux-foundation.org>	<20071015161315.4fe18e07@bree.surriel.com>	<20071015141236.62b075c6.akpm@linux-foundation.org>	<473B18BA.5000709@hp.com> <20071114091451.d4b110db.akpm@linux-foundation.org> <473DC496.6010805@hp.com>
In-Reply-To: <473DC496.6010805@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
> 
> Read large file:
> 
> Kernel  Min    Avg    Max   Std Dev    %user  %system  %iowait
> --------------------------------------------------------------
> base :  201.6  215.1  275.5   22.8     0.26%    4.69%   33.54%
> arjan:  198.0  210.3  261.5   18.5     0.33%   10.24%   54.00%
> 
> Read a tree:
> 
> Kernel  Min    Avg    Max   Std Dev    %user  %system  %iowait
> --------------------------------------------------------------
> base : 3518.2 4631.3 5991.3  784.6     0.19%    3.29%   23.56%
> arjan: 5731.6 6849.8 7777.4  731.6     0.32%    9.90%   52.70%
> 
> Overwrite large file:
> 
> Kernel  Min    Avg    Max   Std Dev    %user  %system  %iowait
> --------------------------------------------------------------
> base :  104.2  147.7  239.5   38.4      0.02%    0.05%   1.08%
> arjan:  106.2  149.7  239.2   38.4      0.25%    0.79%  14.97%
> 
>

I'm going to try and do some clean up work on the iostat CPU results - 
the reason %user & %system are so low is (I think) because they also 
include a lot of 0% results from the tail of the runs (as the unmount is 
going on I think). I'm going to try and extract results for just the 
"meat" of the runs.

Alan
