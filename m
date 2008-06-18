Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYFRVAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYFRVAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYFRU75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:59:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:27592 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYFRU74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:59:56 -0400
Message-ID: <48597735.50905@codemonkey.ws>
Date: Wed, 18 Jun 2008 15:59:33 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Martin Michlmayr <tbm@cyrius.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
References: <20080616150550.GA16086@deprecation.cyrius.com> <48568503.90607@codemonkey.ws> <20080617123918.GA2397@deprecation.cyrius.com> <4857B92F.9020309@codemonkey.ws> <20080617133234.GE2397@deprecation.cyrius.com> <4857FDE3.8050602@codemonkey.ws> <48591412.2060602@qumranet.com>
In-Reply-To: <48591412.2060602@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>>
>> We know exactly what the problem is.  KVM activates VT 
>> unconditionally.  There's no hardware mechanism to arbitrate access 
>> to VT.  KVM is the only thing in the Linux kernel that uses VT so we 
>> don't have a software mechanism to arbitrate access to VT.
>>
>> If the VMware code was upstream, then we could work together to make 
>> a software arbitration mechanism.  It's not, and worse yet, it's 
>> closed source so there's no chance it will be.  Even if someone wrote 
>> an arbitration mechanism and got VMware to use it, it still shouldn't 
>> be merged because KVM would be the only thing using that mechanism 
>> upstream.  I'm not interested in adding kernel infrastructure to 
>> support external binary kernel modules.
>
> Well a recent patch from Eli Collins mentioned VMware are 
> standardizing CR4.VMXE as an indicator of whether someone is using the 
> VT hardware or not, and now kvm clears that bit when unloading.  We 
> could check the bit and fail if is set, thus have working mutual 
> exclusion.  Of course, it will only work with newer versions of kvm 
> and vmware.

Yup, but the original bug reporter would not be helped by this.

> I don't see any reason to poke sticks into the wheels here.

An occasional poke at binary kernel modules is always a good thing IMHO :-)

Regards,

Anthony Liguori

