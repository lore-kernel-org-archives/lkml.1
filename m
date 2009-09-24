Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZIXIDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZIXIDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZIXIDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:03:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZIXIDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:03:49 -0400
Message-ID: <4ABB27B9.4050904@redhat.com>
Date: Thu, 24 Sep 2009 11:03:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <4AAFACB5.9050808@redhat.com> <4AAFF437.7060100@gmail.com> <4AB0A070.1050400@redhat.com> <4AB0CFA5.6040104@gmail.com> <4AB0E2A2.3080409@redhat.com> <4AB0F1EF.5050102@gmail.com> <4AB10B67.2050108@redhat.com> <4AB13B09.5040308@gmail.com> <4AB151D7.10402@redhat.com> <4AB1A8FD.2010805@gmail.com> <20090921214312.GJ7182@ovro.caltech.edu> <4AB89C48.4020903@redhat.com> <4ABA3005.60905@gmail.com> <4ABA32AF.50602@redhat.com> <4ABA3A73.5090508@gmail.com> <4ABA61D1.80703@gmail.com> <4ABA78DC.7070604@redhat.com>
In-Reply-To: <4ABA78DC.7070604@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 10:37 PM, Avi Kivity wrote:
>
> Example: feature negotiation.  If it happens in userspace, it's easy 
> to limit what features we expose to the guest.  If it happens in the 
> kernel, we need to add an interface to let the kernel know which 
> features it should expose to the guest.  We also need to add an 
> interface to let userspace know which features were negotiated, if we 
> want to implement live migration.  Something fairly trivial bloats 
> rapidly.

btw, we have this issue with kvm reporting cpuid bits to the guest.  
Instead of letting kvm talk directly to the hardware and the guest, kvm 
gets the cpuid bits from the hardware, strips away features it doesn't 
support, exposes that to userspace, and expects userspace to program the 
cpuid bits it wants to expose to the guest (which may be different than 
what kvm exposed to userspace, and different from guest to guest).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

