Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYEJWWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYEJWWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 18:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYEJWW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 18:22:27 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:40294 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbYEJWWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 18:22:24 -0400
Date: Sat, 10 May 2008 19:22:01 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Henny Wilbrink <wsdwhw@win.tue.nl>
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: Re: 2.6.26-rc1 fails to boot
Message-ID: <20080510222201.GA3754@beyonder.ift.unesp.br>
Mail-Followup-To: Henny Wilbrink <wsdwhw@win.tue.nl>,
	linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
References: <18470.968.939325.722176@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18470.968.939325.722176@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 10.May'08 at 22:21:28 +0200, Henny Wilbrink wrote:
Content-Description: message body text
> Hello,
> 
> Kernel 2.6.26-rc1 completely fails to boot on my laptop. The last line
> appearing on the console is:
> 
> ACPI: Processor [CPU1] (supports 8 throttling states)

Does booting with hpet=disable help?

> Kernel 2.6.25 fails to boot in an estimated 1 in 2 attempts.  The last
> line on the console if this one fails is:
> 
> ACPI: LNXTHERM:01 is registered as thermal_zone0
> 
> I did a git bisection with "fails to boot in the first three attempts"
> as the definition of "bad" between 2.6.26-rc1 and 2.6.25-rc3 which I
> believed to be free of this problem.  The many reboots in the
> bisection process however showed me that 2.6.25-rc3 also has an
> estimated 1 in 10 chance of failing.  Anyway, the bisection ended
> with:
> 
> 8a3227268877b81096d7b7a841aaf51099ad2068 is first bad commit
> 
> The bisection log and dmesg are attached.

I have this boot problem since before 2.6.25-rc1 but it is
very difficult to do a bisection. Sometimes the probability
of hanging was 1:30 and what I thought was a good kernel in
fact was bad.

In fact the commit you got is a "merge commit" which does not
change the source code so it is clearly bogus.

Mark Lord points out that this bug comes and goes with slight
modifications in the .config, and in fact very recently 
the probability of hanging changed dramatically for me.

I have already booted the kernel afa26be86b65 (six commits
after 2.6.26-rc1) more than 30 times and it did not hang.

You can also take a look at some discussion here:
http://bugzilla.kernel.org/show_bug.cgi?id=10117

And good luck with this!
