Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZFDKZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZFDKZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZFDKZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:25:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39205 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZFDKZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:25:18 -0400
Message-ID: <4A27A10C.2050405@redhat.com>
Date: Thu, 04 Jun 2009 13:25:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com> <20090602162021.GB6827@redhat.com> <4A255484.6060401@novell.com> <20090602165949.GD6827@redhat.com> <4A256431.2080101@novell.com> <20090603063956.GA8134@redhat.com>
In-Reply-To: <20090603063956.GA8134@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> On Tue, Jun 02, 2009 at 01:41:05PM -0400, Gregory Haskins wrote:
>   
>>> And having close not clean up the state unless you do an ioctl first is
>>> very messy IMO - I don't think you'll find any such examples in kernel.
>>>
>>>   
>>>       
>> I agree, and that is why I am advocating this POLLHUP solution.  It was
>> only this other way to begin with because the technology didn't exist
>> until Davide showed me the light.
>>
>> Problem with your request is that I already looked into what is
>> essentially a bi-directional reference problem (for a different reason)
>> when I started the POLLHUP series.  Its messy to do this in a way that
>> doesn't negatively impact the fast path (introducing locking, etc) or
>> make my head explode making sure it doesn't race.  Afaict, we would need
>> to solve this problem to do what you are proposing (patches welcome).
>>
>> If this hybrid decoupled-deassign + unified-close is indeed an important
>> feature set, I suggest that we still consider this POLLHUP series for
>> inclusion, and then someone can re-introduce DEASSIGN support in the
>> future as a CAP bit extension.  That way we at least get the desirable
>> close() properties that we both seem in favor of, and get this advanced
>> use case when we need it (and can figure out the locking design).
>>
>>     
>
> FWIW, I took a look and yes, it is non-trivial.
> I concur, we can always add the deassign ioctl later.
>   

I agree that deassign is needed for reasons of symmetry, and that it can 
be added later.

-- 
error compiling committee.c: too many arguments to function

