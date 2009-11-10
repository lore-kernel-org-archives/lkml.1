Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZKJOgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZKJOgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZKJOgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:36:15 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38166 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbZKJOgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:36:14 -0500
Message-ID: <4AF97A5E.1070801@codemonkey.ws>
Date: Tue, 10 Nov 2009 08:36:14 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Adam Litke <agl@us.ibm.com>, linux-kernel@vger.kernel.org,
       Anthony Liguori <aliguori@us.ibm.com>,
       virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the
 balloon driver
References: <1257782838.2835.5.camel@aglitke>	<1257784326.2835.16.camel@aglitke> <200911101312.02650.rusty@rustcorp.com.au>
In-Reply-To: <200911101312.02650.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 10 Nov 2009 03:02:06 am Adam Litke wrote:
>   
>> A simpler approach is to collect memory statistics in the virtio
>> balloon driver and communicate them to the host via the device config space.
>>     
>
> There are two issues I see with this.  First, there's an atomicity problem
> since you can't tell when the stats are consistent.

Actually, config writes always require notification from the guest to 
the host.  This means the host knows when they config space is changed 
so atomicity isn't a problem.

In fact, if it were a problem, then the balloon driver would be 
fundamentally broken because target and actual are stored in the config 
space.

If you recall, we had this discussion originally wrt the balloon driver :-)

>   Second, polling is
> ugly.
>   

As opposed to?  The guest could set a timer and update the values 
periodically but that's even uglier because then the host cannot 
determine the update granularity.

> A stats vq might solve this more cleanly?
>   

actual and target are both really just stats.  Had we implemented those 
with a vq, I'd be inclined to agree with you but since they're 
implemented in the config space, it seems natural to extend the config 
space with other stats.

Regards,

Anthony Liguori
