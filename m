Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZGBAEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZGBAEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZGBADw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:03:52 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:55473 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZGBADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=gJH7UEFyfRQ3i4F6r0WCkvPP+Mi/I/5TTNx3ONUGlf/0uiPelyM+Qe0QorUGONRlYz
         8hR1WCq7ECb1r0krrAqqHsKE78rQiNxRu3cTSU7XE11/7peWRb7n5JICdlHViVQk+JRM
         uHU0t4EStodIMFGcWVA8nvZ08tBA1P229QZE8=
Message-ID: <4A4BF968.3060505@gmail.com>
Date: Wed, 01 Jul 2009 21:03:52 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090626)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Possible problem with perf tool
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was playing with perf to get an idea of what it can do, so I started with a basic test:

$ perf stat ls
CREDITS        PERF-BUILD-OPTIONS  builtin-annotate.c  builtin-help.o  builtin-record.c  builtin-report.o  builtin-top.c  command-list.txt  libperf.a  perf.h
Documentation  PERF-CFLAGS	   builtin-annotate.o  builtin-list.c  builtin-record.o  builtin-stat.c    builtin-top.o  common-cmds.h     perf       perf.o
Makefile       PERF-VERSION-FILE   builtin-help.c      builtin-list.o  builtin-report.c  builtin-stat.o    builtin.h	  design.txt	    perf.c     util

 Performance counter stats for 'ls':

       1.675774  task-clock-msecs         #      0.772 CPUs 
             13  context-switches         #      0.008 M/sec
              0  CPU-migrations           #      0.000 M/sec
            212  page-faults              #      0.127 M/sec
        2925124  cycles                   #   1745.536 M/sec
        1048640  instructions             #      0.358 IPC  
         547552  cache-references         #    326.746 M/sec
           8455  cache-misses             #      5.045 M/sec

    0.002170123  seconds time elapsed




Looks good, so I tried:

$ perf stat ls -l
  Error: unknown switch `l'




So I tried instead:

$ perf stat 'ls -l'
ls -l: No such file or directory

 Performance counter stats for 'ls -l':

  <not counted>  task-clock-msecs        
  <not counted>  context-switches        
  <not counted>  CPU-migrations          
  <not counted>  page-faults             
  <not counted>  cycles                  
  <not counted>  instructions            
  <not counted>  cache-references        
  <not counted>  cache-misses            

    0.000594919  seconds time elapsed





Am I doing something wrong here?  Or perhaps perf should be taught the difference between command-line switches before or after the perf command (e.g. stat) being invoked?

-- 
Kevin Winchester


