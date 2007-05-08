Return-Path: <linux-kernel-owner+w=401wt.eu-S1032046AbXEHVqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032046AbXEHVqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031572AbXEHVp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:45:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51361 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031553AbXEHVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:45:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4640EF6B.6040701@s5r6.in-berlin.de>
Date: Tue, 08 May 2007 23:45:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: david@lang.hm
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com> <Pine.LNX.4.64.0705080943420.29403@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0705080943420.29403@asgard.lang.hm>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> I have used userspace tools for managing multiple machines that spawn
> tasks in parallel on multiple machines and then buffers them per-machine
> to display the output of the commands in order, no matter which one
> finished first.
> 
> for example 'dsh m1,m2 ls /' would always result in
> 
> m1 .
> m1 ..
> .
> .
> m2 .
> m2 ..
> .
> .
> 
> even if m2 finished before m1
> 
> why can't the detection be done in parallel, but the regestration of
> detected devices be done in order?

Userspace would have to tell the kernel which set of devices is
available.  (In your example:  The set consists of m1 and m2; but does
not include m0 nor m3 nor m6391.)

So instead of telling the kernel beforehand what to enqueue for
registration and in which order to enqueue it, we simply let userspace
give persistent alias names to devices after the fact.
-- 
Stefan Richter
-=====-=-=== -=-= -=---
http://arcgraph.de/sr/
