Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYKENaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYKENaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbYKEN37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:29:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:52873 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbYKEN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:29:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=IpMVp4GGpjS2eFI5Sv1TUWhf1bRh2N9LswDJFIKUfve5e5pgRWLYLzJiABta52eaIz
         oSWibjOzQlvTL88hXURqHsE0kwbS34Gtq9P9foGFoJz4jlYqiffaetqJB8jLGR+qVPRu
         e2/SLC07KIt5dNgOlit8yhKz5OWm85PEWQlE8=
Message-ID: <49119FD0.1000801@panasas.com>
Date: Wed, 05 Nov 2008 15:29:52 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>, michaelc@cs.wisc.edu,
       fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sami.Iren@seagate.com, pw@padd.com
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
References: <491073BB.4000900@panasas.com>	 <1225817046-5946-1-git-send-email-bharrosh@panasas.com>	 <20081104111037.bcae04e5.akpm@linux-foundation.org>	 <49119774.10706@panasas.com> <1225890572.4703.15.camel@localhost.localdomain>
In-Reply-To: <1225890572.4703.15.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2008-11-05 at 14:54 +0200, Boaz Harrosh wrote:
>>>> +    struct _osd_io_info {
>>>> +            struct bio *bio;
>>>> +            u64 total_bytes;
>>> u64(!)
>>>
>> Do you mean that I need to use __u64? or what do you mean?
> 
> He means you've used u64 in a header without actually including any file
> that defines the typedef.  Linux header files aren't supposed to depend
> on include order.  They're supposed to stand alone.  The point is that
> if I include just #include osd_initiator.h into an empty kernel file
> it's not supposed to spit undefined errors.
> 
> Right at the moment the u64 probably works because blkdev.h #includes
> the file which defines it, but you're not supposed to rely on that.
> 
> James
> 

I have addressed that issue. The osd_initiator.h includes the
osd_protocol.h file. osd_protocol.h does include all the types
needed. All of the osd_initiator.h types are derived from
osd_protocol.h, the only added definitions are from blkdev.h.

The very first #include in osd_initiator.c is osd_initiator.h
which preforms exactly the check you suggest.

Boaz
