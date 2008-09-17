Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYIQWL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYIQWL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYIQWLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:11:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbYIQWLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:11:51 -0400
Message-ID: <48D17E75.80807@redhat.com>
Date: Wed, 17 Sep 2008 15:02:29 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org>
In-Reply-To: <48D142B2.3040607@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Minor faults are easier; if the page already exists in memory, we should
> just create mappings to it.  If neighbouring pages are also already
> present, then we can can cheaply create mappings for them too.
>
>   

One problem is the accessed bit.  If it's unset, the shadow code cannot 
make the pte present (since it has to trap in order to set the accessed 
bit); if it's set, we're lying to the vm.

This doesn't affect Xen, only kvm.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

