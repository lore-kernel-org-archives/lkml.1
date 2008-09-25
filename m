Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYIYCCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYIYCCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYIYCB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:01:58 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:49414 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbYIYCB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:01:58 -0400
From: Frans Pop <elendil@planet.nl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Date: Thu, 25 Sep 2008 04:01:51 +0200
User-Agent: KMail/1.9.9
Cc: airlied@gmail.com, jeff@garzik.org, davem@davemloft.net,
       akpm@linux-foundation.org, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com, mingo@elte.hu,
       jbarnes@virtuousgeek.org, jesse.brandeburg@gmail.com
References: <20080923.150722.141587696.davem@davemloft.net> <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com> <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz> <20080923.211215.193696086.davem@davemloft.net> <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz> <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com> <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com> <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
In-reply-To: <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250401.54818.elendil@planet.nl>
X-OriginalArrivalTime: 25 Sep 2008 02:01:55.0708 (UTC) FILETIME=[AFAC33C0:01C91EB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Uh oh. Shouldn't we put something like the patch below in Linus' tree
> unless we get this sorted out? Otherwise more and more people who
> use -rc kernels will run into this, and will get their hardware
> [hopefully temporarily, but not all users are able to re-flash their
> network card EEPROMs, right] bricked.

Something else to worry about is bisections. People seeing an unrelated 
issue with .27 after release may well be asked to do a bisection and 
could then run into the issue even if it is fixed before the release.

Guess we'll need to wait and see what the root cause is to know if that's 
a real concern or not.

> - it is not yet even clear whether the bug is caused by userspace (new
>   version of xorg drivers, bad interaction with PAT, ...) or some bug in
>   kernel code; it's even not yet certain at which exact combination of
>   software versions and hardware configuration this started to trigger

Extra datapoint. As far as I've seen this problem has not yet been 
reported by any people running Debian. This could point to X.Org as 
Debian currently has 7.3 while I think the reports so far have been with 
7.4.

I have been running .27-rc kernels myself on a HP 2510p laptop running 
Debian/lenny which does have the "bad" NIC (ICH9), but it's still working 
for me. I do have some vague resume from suspend problems, but for now 
I'm assuming those are unrelated.
I have been running the kernels both with and without PAT enabled.

Cheers,
FJP
