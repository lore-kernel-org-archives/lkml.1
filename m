Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXIJJpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXIJJpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbXIJJp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:45:28 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46722 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXIJJp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:45:26 -0400
Date: Mon, 10 Sep 2007 11:45:10 +0200 (CEST)
From: Simon Derr <Simon.Derr@bull.net>
X-X-Sender: derrs@frecb006381.adech.frec.bull.fr
To: Nicolas Capit <nicolas.capit@imag.fr>
Cc: linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>
Subject: Re: cpuset trouble after hibernate
In-Reply-To: <20070908204438.3bf03d85@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0709101141180.3467@frecb006381.adech.frec.bull.fr>
References: <20070908204438.3bf03d85@localhost.localdomain>
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 11:51:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 11:51:03,
	Serialize complete at 10/09/2007 11:51:03
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2007, Nicolas Capit wrote:

> Hello,
> 
> This is my situation:
>   - I mounted the pseudo cpuset filesystem into /dev/cpuset
>   - I created a cpuset named oar with my 2 cpus
> 
> cat /dev/cpuset/oar/cpus 
> 0-1
> 
>   - Then I hibernate my computer with 'echo -n "disk" >/sys/power/state'
>   - After reboot:
> 
> cat /dev/cpuset/oar/cpus 
> 0
> 
> Why did I lost a cpu?
> Is this a normal behavior???

Hi Nicolas,

I believe this is related to the fact that hibernation uses the hotplug 
subsystem to disable all CPUs except the boot CPU.

Thus guarantee_online_cpus() is called on each cpuset and removes all 
CPUs, except CPU 0, from all cpusets.

I'm not quite sure about if/how this should be fixed in the kernel, 
though. Looks like a very simple user-land workaround would be enough.

	Simon.

