Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbXD0H4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbXD0H4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbXD0H4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:56:05 -0400
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:60812 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464AbXD0H4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:56:03 -0400
X-Greylist: delayed 1564 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 03:56:03 EDT
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Fri, 27 Apr 2007 08:31:23 +0100
Subject: Re: [PATCH 06/25] xen: Core Xen implementation
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>
CC: Ian Pratt <ian.pratt@xensource.com>, lkml <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <C257655B.66F1%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [PATCH 06/25] xen: Core Xen implementation
Thread-Index: AceIng5UTQPNafSREduWMAAWy6hiGQ==
In-Reply-To: <4631A157.9040702@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/4/07 08:08, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

>> Don't you need a rmb() here then? The CPU could speculate reads
>> (more occurrences)
>>   
> 
> Is rmb() sufficient?  It will stop a speculative read on the pending
> flag, but will it make sure the write has happened by then?  Ie, is it a
> write-vs-read barrier, or just a read-vs-read?
> Documentation/memory-barriers.txt suggests not.

The barrier() is sufficient. We are racing against Xen checking
evtchn_upcall_mask *on the local cpu*. Which means an interrupt has to
occur, which squashes speculative stuff.

Yeah, I know, it needs a better comment. :-)

 -- Keir


