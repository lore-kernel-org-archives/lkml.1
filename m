Return-Path: <linux-kernel-owner+w=401wt.eu-S933087AbXKPSf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087AbXKPSf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759480AbXKPSfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:35:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:18431 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759732AbXKPSf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f4TZ+KWLApPJKtS7yAI9l8hTLZrauuElRKqURCEZm9h/CBcaKvuRlBuoLJM64mEENWKhQhySV7rApAPJzgsXmN43ZfytVKpw2JQfIGOQHAhnGClIjLQN/dzeS3p+onuVbCRZRbjnv/f0+TndZAJ2Caeb6yw95TxnXkvPJ3ZiohA=
Message-ID: <2c0942db0711161035x5978a37bjd0f3fb67470553eb@mail.gmail.com>
Date: Fri, 16 Nov 2007 10:35:25 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan D. Brunelle" <alan.brunelle@hp.com>
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>, arjan@infradead.org,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <473DC496.6010805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>
	 <20071015114738.6b5a25c7.akpm@linux-foundation.org>
	 <20071015161315.4fe18e07@bree.surriel.com>
	 <20071015141236.62b075c6.akpm@linux-foundation.org>
	 <473B18BA.5000709@hp.com>
	 <20071114091451.d4b110db.akpm@linux-foundation.org>
	 <473DC496.6010805@hp.com>
X-Google-Sender-Auth: dadd8aa222ea8dee
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 8:25 AM, Alan D. Brunelle <alan.brunelle@hp.com> wrote:
> Here are the results for the latest tests, some notes:
>
> o  The machine actually has 8GiB of RAM, so the tests still may end up
> using (some) page cache. (But at least it was the same for both kernels!
> :-) )
>
> o  Sorry the results took so long - the updated tree size caused the
> runs to take > 12 hours...
>
> o  The longer runs seemed to bring down the standard deviation a bit,
> although they are still quite large.
>
> o  10 runs per test (read large file, read a tree, overwrite large
> file), with averages presented.
>
> o  1st 4 columns (min, avg, max, std dev) refer to the average run
> lengths for the tests - real time, in seconds
>
> o  The last 3 columns are extracted from iostat results over the course
> of the whole run.
>
> o  The read a tree test certainly stands out - the other 2 large file
> manipulations have the two kernels within a couple of percent, but the
> read a tree test has Arjan's patch taking about 47%(!) longer on
> average. The increased %iowait & %system time in all 3 cases is interesting.
>
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
> Let me know if there is anything else I can do to elaborate, or if you
> have suggestions for further testing.

Out of curiosity, what are the mount options for the freshly created
ext3 fs? In particular, are you using noatime, nodiratime?

Ray
