Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYKTLDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYKTLDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYKTLDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:03:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37117 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbYKTLDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:03:13 -0500
Message-ID: <49254381.1050408@redhat.com>
Date: Thu, 20 Nov 2008 13:01:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] always assign userspace_addr
References: <1226977462-8086-1-git-send-email-glommer@redhat.com> <492436DE.2080906@codemonkey.ws> <20081119184357.GB25917@poweredge.glommer> <49246014.5000001@codemonkey.ws>
In-Reply-To: <49246014.5000001@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
>
> That's not how I read the code.  I see:
>
>>
>> static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
>>                   struct kvm_memory_slot *dont)
>> {
>>     if (!dont || free->rmap != dont->rmap)
>>         vfree(free->rmap);
>
> And it's called as kvm_free_physmem_slot(&old, &new);
>
> new is assigned to old to start out with so old.rmap will equal new.rmap.
>

Hm, if !npages we should just kvm_free_physmem_slot(&old, NULL).


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

