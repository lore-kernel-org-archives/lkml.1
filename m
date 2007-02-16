Return-Path: <linux-kernel-owner+w=401wt.eu-S1946302AbXBPXpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946302AbXBPXpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946307AbXBPXpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:45:50 -0500
Received: from main.gmane.org ([80.91.229.2]:46748 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946302AbXBPXpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:45:49 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Date: Fri, 16 Feb 2007 18:47:48 -0500
Message-ID: <45D642A4.5010009@tmr.com>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@sea.gmane.org
Cc: Juan Piernas Canovas <piernas@ditec.um.es>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20070216091321.GA28092@lazybastard.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Thu, 15 February 2007 23:59:14 +0100, Juan Piernas Canovas wrote:
>> Actually, the version of DualFS for Linux 2.4.19 implements a cleaner. In 
>> our case, the cleaner is not really a problem because there is not too 
>> much to clean (the meta-data device only contains meta-data blocks which 
>> are 5-6% of the file system blocks; you do not have to move data blocks).
> 
> That sounds as if you have not hit the "interesting" cases yet.  Fun
> starts when your device is near-full and you have a write-intensive
> workload.  In your case, that would be metadata-write-intensive.  For
> one, this is where write performance of log-structured filesystems
> usually goes down the drain.  And worse, it is where the cleaner can
> run into a deadlock.
> 
> Being good where log-structured filesystems usually are horrible is a
> challenge.  And I'm sure many people are more interested in those
> performance number than in the ones you shine at. :)
> 
Actually I am interested in the common case, where the machine is not 
out of space, or memory, or CPU, but when it is appropriately sized to 
the workload. Not that I lack interest in corner cases, but the "running 
flat out" case doesn't reflect case where there's enough hardware, now 
the o/s needs to use it well.

The one high load benchmark I would love to see is a web server, running 
tux, with a load over a large (number of files) distributed data set. 
The much faster tar create times posted make me think that a server with 
a lot of files would benefit, when CPU and memory requirements are not a 
bottleneck.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

