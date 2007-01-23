Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXAWDhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXAWDhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbXAWDg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:36:59 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:63490 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbXAWDg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:36:58 -0500
Message-ID: <45B582CF.1050408@in.ibm.com>
Date: Tue, 23 Jan 2007 09:06:47 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Christoph Lameter <clameter@sgi.com>, Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com> <45B569A4.3010006@redhat.com>
In-Reply-To: <45B569A4.3010006@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Christoph Lameter wrote:
> 
>> With the proposed schemd you would have to move pages between lists if
>> they are mapped and unmapped by a process. Terminating a process could
>> lead to lots of pages moving to the unnmapped list.
> 
> That could be a problem.
> 
> Another problem is that any such heuristic in the VM is
> bound to have corner cases that some workloads will hit.
> 
> It would be really nice if we came up with a page replacement
> algorithm that did not need many extra heuristics to make it
> work...
> 

Yes, it's damn hard at times. I was reading through an article
(Architectural support for translation table management in large address
space machines - Huck and Hayes), it talks about how Object Oriented
Systems encourage more sharing and decrease the locality of resulting
virtual address memory stream. Even multi threading tends to impact
locality of references.

Unfortunately, we have only heuristics to go by and of-course their
mathematical model.

I have always wondered if it would be useful to have a kernel debug
feature that can extract page references per task, it would be good
to see the page references (last 'n') of a workload that is not
doing too well on a particular system.



-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
