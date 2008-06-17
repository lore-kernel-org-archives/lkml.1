Return-Path: <linux-kernel-owner+w=401wt.eu-S1759119AbYFQSKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbYFQSKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYFQSKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:10:02 -0400
Received: from hs-out-0708.google.com ([64.233.178.240]:20901 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbYFQSKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:10:00 -0400
Message-ID: <4857FDE3.8050602@codemonkey.ws>
Date: Tue, 17 Jun 2008 13:09:39 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
References: <20080616150550.GA16086@deprecation.cyrius.com> <48568503.90607@codemonkey.ws> <20080617123918.GA2397@deprecation.cyrius.com> <4857B92F.9020309@codemonkey.ws> <20080617133234.GE2397@deprecation.cyrius.com>
In-Reply-To: <20080617133234.GE2397@deprecation.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr wrote:
> * Anthony Liguori <anthony@codemonkey.ws> [2008-06-17 08:16]:
>   
>> VMware is a binary kernel module that's out of kernel.  KVM is not
>> misbehaving and the fact that VMware breaks when the KVM module is
>> loaded isn't our problem.  If they submitted their code for
>> inclusion in  mainline, we could possibly come up with solution for
>> arbitrating who is  using VT.
>>     
>
> I feared I'd get a response like this.  But unless this is a known
> issue in VMware (which I don't think it is), you don't know whether
> it's not a bug in kvm-intel.
>   

We know exactly what the problem is.  KVM activates VT unconditionally.  
There's no hardware mechanism to arbitrate access to VT.  KVM is the 
only thing in the Linux kernel that uses VT so we don't have a software 
mechanism to arbitrate access to VT.

If the VMware code was upstream, then we could work together to make a 
software arbitration mechanism.  It's not, and worse yet, it's closed 
source so there's no chance it will be.  Even if someone wrote an 
arbitration mechanism and got VMware to use it, it still shouldn't be 
merged because KVM would be the only thing using that mechanism 
upstream.  I'm not interested in adding kernel infrastructure to support 
external binary kernel modules.

Regards,

Anthony Liguori

