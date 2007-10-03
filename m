Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXJCRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXJCRcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXJCRcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:32:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbXJCRcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:32:11 -0400
Message-ID: <4703D212.6040304@redhat.com>
Date: Wed, 03 Oct 2007 13:32:02 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Anders_Bo?= =?ISO-8859-1?Q?str=F6m?= 
	<anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: PROBLEM: high load average when idle
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>	<20071002150748.906970bc.akpm@linux-foundation.org>	<4702C756.8090108@redhat.com> <20071002162613.54c3ef43@laptopd505.fenrus.org>
In-Reply-To: <20071002162613.54c3ef43@laptopd505.fenrus.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2007 07:26 PM, Arjan van de Ven wrote:
> On Tue, 02 Oct 2007 18:33:58 -0400
>> Or, everybody wakes up at once right when we are taking a sample.  :)
> 
> nice try but we sample every timer tick; this code being timer driven
> makes it what you say it is regardless of *which* timer tick it
> happens at ;)
> 

But we reduce the number of samples because some ticks just never
happen when the timers get rounded:

No rounding:

      tick ............... tick
     1 running            1 running

Rounded:

      tick
     2 running

In the first case the average is 1, but it's 2 in the second.

