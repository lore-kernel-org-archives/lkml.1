Return-Path: <linux-kernel-owner+w=401wt.eu-S937979AbYEUVSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937979AbYEUVSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758885AbYEUVRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:17:48 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38211 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYEUVRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:17:47 -0400
Message-ID: <483490FB.70703@cs.helsinki.fi>
Date: Thu, 22 May 2008 00:15:39 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org, mpm@selenic.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 2/3] SLUB: make ksize() more strict for page allocator
 pass-through
References: <Pine.LNX.4.64.0805212125310.22291@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805211149210.16064@schroedinger.engr.sgi.com> <4834704D.6020809@cs.helsinki.fi> <Pine.LNX.4.64.0805211412340.17915@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805211412340.17915@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> Hmm, where? page_address() already references ->virtual. I suppose
>> CONFIG_SLUB_DEBUG is a no no as well then so do we want to add a
>> CONFIG_KSIZE_DEBUG config option...? (Btw, I removed the BUG_ON() from kfree()
>> as spotted by Vegard Nossum.)
> 
> If it has to be then add CONFIG_KSIZE_DEBUG. There are a number of 
> debugging techniques (kmem_check?) that should not be compiled in. Maybe 
> add a new config option for those. CONFIG_SLUB_ENABLE_EXPENSIVE_DEBUG?

Oh, kmemcheck is a separate config option already and it's *much much* 
more expensive than the ksize() checks will ever be so they shouldn't be 
bundled together anyway.

		Pekka
