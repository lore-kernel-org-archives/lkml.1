Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYAXGDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYAXGDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYAXGDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:03:35 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53252
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYAXGDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:03:34 -0500
Message-ID: <4798289B.1000007@qumranet.com>
Date: Thu, 24 Jan 2008 07:56:43 +0200
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
References: <478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <479716AD.5070708@qumranet.com> <20080123105246.GG26420@sgi.com> <Pine.LNX.4.64.0801231145210.13547@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0801231145210.13547@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 23 Jan 2008, Robin Holt wrote:
>
>   
>>> That won't work for kvm.  If we have a hundred virtual machines, that means
>>> 99 no-op notifications.
>>>       
>> But 100 callouts holding spinlocks will not work for our implementation
>> and even if the callouts are made with spinlocks released, we would very
>> strongly prefer a single callout which messages the range to the other
>> side.
>>     
>
>
> Andrea wont have 99 no op notifications. You will have one notification to 
> the kvm subsystem (since there needs to be only one register operation 
> for a subsystem that wants to get notifications). What do you do there is 
> up to kvm. If you want to call some function 99 times then you are free to 
> do that.
>   

What I need is a list of (mm, va) that map the page.  kvm doesn't have 
access to that, export notifiers do.  It seems reasonable that export 
notifier do that rmap walk since they are part of core mm, not kvm.

Alternatively, kvm can change its internal rmap structure to be page 
based instead of (mm, hva) based.  The problem here is to size this 
thing, as we don't know in advance (when the kvm module is loaded) 
whether 0% or 100% (or some value in between) of system memory will be 
used for kvm.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

