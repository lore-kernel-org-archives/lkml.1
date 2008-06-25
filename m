Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYFYDtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYFYDtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYFYDta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:49:30 -0400
Received: from gw.goop.org ([64.81.55.164]:37580 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYFYDt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:49:29 -0400
Message-ID: <4861C03A.90107@goop.org>
Date: Tue, 24 Jun 2008 23:49:14 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix pte allocation in "x86: introduce init_memory_mapping
 for 32bit"
References: <48616800.8030603@goop.org> <86802c440806241441v5f2c0870g379695cacd5dfb9b@mail.gmail.com>
In-Reply-To: <86802c440806241441v5f2c0870g379695cacd5dfb9b@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> thanks.
>
> my test system never use the area from table_start to table_end. and I
> wonder why init_pgtable is that big..

This code looks just like the 64-bit code (I guess it's becoming prime 
for unification), and I'd just spent some time debugging a bug in Xen64 
caused by an overrun of the allocated area when creating non-PSE 
mappings of physical memory.  I didn't observe a specific problem with 
this code, but consistency and pattern matching made it seem like a 
necessary addition.  It only ends up reserving the amount of space 
actually used, so there's no wasted memory.

If you use PSE to create the mapping and have enough mapped pages anyway 
(small kernel), then you may not end up using any of this space.

    J
