Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbZDAOsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbZDAOsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbZDAOsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:48:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758918AbZDAOsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:48:14 -0400
Message-ID: <49D37E21.2000609@redhat.com>
Date: Wed, 01 Apr 2009 10:45:53 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 4/6] Guest page hinting: writable page table entries.
References: <20090327150905.819861420@de.ibm.com>	<20090327151012.398894143@de.ibm.com>	<49D36B4E.7000702@redhat.com> <20090401163658.60f851ed@skybase>
In-Reply-To: <20090401163658.60f851ed@skybase>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Wed, 01 Apr 2009 09:25:34 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
>> Martin Schwidefsky wrote:
>>
>> This code has me stumped.  Does it mean that if a page already
>> has the PageWritable bit set (and count_ok stays 0), we will
>> always mark the page as volatile?
>>
>> How does that work out on !s390?
> 
> No, we will not always mark the page as volatile. If PG_writable is
> already set count_ok will stay 0 and a call to page_make_volatile is
> done. This differs from page_set_volatile as it repeats all the
> required checks, then calls page_set_volatile with a PageWritable(page)
> as second argument. What state the page will get depends on the
> architecture definition of page_set_volatile. For s390 this will do a
> state transition to potentially volatile as the PG_writable bit is set.
> On architecture that cannot check the dirty bit on a physical page basis
> you need to make the page stable.

Good point. I guess that means patch 4/6 checks out right, then :)

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
