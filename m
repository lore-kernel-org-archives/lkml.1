Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZJGVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZJGVz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZJGVz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:55:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZJGVz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:55:26 -0400
Message-ID: <4ACD0DEE.80404@redhat.com>
Date: Wed, 07 Oct 2009 23:53:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org> <4ACC6C9C.7080707@redhat.com> <4ACCEC18.90401@goop.org> <4ACCF565.30804@redhat.com> <4ACD05D8.5090903@goop.org> <4ACD0A2B.1080307@redhat.com> <4ACD0D78.2090006@goop.org>
In-Reply-To: <4ACD0D78.2090006@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 11:51 PM, Jeremy Fitzhardinge wrote:
> On 10/07/09 14:37, Avi Kivity wrote:
>    
>> If the guest does a RMW on the version, but the host does not (copying
>> it from somewhere else), then the guest RMW can be lost.
>>
>> Looking at the code, that's what kvm does:
>>
>>      vcpu->hv_clock.version += 2;
>>
>>      shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
>>
>>      memcpy(shared_kaddr + vcpu->time_offset,&vcpu->hv_clock,
>>             sizeof(vcpu->hv_clock));
>>
>> so a guest-side ++version can be lost.
>>      
> I see, yes.  The Xen code explicitly reads back the guest version and
> increments that (I realize now that's what you meant by guest-private
> version).  If you were to have a second version number it would have to
> be separated as well to avoid being overwritten by the hypervisor.
>    

Yes.  We have the space since a cacheline is 64 bytes (minimum) vs 32 
bytes of pvclock data.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

