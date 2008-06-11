Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbYFKRW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbYFKRW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762109AbYFKRWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:22:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbYFKRWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:22:20 -0400
Date: Wed, 11 Jun 2008 13:09:39 -0400
From: Dave Jones <davej@redhat.com>
To: Ben Castricum <lk0806@bencastricum.nl>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [patch] x86: microcode: Cosmetic changes
Message-ID: <20080611170939.GA15146@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Castricum <lk0806@bencastricum.nl>,
	linux-kernel@vger.kernel.org, trivial@kernel.org
References: <alpine.LNX.1.10.0806101312170.14868@gateway.bencastricum.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0806101312170.14868@gateway.bencastricum.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 01:15:12PM +0200, Ben Castricum wrote:
 > @@ -805,6 +806,9 @@ static int __init microcode_init (void)
 >  {
 >  	int error;
 >  
 > +	printk(KERN_INFO
 > +		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
 > +
 >  	error = microcode_dev_init();
 >  	if (error)
 >  		return error;
 > @@ -825,9 +829,6 @@ static int __init microcode_init (void)
 >  	}
 >  
 >  	register_hotcpu_notifier(&mc_cpu_notifier);
 > -
 > -	printk(KERN_INFO 
 > -		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
 >  	return 0;

By doing this before the registration of the sysdev, we'll
now be printing this on machines that don't have the microcode
update facility.   Pointless spew, for no obvious gain imo.

[Why we go through so many hoops before we check if the CPU is
 capable is a mystery to me. It would make more sense to have
 that be the first thing that gets checked when this inits]

	Dave

-- 
http://www.codemonkey.org.uk
