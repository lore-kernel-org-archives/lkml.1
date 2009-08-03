Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZHCUUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZHCUUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZHCUUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:20:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41457 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZHCUUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:20:24 -0400
Message-ID: <4A774858.6080106@redhat.com>
Date: Mon, 03 Aug 2009 16:28:08 -0400
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sherif Fadel <fahmy@vt.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: scheduling co-processors
References: <1249312084.5762.17.camel@sherif-laptop>
In-Reply-To: <1249312084.5762.17.camel@sherif-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 11:08 AM, Sherif Fadel wrote:
> Hi,
> 
> I have a dual-core system on which I would like to treat one processor
> as a scheduling co-processor. I have already implemented some custom
> scheduling policies and tested them with SMP disabled, I would not like
> to see if it is possible to have the scheduling algorithm running on one
> core and the scheduled tasks running on another.
> 
> I do not know if I can somehow use cpus_allowed to restrict the kernel
> to one core and the running tasks to another. Is this possible? If so,
> could you please inform me how one would go about this?
> 
> In case you are wondering why I would need this, I am writing a bunch of
> high-overhead distributed scheduling algorithms and I want to mitigate
> their overhead in this way.
> 
> Thanks.
> 

The design I would have for this would be to have a kthread that does whatever busy work your scheduler has as a separate process. You could then replace the existing scheduler with a sort of "schedulerlet" that would simply schedule according to directions queued up for it by the kthread task. From there cpu affinity should get you the "dedicated scheduler processor" you want.

I can't even begin to envision the scheduling algorithm that would be able to operate this way, but I have to assume that if it makes sense for your scheduler to run on another CPU then it must be able to fit into this pattern.

--CJD
