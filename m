Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZLWPEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZLWPEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZLWPEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:04:08 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:41543 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbZLWPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:04:03 -0500
Message-ID: <4B32315C.1000006@codemonkey.ws>
Date: Wed, 23 Dec 2009 09:03:56 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com> <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu> <20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com> <20091223121431.GF20539@basil.fritz.box>
In-Reply-To: <20091223121431.GF20539@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 06:14 AM, Andi Kleen wrote:
>> http://www.redhat.com/f/pdf/summit/cwright_11_open_source_virt.pdf
>>
>> See slide 32.  This is without vhost-net.
>
> Thanks. Do you also have latency numbers?

They'll be along the lines of the vbus numbers.

But I caution people from relying too much on just netperf TCP_RR and 
TCP_STREAM numbers.  There's a lot of heuristics in play in getting this 
sort of numbers.  They really aren't good ways to compare different drivers.

A better thing to do is look more deeply at the architectures and 
consider things like the amount of copying imposed, the cost of 
processing an exit, and the mechanisms for batching packet transmissions.

The real argument that vbus needs to make IMHO is not "look how much 
better my netperf TCP_STREAM results are" but "we can eliminate N copies 
from the transmit path and virtio-net cannot" or "we require N exits to 
handle a submission and virtio-net requires N+M".

It's too easy to tweak for benchmarks.

Regards,

Anthony Liguori
