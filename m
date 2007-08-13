Return-Path: <linux-kernel-owner+w=401wt.eu-S942862AbXHMQCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942862AbXHMQCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967838AbXHMOXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:23:09 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:23602 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031802AbXHMOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:23:04 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
Date: Mon, 13 Aug 2007 16:22:27 +0200
User-Agent: KMail/1.9.7
Cc: Avi Kivity <avi@qumranet.com>, Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, cotte@de.ibm.com
References: <46BC8B39.6050202@bull.net> <200708131605.40479.borntraeger@de.ibm.com> <46C06638.6010108@qumranet.com>
In-Reply-To: <46C06638.6010108@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131622.27533.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. August 2007 schrieb Avi Kivity:

> Laurent's patch gives the best of both worlds: on old 'top', you get 
> guest time accounted as user time, while on new 'top' it is accounted 
> separately.  This is done by reporting user time as the sum of the real 
> user time and guest time.  A newer 'top' can subtract guest time from 
> user time to get the correct statistic.

Yes that looks promising. If I recall correctly we had some strange top 
behaviours when we introduced the steal time. Old top added the steal time to 
idle. We should check that.

> 
> 
> > My implementation uses a similar mechanism like hard and softirq. So I 
have an 
> > sie_enter an sie_exit and a task_is_in_sie function - like irq_enter and 
> > irq_exit. The main difference is based on the fact, that s390 has precise 
> > accouting for irq, steal, user and system time, and therefore my patch is 
> > based on architecture specifc code using CONFIG_VIRT_CPU_ACCOUNT. 
> >   
> 
> Okay, so the code should be under that config option, and kvm should 
> select it.

No hurry..that was specific to our implementation, not KVM :-)
Besided that, Ingo changed the accouting with his CFS scheduler, and I still 
have to figure out how CONFIG_VIRT_CPU_ACCOUNTING can be properly integrated 
in CFS.

Christian
