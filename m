Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXDZD2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXDZD2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXDZD2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:28:49 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56678 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbXDZD2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:28:48 -0400
Message-ID: <46301C1A.7050201@vmware.com>
Date: Wed, 25 Apr 2007 20:27:22 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>	<20070425044813.f83dde4e.akpm@linux-foundation.org>	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>	<462F9B64.3020107@goop.org> <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>	<462FD179.6070802@goop.org> <m1ps5sozt6.fsf@ebiederm.dsl.xmission.com>	<462FDF6D.8050903@goop.org> <m13b2oow70.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b2oow70.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I suspect what we want to do is come up with a function to call
> to test to see if a page should be read-only and map such pages
> _PAGE_KERNEL_RO, or _PAGE_KERNEL_RO_EXEC if it's code.
>
> Speaking of things what are paravirt_alloc_pd and parafirt_alloc_pd 
> supposed to do?
>   

For hypervisors which shadow kernel page tables, none of these concerns 
with keeping page tables read-only arise.  However, another set of 
concerns does arise with maintaining shadow synchronization.  One of 
those problems is keeping the hypervisor aware of when pages are being 
used as page tables.

However, it turns out both direct page table and shadow page table 
implementations can be made to use one page table allocation function; 
in the direct page table case (as for Xen), this is the point where page 
tables can be recognized and made read-only.  So this is the dual 
purpose of the paravirt_alloc_p[dt] functions.

Zach
