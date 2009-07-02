Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbZGBALd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbZGBALd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZGBALY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:11:24 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51619 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZGBALX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sgpbgH4PzFabim9vh1U6Ki9k1I5skSrOrnFg5VBjE72NFUX6uS7nXlREIAyozYfNd6
         fxMlqXJL8SeRMOU8pESv13jkVJe6Unc8f2q1rpj50dj3facaw0UULMyyFNVQaBqbDuzP
         JdSpmWMa8n64RF7eUa+7IHG0IepKdf40iWBsU=
Date: Thu, 2 Jul 2009 02:11:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Possible problem with perf tool
Message-ID: <20090702001122.GB5025@nowhere>
References: <4A4BF968.3060505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4BF968.3060505@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 09:03:52PM -0300, Kevin Winchester wrote:
> 
> I was playing with perf to get an idea of what it can do, so I started with a basic test:
> 
> $ perf stat ls
> CREDITS        PERF-BUILD-OPTIONS  builtin-annotate.c  builtin-help.o  builtin-record.c  builtin-report.o  builtin-top.c  command-list.txt  libperf.a  perf.h
> Documentation  PERF-CFLAGS	   builtin-annotate.o  builtin-list.c  builtin-record.o  builtin-stat.c    builtin-top.o  common-cmds.h     perf       perf.o
> Makefile       PERF-VERSION-FILE   builtin-help.c      builtin-list.o  builtin-report.c  builtin-stat.o    builtin.h	  design.txt	    perf.c     util
> 
>  Performance counter stats for 'ls':
> 
>        1.675774  task-clock-msecs         #      0.772 CPUs 
>              13  context-switches         #      0.008 M/sec
>               0  CPU-migrations           #      0.000 M/sec
>             212  page-faults              #      0.127 M/sec
>         2925124  cycles                   #   1745.536 M/sec
>         1048640  instructions             #      0.358 IPC  
>          547552  cache-references         #    326.746 M/sec
>            8455  cache-misses             #      5.045 M/sec
> 
>     0.002170123  seconds time elapsed
> 
> 
> 
> 
> Looks good, so I tried:
> 
> $ perf stat ls -l
>   Error: unknown switch `l'
> 
> 
> 
> 
> So I tried instead:
> 
> $ perf stat 'ls -l'
> ls -l: No such file or directory
> 
>  Performance counter stats for 'ls -l':
> 
>   <not counted>  task-clock-msecs        
>   <not counted>  context-switches        
>   <not counted>  CPU-migrations          
>   <not counted>  page-faults             
>   <not counted>  cycles                  
>   <not counted>  instructions            
>   <not counted>  cache-references        
>   <not counted>  cache-misses            
> 
>     0.000594919  seconds time elapsed
> 
> 
> 
> 
> 
> Am I doing something wrong here?  Or perhaps perf should be taught the difference between command-line switches before or after the perf command (e.g. stat) being invoked?
> 


Hi,

When you have a command line to play that has parameters, then
separate the perf parameters from the command line using "--":

./perf stat -- ls -l

I guess it's inspired from the when you have to pass paths
and branches at the same time:

git-diff branch1 branch2 -- kernel/perf_counter.c

