Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbXCTJ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbXCTJ7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933536AbXCTJ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:59:36 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:25005 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502AbXCTJ7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:59:19 -0400
Date: Tue, 20 Mar 2007 13:06:34 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, akpm@osdl.org
Subject: Re: Oops after cd /sys/.../cpufreq/; rmmod; cat stats/time_in_state
Message-ID: <20070320100634.GA6811@localhost.sw.ru>
References: <20070319153013.GA6814@localhost.sw.ru> <20070319204125.GA5598@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319204125.GA5598@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 01:41:25PM -0700, Greg KH wrote:
> On Mon, Mar 19, 2007 at 06:30:13PM +0300, Alexey Dobriyan wrote:
> > Steps to reproduce:
> >
> > 	# modprobe p4-clockmod
> > 	$ cd /sys/devices/system/cpu/cpu0/cpufreq/
> > 	# rmmod p4-clockmod
> > 	$ cat stats/time_in_state
> > 	Segmentation fault
>
> Has this always happened?  Or is it new?

I've checked 2.6.17 and up and it happens too.

Some .config peculiarities:

	CONFIG_CPU_FREQ=y
	CONFIG_CPU_FREQ_STAT=y
	CONFIG_X86_P4_CLOCKMOD=m

After modprobe/rmmod cpufreq/stats directory appears but doesn't get
removed. Should it?

/sys/devices/system/cpu/cpu0/cpufreq $ ls -lR
.:
total 0
drwxr-xr-x 2 root root 0 2007-03-20 12:59 stats

./stats:
total 0
-r--r--r-- 1 root root 4096 2007-03-20 12:59 time_in_state
-r--r--r-- 1 root root 4096 2007-03-20 12:59 total_trans

