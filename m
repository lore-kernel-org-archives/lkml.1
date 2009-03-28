Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZC1AIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZC1AIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZC1AIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:08:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZC1AIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:08:21 -0400
Message-ID: <49CD69EB.6000000@redhat.com>
Date: Fri, 27 Mar 2009 20:06:03 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       frankeh@watson.ibm.com, akpm@osdl.org, nickpiggin@yahoo.com.au,
       hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com> <1238195024.8286.562.camel@nimitz>
In-Reply-To: <1238195024.8286.562.camel@nimitz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Fri, 2009-03-27 at 16:09 +0100, Martin Schwidefsky wrote:
>> If the host picks one of the
>> pages the guest can recreate, the host can throw it away instead of writing
>> it to the paging device. Simple and elegant.
> 
> Heh, simple and elegant for the hypervisor.  But I'm not sure I'm going
> to call *anything* that requires a new CPU instruction elegant. ;)

I am convinced that it could be done with a guest-writable
"bitmap", with 2 bits per page.  That would make this scheme
useful for KVM, too.

> I don't see any description of it in there any more, but I thought this
> entire patch set was to get rid of the idiotic triple I/Os in the
> following scenario:

> I don't see that mentioned at all in the current description.
> Simplifying the hypervisor is hard to get behind, but cutting system I/O
> by 2/3 is a much nicer benefit for 1200 lines of invasive code. ;)

Cutting down on a fair bit of IO is absolutely worth
1200 lines of fairly well isolated code.

> Can we persuade the hypervisor to tell us which pages it decided to page
> out and just skip those when we're scanning the LRU?

The easiest "notification" points are in the page fault
handler and the page cache lookup code.

-- 
All rights reversed.
