Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZLBPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZLBPfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZLBPfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:35:37 -0500
Received: from verein.lst.de ([213.95.11.210]:60914 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZLBPfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:35:36 -0500
Date: Wed, 2 Dec 2009 16:35:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Thomas Renninger <trenn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical temperature
Message-ID: <20091202153536.GA20324@lst.de>
References: <20091125102857.GA28310@lst.de> <200912021256.21683.trenn@suse.de> <20091202133032.GA9265@lst.de> <200912021607.53237.trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912021607.53237.trenn@suse.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 04:07:52PM +0100, Thomas Renninger wrote:
> Some more hints you may want to try:
> 
>   - Does cpufreq work at all?
>     Does this dir exist: /sys/devices/system/cpu/cpu*/cpufreq

Yes.

>     If temp of:
>     watch -n1 cat /proc/acpi/thermal_zone/THM1/temperature
>     goes beyond 96 C
>     an ACPI processor event must get thrown and this:
>     /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
>     will get limited (lower than ../cpufreq/cpuinfo_max_freq).

The speeds change quite constantly under a kernel compile workload, but
most of the time it's at 2240800 vs cpuinfo_max_freq which is 2801000

>     echo xy >/sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
>     may be bad workaround.

echo 2240800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 2240800 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq

made it survive a kernel compile for me, with an observed maximum
temperature of 87 C.

More later..
