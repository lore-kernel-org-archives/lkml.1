Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYFLF6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYFLF6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYFLF6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:58:13 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:59946 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYFLF6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:58:12 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 01:58:12 EDT
Message-ID: <4850B9AA.7030004@debian.org>
Date: Thu, 12 Jun 2008 07:52:42 +0200
From: Giacomo Catenazzi <cate@debian.org>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Ben Castricum <lk0806@bencastricum.nl>,
       linux-kernel@vger.kernel.org, trivial@kernel.org,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: [patch] x86: microcode: Cosmetic changes
References: <alpine.LNX.1.10.0806101312170.14868@gateway.bencastricum.nl> <20080611170939.GA15146@redhat.com>
In-Reply-To: <20080611170939.GA15146@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Tue, Jun 10, 2008 at 01:15:12PM +0200, Ben Castricum wrote:
>  > @@ -805,6 +806,9 @@ static int __init microcode_init (void)
>  >  {
>  >  	int error;
>  >  
>  > +	printk(KERN_INFO
>  > +		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
>  > +
>  >  	error = microcode_dev_init();
>  >  	if (error)
>  >  		return error;
>  > @@ -825,9 +829,6 @@ static int __init microcode_init (void)
>  >  	}
>  >  
>  >  	register_hotcpu_notifier(&mc_cpu_notifier);
>  > -
>  > -	printk(KERN_INFO 
>  > -		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
>  >  	return 0;
> 
> By doing this before the registration of the sysdev, we'll
> now be printing this on machines that don't have the microcode
> update facility.   Pointless spew, for no obvious gain imo.
> 
> [Why we go through so many hoops before we check if the CPU is
>  capable is a mystery to me. It would make more sense to have
>  that be the first thing that gets checked when this inits]

I would remove the printk:
- it is the only email on my dmesg, along two other copyright
  notices (Ingo and Intel). So it seems that the dmesg clean-up
  is going on.
- the code of driver is stable, and now it is updated only in
  kernel trees, so IMO it is better to use kernel version on
  bug report. BTW I don't think people will update the version
  number of driver.
- IMO it is enough to printk the microcode loads, not the
  driver load.

ciao
	cate
