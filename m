Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYF0Kxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYF0Kxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYF0Kxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:53:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:41976 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYF0Kxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XiUXiP+7ucENybxUMk39ze0j0RCxpVOpM1895MuNH/UY6yJDJepStFTttXXC8tT06C
         w/Arga/y+lb/Nztx1aZES3uFCas7GwKQHvREnuJDKrx0htltBs5KmOCsm0P6Jsg99PD8
         Xs3UzzAlfFanbSS8mHGWFDr2IcYTXs3GLliDw=
Message-ID: <4864C6A8.6050605@gmail.com>
Date: Fri, 27 Jun 2008 12:53:28 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: balbir@linux.vnet.ibm.com, menage@google.com, chlunde@ping.uio.no,
       axboe@kernel.dk, matt@bluehost.com, roberto@unbit.it,
       randy.dunlap@oracle.com, dpshah@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i/o bandwidth controller infrastructure
References: <1213956335-29866-3-git-send-email-righi.andrea@gmail.com>	<20080625172900.6cfe79cf.akpm@linux-foundation.org>	<486419FE.6070600@gmail.com> <20080626155948.34f30751.akpm@linux-foundation.org>
In-Reply-To: <20080626155948.34f30751.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 27 Jun 2008 00:36:46 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
>>> Does all this code treat /dev/sda1 as a separate device from /dev/sda2?
>>>  If so, that would be broken.
>> Yes, all the partitions are treated as separate devices with
>> (potentially) different limiting rules, but I don't understand why it
>> would be broken... dev_t has both minor and major numbers, so it would
>> be possible to select single partitions as well.
> 
> Well it's functionally broken, isn't it?  A physical disk has a fixed
> IO bandwidth and when the administrator wants to partition that
> bandwidth amongst control groups he will need to consider the entire
> device when doing so?
> 
> I mean, the whole point of this feature and of control groups as a
> whole is isolation.  But /dev/sda1 and /dev/sda2 are very much _not_
> isolated.  Whereas /dev/sda and /dev/sdb are (to a large degree)
> isolated.

well... yes, sounds reasonable. In this case we could just ignore the
minor number and consider only major number as the key to identify a
specific block device (both for userspace<->kernel interface and when
accounting/throttling i/o requests).

-Andrea
