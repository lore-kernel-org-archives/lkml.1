Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331Ab0A0OpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0A0OpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285Ab0A0OpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:45:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59937 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab0A0OpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:45:10 -0500
Message-ID: <4B60516F.4020106@canonical.com>
Date: Wed, 27 Jan 2010 15:45:03 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Jie Yang <jie.yang@atheros.com>,
       stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [20/98] atl1c:use common_task instead of	reset_task
 and link_chg_task
References: <20100126233950.GA5372@kroah.com>	<20100126233923.487128431@mini.kroah.org> <20100127052531.GK20093@1wt.eu>
In-Reply-To: <20100127052531.GK20093@1wt.eu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, Jan 26, 2010 at 03:33:46PM -0800, Greg KH wrote:
>> From: Jie Yang <jie.yang@atheros.com>
>>
>> commit cb19054697e92a793f336380fd72c588521178ff upstream.
>>
>> use common_task instead of reset_task and link_chg_task, so it fix "call cancel_work_sync
>> from the work itself".
>>
>> Signed-off-by: Jie Yang <jie.yang@atheros.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Cc: Ben Hutchings <ben@decadent.org.uk>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> I'm going to test this one. I'm randomly seeing my ASUS 1005HA
> hanging after I replug the network cable. I noticed that the
> driver from the Atheros site doesn't have the issue at all. I
> spent a week-end trying to eliminate almost all of the diffs
> between the two drivers to try to spot the faulty code chunk,
> until I realized that I went past the failure point without
> noticing in time because the issue was too much random :-(

Not sure how much this is true or helps. While looking over that patch I was
wondering whether there could be a problem of not having an explicit
cancel_work_sync on the way down. It just seems to disable actions by setting
the flags to 0 but I somehow it felt like it still could be scheduled to run
doing nothing...

-Stefan
> Clearly a non-bisectable issue. But with just this fix, I'll
> be able to tell if the problem is definitely over.
> 
> Regards,
> Willy
> 
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review

