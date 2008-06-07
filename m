Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYFGXWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYFGXWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 19:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYFGXWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 19:22:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:44625 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753690AbYFGXWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 19:22:24 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/Wu1YSsEvWN+0utrglU3oHq6lpr6QBt2GLGkZmRW
	wXGnlGfEtISCa/
Date: Sun, 8 Jun 2008 01:22:19 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>, cpufreq@lists.linux.org.uk,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
Message-ID: <20080607232219.GA25693@atjola.homenet>
References: <48486920.4040006@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48486920.4040006@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.06.05 15:30:56 -0700, Kok, Auke wrote:
> 
> I've consistently experienced the following bizarre problem since
> 2.6.20, all the way up to 2.6.25.3 (regressed yesterday and each of
> these kernels exposes this behaviour):
> 
> /sys/devices/system/cpu/cpu0/cpufreq # grep . *
> affected_cpus:0
> cpuinfo_cur_freq:800000
> cpuinfo_max_freq:1866000
> cpuinfo_min_freq:800000
> scaling_available_frequencies:1866000 1600000 1333000 1066000 800000
> scaling_available_governors:ondemand performance
> scaling_cur_freq:800000
> scaling_driver:acpi-cpufreq
> scaling_governor:ondemand
> scaling_max_freq:800000
> scaling_min_freq:800000
> 

I also saw that on my T43, didn't have time to investigate any further
and forgot about it shortly after :-(

> 
> Notice that scaling_mx_freq dropped down to the lowest possible value
> and as such my CPU is only working at 800MHz. At boot time this field
> properly displays 1866MHz and everything works OK. After a certain
> period (?) this value drops down and I cannot manually elevate it back
> to the normal level:
> 
> # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> 800000
> # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> 800000

Try with "echo -n", seems that sysfs (or at least that file) doesn't
like newlines.

Björn
