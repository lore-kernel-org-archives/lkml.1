Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYAYGgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYAYGgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 01:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYAYGgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 01:36:04 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:57153
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYAYGgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 01:36:01 -0500
Message-ID: <4799834C.8050608@qumranet.com>
Date: Fri, 25 Jan 2008 08:35:56 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
References: <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <20080123114136.GE15848@v2.random> <20080123123230.GH26420@sgi.com> <20080123173325.GG7141@v2.random> <Pine.LNX.4.64.0801231220590.13547@schroedinger.engr.sgi.com> <20080124154239.GP7141@v2.random> <Pine.LNX.4.64.0801241205510.22285@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0801241205510.22285@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 24 Jan 2008, Andrea Arcangeli wrote:
>
>   
>> I think you should consider if you can also build a rmap per-MM like
>> KVM does and index it by the virtual address like KVM does.
>>     
>
> Yes we have that.
>
> If we have that then we do not need the mmu_notifier. 
> We could call it with a page parameter and then walk the KVM or XPmem 
> reverse map to directly find all the ptes we need to clear. There is no 
> need then to add a new field to the mm_struct.
>   

The reason the new field is needed is because the Linux mm does not 
understand the secondary pte format and zapping protocol.  Locating the 
secondary ptes is just a part of the problem.


-- 
Any sufficiently difficult bug is indistinguishable from a feature.

