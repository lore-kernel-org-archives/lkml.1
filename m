Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZKJVxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZKJVxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbZKJVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:53:11 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41506 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268AbZKJVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:53:10 -0500
Message-ID: <4AF9E0AA.8040100@us.ibm.com>
Date: Tue, 10 Nov 2009 15:52:42 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: agl@linux.vnet.ibm.com, qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
References: <1257782838.2835.5.camel@aglitke> <1257784326.2835.16.camel@aglitke> <200911101312.02650.rusty@rustcorp.com.au>
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
> since you can't tell when the stats are consistent.  Second, polling is
> ugly.
>
> A stats vq might solve this more cleanly?
>   

This turns out to not work so nicely.  You really need bidirectional 
communication.  You need to request that stats be collected and then you 
need to tell the hypervisor about the stats that were collected.  You 
don't need any real correlation between requests and stat reports either.

This really models how target/actual work and I think it suggests that 
we want to reuse that mechanism for the stats too.

> Rusty.
>   


-- 
Regards,

Anthony Liguori

