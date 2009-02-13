Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZBMKpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZBMKpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZBMKpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:45:06 -0500
Received: from main.gmane.org ([80.91.229.2]:49771 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZBMKpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:45:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Renninger <trenn@suse.de>
Subject: Re: Acer Aspire One fan control
Date: Fri, 13 Feb 2009 10:35:11 +0000 (UTC)
Message-ID: <loom.20090213T092444-966@post.gmane.org>
References: <cone.1234471033.988571.5384.1000@mentalhome>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 195.135.221.2 (Mozilla/5.0 (compatible; Konqueror/4.1; Linux) KHTML/4.1.3 (like Gecko) SUSE)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Feuerer <peter <at> piie.net> writes:

> 
> Hi list,
> 
> I own such an Acer Aspire One netbook and the noisy fan annoyed me. (The 
> default hardware controlled fan is on all the time). So I wrote a small 
> kernel module which monitors the temperature of the cpu and turns the fan on 
> and off. After testing it a while on my and some of my friends netbooks, it 
> seems to be stable and I thought about submitting this functionality to 
> the mainline kernel. As this is my first time, I've got some questions and 
> would really appreciate any help.
> 
> Do you think it makes sense to add it as seperate kernelmodule or should I 
> patch another module, e.g. the drivers/misc/acer-wmi.c module?
> Should I try also to add the functionality of the 
> /proc/acpi/thermal_zone/THRM/* things in my first patch? Or just submit the 
> general functionality for controlling the fan and add additional things step 
> by step?

Does it help if you do:
echo 10 >/proc/acpi/thermal_zone/*/polling_frequency

If the fan is controlled via thermal ACPI trip points, maybe latest kernel
versions do help? There were several commits lately in this area, e.g.:
676962dac6e267ce7c13f73962208f9124a084bb
f5adfaa372c76423b6e8e4727a9701330374f364
The latter adds a boot param you could give a try if you think it's worth it:
ACPI: Add "acpi.power_nocheck=1" to disable power state check in power
transition

