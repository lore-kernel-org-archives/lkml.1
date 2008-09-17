Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYIQVrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYIQVrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYIQVrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:47:24 -0400
Received: from gw.goop.org ([64.81.55.164]:35907 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbYIQVrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:47:24 -0400
Message-ID: <48D17AEC.3070804@goop.org>
Date: Wed, 17 Sep 2008 14:47:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <20080917142805.41e2b07e@bree.surriel.com>
In-Reply-To: <20080917142805.41e2b07e@bree.surriel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Wed, 17 Sep 2008 10:47:30 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Minor faults are easier; if the page already exists in memory, we should
>> just create mappings to it.  If neighbouring pages are also already
>> present, then we can can cheaply create mappings for them too.
>>     
>
> This is especially true for mmaped files, where we do not have to
> allocate anything to create the mapping.
>   

Yes, that was the case I particularly had in mind.

> Populating multiple PTEs at a time is questionable for anonymous
> memory, where we'd have to allocate extra pages.
>   

It might be worthwhile if the memory access pattern to anonymous memory
is linear.  I agree that speculatively allocating pages on a random
access region would be a bad idea.

    J
