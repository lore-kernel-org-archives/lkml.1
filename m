Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbZJMLkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbZJMLkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759512AbZJMLkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:40:08 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37905 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759513AbZJMLkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:40:05 -0400
Message-ID: <4AD466E5.4010206@openvz.org>
Date: Tue, 13 Oct 2009 15:39:17 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: vatsa@in.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com>
In-Reply-To: <20090930143953.GA2014@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMO Pavel's requirement can be met with a hard limit of 25%
> 
> 	2 CPU of 1GHz = (1/2 x 4) (1/2 x 2) GHz CPUs
> 		      = 1/4 x 4 2GHz CPU
> 		      = 25% of (4 2GHz CPU)
> 
> IOW by hard-limiting a container thread to run just 0.5sec every sec on a 2GHz 
> cpu, it is effectively making progress at the rate of 1GHz?

So, any suggestions on this? I'm not against the patches themselves.
I'm just trying to tell, that setting a cpulimit with 2 numbers is
not a good way to go (at least a clean explanation of how to calculate
them should go with the patches).

I propose to first collect what *can* be done. I see the following
possibilities:

1) two times (as it is now) - I believe this is inconvenient.
2) the amount in percents (like 50%) - this is how it works in
   OpenVZ and customers are quite happy with it. It's better than
   two numbers, since you need to specify only one clean number.
3) virtual cpu power in M/GHz - I don't agree with Balbir that
   this is difficult for administrator. This is better than two
   numbers and better that the percentage, since the amount of
   cpu time got by a container will not change after migrating to
   a more powerful CPU.

Thoughts?

> - vatsa
> 

