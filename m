Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbYKKTJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbYKKTJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYKKTJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:09:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYKKTJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:09:42 -0500
Message-ID: <4919D83C.20807@redhat.com>
Date: Tue, 11 Nov 2008 21:08:44 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       chrisw@redhat.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <20081111103051.979aea57.akpm@linux-foundation.org> <4919D370.7080301@redhat.com>
In-Reply-To: <4919D370.7080301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Andrew Morton wrote:
>> The whole approach seems wrong to me.  The kernel lost track of these
>> pages and then we run around post-facto trying to fix that up again. 
>> Please explain (for the changelog) why the kernel cannot get this right
>> via the usual sharing, refcounting and COWing approaches.
>>   
>
> For kvm, the kernel never knew those pages were shared.  They are 
> loaded from independent (possibly compressed and encrypted) disk 
> images.  These images are different; but some pages happen to be the 
> same because they came from the same installation media.

As Avi said, in kvm we cannot know how the guest is going to map its 
pages, we have nothing to do but to scan for the identical pages
(you can have pages that are shared that are in whole different offset 
inside the guest)

>
> For OpenVZ the situation is less clear, but if you allow users to 
> independently upgrade their chroots you will eventually arrive at the 
> same scenario (unless of course you apply the same merging strategy at 
> the filesystem level).
>

