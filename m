Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703Ab0ATNbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0ATNbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584Ab0ATNbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:31:51 -0500
Received: from mail2.picochip.com ([82.111.145.34]:37691 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751559Ab0ATNbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:31:51 -0500
Date: Wed, 20 Jan 2010 13:31:45 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tomasz Fujak <t.fujak@samsung.com>,
       jpihet@mvista.com, p.osciak@samsung.com, jamie.iles@picochip.com,
       will.deacon@arm.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, mingo@elte.hu,
       linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event description
	in sysfs
Message-ID: <20100120133145.GE4089@wear.picochip.com>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com> <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.u6tslipz7p4s8u@pikus>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Wed, 20 Jan 2010 13:30:29 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:57:08AM +0100, Michał Nazarewicz wrote:
>>> The following patches provide a sysfs entry with hardware event human
>>> readable description in the form of "0x%llx\t%lld-%lld\t%s\t%s" %
>>> (event_value, minval, maxval, name, description) and means to populate
>>> the file.
>>>
>>> The intended use is twofold: for users to read the list directly and
>>> for tools (like perf).
>
> On Wed, 20 Jan 2010 10:16:39 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
>> Why do this in kernel space? Listing available events seems like
>> something we can do from userspace just fine.
>
> IMO kernel knows better what hardware it's running on and user space
> should not care and if this list were to be kept in user space it
> would have to detect the processor it's running on and act accordingly.
>
> Also, keeping the list in user space could lead to different software
> maintaining separate lists which would get out of sync.  I think it's
> easier to update a single list in kernel then wait till all the
> software packages update theirs.
>
> This also means that different tools would use different names and
> descriptions for the events which would only increase confusion.
Personally I think this is a good idea. At the moment 'perf list' gives lots
of events that the system isn't capable of counting. Admittedly it's fairly
easy to see if they are supported but it would be nice if the list reflected
the countable events. perf already does this for the tracing events so it
would be nice if it did the same for the hardware events. I guess the same
hierarchy would be nice too.

The main problem I can envisage is that different CPUs could use slightly
different names for the same event.

Jamie
