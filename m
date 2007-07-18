Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbXGREa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbXGREa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 00:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbXGREaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 00:30:16 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:60233 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbXGREaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 00:30:14 -0400
Message-ID: <469D9728.2080701@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2007 09:59:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: =?windows-1252?Q?=22Paul_=28=3F=3F=29_Menage=22?= 
	<menage@google.com>
CC: dhaval@linux.vnet.ibm.com,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@sw.ru>, Paul Jackson <pj@sgi.com>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Containers: css_put() dilemma
References: <469BBE00.8000709@linux.vnet.ibm.com> <469C2792.6050009@linux.vnet.ibm.com> <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com> <20070717070031.GA22410@linux.vnet.ibm.com> <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com> <469C99D1.7090807@linux.vnet.ibm.com> <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com> <469CFF2B.1080702@linux.vnet.ibm.com> <6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com> <469D066B.6050606@linux.vnet.ibm.com> <6599ad830707171126o7c431277p84f532d0122a8a98@mail.gmail.com>
In-Reply-To: <6599ad830707171126o7c431277p84f532d0122a8a98@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul (??) Menage wrote:
> On 7/17/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> without too much knowledge of each other. BTW, what are the semantics
>> of css_put() is it expected to free the container/run the release agent
>> when the reference count of the container_subsys_state drops to zero?
>>
> 
> If you css_put() the last reference on a subsystem state object and
> the associated container is marked as notify_on_release, then
> check_for_release() is called which does a more full check of whether
> the container is releasable. If it is, a workqueue task is scheduled
> to run the userspace release agent, which can then do anything it
> wants, including potentially deleting the empty container.
> 

Ok.. so my problem still remains, how do I get a non-blocking atomic
reference increment/decrement routine, that would prevent my
container from being deleted?

I don't find cpusets using css_put(). I was hoping that we could
alter css_* would provide the functionality I need.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
