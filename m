Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbXELEJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbXELEJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 00:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXELEJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 00:09:29 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:36553 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752897AbXELEJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 00:09:28 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.1
Date: Sat, 12 May 2007 05:09:31 +0100
From: Jose Celestino <japc@co.sapo.pt>
To: Matt Mackall <mpm@selenic.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Re: Re: [announce] Intel announces the PowerTOP utility for
	Linux
Message-ID: <20070512040930.GC6464@co.sapo.pt>
Mail-Followup-To: Matt Mackall <mpm@selenic.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org
References: <4644F726.1050806@linux.intel.com> <20070512001718.GY11166@waste.org> <20070512014052.GA4082@co.sapo.pt> <20070512023904.GY11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512023904.GY11115@waste.org>
X-URL: http://xpto.org/~japc
X-System: Linux morgoth.sl.pt 2.6.21-1.3116.fc7
X-UP: 02:55:31 up  1:20,  1 user,  load average: 0.21, 0.23, 0.27
X-By: japc@morgoth.sl.pt
X-GPG-key-ID: 0x07B1363B
X-GPG-key-Fingerprint: D3F3 B47B F20C 3B1E 488C B949 1B8B 8141 07B1 363B
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Words by Matt Mackall [Fri, May 11, 2007 at 09:39:05PM -0500]:
> On Sat, May 12, 2007 at 02:40:52AM +0100, Jose Celestino wrote:
> > Words by Matt Mackall [Fri, May 11, 2007 at 07:17:19PM -0500]:
> > > On Fri, May 11, 2007 at 04:07:18PM -0700, Arjan van de Ven wrote:
> > > > 
> > > > What's eating the battery life of my laptop? Why isn't it many more 
> > > > hours? Which software component causes the most power to be burned? 
> > > > These are important questions without a good answer... until now.
> > > 
> > > I get:
> > > 
> > > No detailed statistics available; please enable the CONFIG_TIMER_STATS
> > > kernel option
> > > 
> > 
> > Must run as root (rw to /proc/timer_stats is needed).
> 
> That file doesn't exist, despite CONFIG_TIMER_STATS being in
> /proc/config.gz.
> 

Then again, perhaps you have /proc/tstats instead.

If so apply this (well, you get the idea):

--- powertop/powertop.c 2007-05-12 05:01:15.000000000 +0100
+++ powertop_new/powertop.c     2007-05-12 05:08:46.000000000 +0100
@@ -212,8 +212,8 @@
 void stop_timerstats(void)
 {
        FILE *file;
-       file = fopen("/proc/timer_stats","w");
-       if (!file) {
+       if (!(file = fopen("/proc/timer_stats","w")) &&
+               !(file = fopen("/proc/stats","w")) ) {
                nostats = 1;
                return;
        }
@@ -223,8 +223,8 @@
 void start_timerstats(void)
 {
        FILE *file;
-       file = fopen("/proc/timer_stats","w");
-       if (!file) {
+       if (!(file = fopen("/proc/timer_stats","w")) &&
+               !(file = fopen("/proc/stats","w")) ) {
                nostats = 1;
                return;
        }
@@ -388,7 +388,7 @@
                i = 0;
                totalticks = 0;
                if (!nostats)
-                       file = popen("cat /proc/timer_stats | sort -n | tail -190", "r");
+                       file = popen("cat /proc/timer_stats 2>>/dev/null|| cat /proc/tstats | sort -n | tail -190", "r");
                while (file && !feof(file) && i<190) {
                        char *count, *pid, *process, *func;
                        int cnt;


-- 
Jose Celestino
----------------------------------------------------------------
http://www.msversus.org/     ; http://techp.org/petition/show/1
http://www.vinc17.org/noswpat.en.html
----------------------------------------------------------------
"And on the trillionth day, Man created Gods." -- Thomas D. Pate
