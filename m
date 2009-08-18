Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZHRHjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZHRHjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZHRHjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:39:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38874 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZHRHjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:39:03 -0400
Message-ID: <4A8A5A7F.5050809@redhat.com>
Date: Tue, 18 Aug 2009 10:38:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for vbus_driver
 objects
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws>
In-Reply-To: <4A89FF08.30509@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 04:08 AM, Anthony Liguori wrote:
> I believe strongly that we should avoid putting things in the kernel 
> unless they absolutely have to be.  I'm definitely interested in 
> playing with vhost to see if there are ways to put even less in the 
> kernel.  In particular, I think it would be a big win to avoid 
> knowledge of slots in the kernel by doing ring translation in 
> userspace.  This implies a userspace transition in the fast path.  
> This may or may not be acceptable.  I think this is going to be a very 
> interesting experiment and will ultimately determine whether my 
> intuition about the cost of dropping to userspace is right or wrong.

I believe with a perfectly scaling qemu this should be feasible.  
Currently qemu is far from scaling perfectly, but inefficient userspace 
is not a reason to put things into the kernel.

Having a translated ring is also a nice solution for migration - 
userspace can mark the pages dirty while translating the receive ring.

Still, in-kernel translation is simple enough that I think we should 
keep it.

-- 
error compiling committee.c: too many arguments to function

