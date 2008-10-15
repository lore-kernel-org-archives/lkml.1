Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYJOMuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYJOMuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYJOMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:50:31 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:49344 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYJOMua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:50:30 -0400
Message-ID: <48F5E704.1070808@csr.com>
Date: Wed, 15 Oct 2008 13:50:12 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] UWB, WUSB, and WLP subsystems for 2.6.28
References: <48EF45BC.1020805@csr.com> <20081014130251.aa008a5e.akpm@linux-foundation.org>
In-Reply-To: <20081014130251.aa008a5e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2008 12:50:12.0733 (UTC) FILETIME=[905E32D0:01C92EC4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Fri, 10 Oct 2008 13:08:28 +0100 David Vrabel <david.vrabel@csr.com> wrote:
>> Please pull the new UWB, WUSB and WLP subsystems from
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream
> 
> didn't happen?

Not yet.

> What is the review status of this work?  I don't remember seeing it on any
> of the lists where I lurk - perhaps a full resend will help things along.

Several iterations were posted and reviewed on the linux-usb mailing list.

> <quick scan>
> 
> Code looks reasonable.
> 
> It has lots of comments which start with /**, which is the
> this-is-kerneldoc token.  Only they're not kerneldoc comments.  These
> should all be converted to kerneldoc, or replace the /** with /*.

I've been fixing these up when I've been updating the documentation.

> uwb_beca_purge() should use time_after() or time_before().

Ok.

> In uwb_bce_print_IEs(), the cast of
> uwb_rc_evt_beacon_WUSB_0100.BeaconInfo[] into a struct uwb_rc_evt_beacon*
> looks really worrisome from an alignment POV.  Can it result in misaligned
> accesses on architectures which don't like that?  (ia64, alpha, ...)

In that function *be is of type struct uwb_rc_evt_beacon which is 48
octets long. struct uwb_beacon_frame only contains u8's so there are no
alignment issues.

> Code does kzalloc(a * b, ..) in some places.  kcalloc() is preferred, so
> readers don't have to worry whether the code is vulnerable to
> multiplicative overflows.

Ok.

> The code has a random mixture of
> zero-lines-between-end-of-locals-and-start-of-code and
> one-line-between-end-of-locals-and-start-of-code (and two line).  The
> latter is usually preferred.

I agree here. I've been fixing these up when had to make other changes
to the affected functions.

> The person who misnamed DEFINE_BITMAP as DECLARE_BITMAP instead gets a
> wedgie.

Not sure you mean here?

> It seems strange that uwb_drp_ie_update(UWB_RSV_STATE_NONE) will free
> rsv->drp_ie then reallocate it.

If rsv->state == UWB_RSV_STATE_NONE the function returns in the switch
before the call to uwb_drp_ie_alloc().

> printk_ratelimit() is a bit silly because it shares state with other
> unrelated subsystems which might be using it.  Direct use of __ratelimit()
> would be better.

Ok.

> All minor stuff - I didn't spend long looking...

I can fix up some of the issues in the next couple of days (use
time_after() and kcalloc()).  Could these subsystems then be merged?

The printk_ratelimit() will take a bit longer.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
