Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0CCQmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:42:54 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:58025 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab0CCQmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:42:53 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>, Hashir Abdi <habdi@microsoft.com>
Subject: Ringbuffer usage in Linux Hyper-V drivers
Thread-Topic: Ringbuffer usage in Linux Hyper-V drivers
Thread-Index: AQHKuvCGLAH71qxVt0GYupGkI8PEwA==
Date: Wed, 3 Mar 2010 16:42:27 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56212EE39C0@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF725A908A11@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20100217235223.GG12197@kroah.com>
In-Reply-To: <20100217235223.GG12197@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



All,

I have been looking at one of the TODO items in the Linux Hyper-V drivers. 

Specifically the one that says;

	- remove RingBuffer.c to use in-kernel ringbuffer functions instead.

I spend some time figuring out the ring buffer capability inside of the Linux 
Kernel to see if we could change the Hyper-V ring buffer out for the in-kernel 
ring buffer capability.

The ring buffer in the Hyper-V Linux drivers is used to communicate with the 
parent partition running Server 2008 Hyper-V. The ring buffer functionality on 
the Hyper-V Linux drivers is written to be functionally compatible with" the 
ring buffer functionality on the Hyper-V Server. Consequently, it is not 
possible to make any changes that might break the compatibility with server 
side ring buffer implementation.  

There is a pretty good chance that ring buffer on Hyper-V will change to support 
additional functionality. I did further investigations to check on other 
virtualization technologies. And this same things seems to be true for XEN, 
they also implemented their own ring buffer implementation on the guest side 
because of their host side implementation.

So my question is to the community at large, am I missing something that would 
enable me to use an existing ring buffer functionality somehow in the kernel?  
If not, I want to remove the line from the TODO file that is requesting to use the 
in-kernel ring buffer functionality.

Finally, while checking this out, I looked at a bunch of non virtualization device 
drivers currently in the kernel. And all the ones I looked at have 
implemented their own ring buffer. Is there a reason why this might be the case?
 
As usual, any help is appreciated.

Thanks,

Hank Janssen.
