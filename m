Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbXEURGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbXEURGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbXEURGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:06:32 -0400
Received: from brick.kernel.dk ([80.160.20.94]:22616 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbXEURGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:06:31 -0400
Date: Mon, 21 May 2007 19:04:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, vtaras@openvz.org
Subject: Re: CFQ IO scheduler patch series - AIM7 DBase results on a 16-way    IA64
Message-ID: <20070521170407.GB29530@kernel.dk>
References: <4635D59C.4050300@hp.com> <20070430122753.GL21015@kernel.dk> <46372C8B.7090901@hp.com> <20070501121139.GA4653@kernel.dk> <46518D8A.10609@hp.com> <20070521121944.GU14746@kernel.dk> <4651B68E.6050308@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4651B68E.6050308@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21 2007, Alan D. Brunelle wrote:
> Jens Axboe wrote:
> >On Mon, May 21 2007, Alan D. Brunelle wrote:
> >  
> >>Jens Axboe wrote:
> >>    
> >>>On Tue, May 01 2007, Alan D. Brunelle wrote:
> >>> 
> >>>      
> >>>>Jens Axboe wrote:
> >>>>   
> >>>>        
> >>>>>On Mon, Apr 30 2007, Alan D. Brunelle wrote:
> >>>>>     
> >>>>>          
> >>>>>>The results from a single run of an AIM7 DBase load on a 16-way ia64 
> >>>>>>box (64GB RAM + 144 FC disks) showed a slight regression (~0.5%) by 
> >>>>>>adding in this patch. (Graph can be found at   
> >>>>>>http://free.linux.hp.com/~adb/cfq/cfq_dbase.png   ) It is only a 
> >>>>>>single set of runs, on a single platform, but it is something to keep 
> >>>>>>an eye on as the regression showed itself across the complete run.
> >>>>>>       
> >>>>>>            
> >>>>>Do you know if this regression is due to worse IO performance, or
> >>>>>increased system CPU usage?
> >>>>>     
> >>>>>          
> >>>>We performed two point runs yesterday (20,000 and 50,000 tasks) and 
> >>>>here are the results:
> >>>>
> >>>>Kernel  Tasks  Jobs per Minute  %sys (avg)
> >>>>------  -----  ---------------  ----------
> >>>>2.6.21  20000     60,831.1        39.83%
> >>>>CFQ br  20000     60,237.4        40.80%
> >>>>                  -0.98%        +2.44%
> >>>>
> >>>>2.6.21  50000     60,881.6        40.43%
> >>>>CFQ br  50000     60,400.6        40.80%
> >>>>                  -0.79%        +0.92%
> >>>>
> >>>>So we're seeing a slight IO performance regression with a slight 
> >>>>increase in %system with the CFQ branch. (A chart of the complete run 
> >>>>values is up on  http://free.linux.hp.com/~adb/cfq/cfq_20k50k.png  ).
> >>>>   
> >>>>        
> >>>Alan, can you repeat that same run with this patch applied? It
> >>>reinstates the cfq lookup hash, which could account for increased system
> >>>utilization.
> >>> 
> >>>      
> >>Hi Jens -
> >>
> >>This test was performed over the weekend, results are updated on
> >>
> >>http://free.linux.hp.com/~adb/cfq/cfq_dbase.png
> >>    
> >
> >Thanks a lot, Alan! So the cfq hash does indeed improve things a little,
> >that's a shame. I guess I'll just reinstate the hash lookup.
> >
> >  
> You're welcome Jens, but remember: It's one set of data; from one 
> benchmark; on one architecture; on one platform...don't know if you 
> should scrap the whole thing for that! :-) At the very least, I could 
> look into trying it out on another architecture. Let me see what I can 
> dig up...

Of course it would be great if you could test on something else as well,
but I was aware that the cfq hash lookup could potentially cause a
performance degradation with some workloads. Your test shows about a
0.3% drop, which isn't a lot but still looks consistent. The cfq hash
code wasn't that complicated, so if it helps a bit, then I'm inclined to
put it back in.

Let me know if you can run it on something else!

-- 
Jens Axboe

