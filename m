Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZICV1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZICV1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbZICV1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:27:45 -0400
Received: from mail-yw0-f192.google.com ([209.85.211.192]:56236 "EHLO
	mail-yw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbZICV1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:27:44 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 17:27:43 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lKFmElDzlbLXrasqEiHY1ey0/xIrhLgX5EJjCukLiRc7iafyg9P70MLzRBTmIRgoWn
         gkPxCsO4g5QooN6FA+cMNcCGUX4x+JM1MDxeK56jW5fuPtqG4mM7JvwR895uqysvZcfE
         47WlQQG5p0W7sfee/qYFG8QHHFRyJNm69hBi8=
Message-ID: <4AA03370.4080905@gmail.com>
Date: Thu, 03 Sep 2009 17:21:52 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: James Bottomley <James.Bottomley@suse.de>,
       Alok Kataria <akataria@vmware.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>,
       Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Maxime Austruy <maustruy@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <1251911789.23106.25.camel@ank32.eng.vmware.com> <1252008182.3941.61.camel@mulgrave.site> <200909031331.03037.dtor@vmware.com>
In-Reply-To: <200909031331.03037.dtor@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2009 04:31 PM, Dmitry Torokhov wrote:
> On Thursday 03 September 2009 01:03:02 pm James Bottomley wrote:
>    
>>>> I'm not really asking you to standardise anything (yet).  I was more
>>>> probing for why you hadn't included any of the SCSI control plane
>>>> interfaces and what lead you do produce a different design from the
>>>> current patterns in virtual I/O.  I think what I'm hearing is "Because
>>>> we didn't look at how modern SCSI drivers are constructed" and "Because
>>>> we didn't look at how virtual I/O is currently done in Linux".  That's
>>>> OK (it's depressingly familiar in drivers),
>>>>          
>>> I am sorry that's not the case, the reason we have different design as I
>>> have mentioned above is because we want a generic mechanism which works
>>> for all/most of the GOS's out their and doesn't need to be specific to
>>> Linux.
>>>        
>> Slightly confused now ... you're saying you did look at the transport
>> class and virtio?  But you chose not to do a virtio like interface (for
>> reasons which I'm still not clear on) ...
>>      
> Virtio is Linux-specific and is not available on older kernels which
> our hypervisor/PVSCSI combination does support. Even if we were to use
> virtio-like schema in the hypervisor code we would have to re-implement
> much of the virtio code for kernels earlier than those shipped in '07
> and do the same for other operating systems for no apparent benefit.
> The PCI device abstraction is self-contained and works well on Windows,
> Linux and other guest operating systems and so it was chosen.
>
>    

Several arguments have a history of never winning when you try to get a 
new bit of code in linux.

Number one in the bad justifications is that your design is good because 
it avoids being "linux specific" closely followed by needing to backport :-)

ric

