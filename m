Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0CGUdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 15:33:49 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62786 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0CGUds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 15:33:48 -0500
MIME-Version: 1.0
In-Reply-To: <20100307180534.GA3604@suse.de>
References: <20100307064111.1442.63478.stgit@angua> <20100307180534.GA3604@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 7 Mar 2010 13:33:27 -0700
X-Google-Sender-Auth: c43b6028bb41b7d4
Message-ID: <fa686aa41003071233t686969f3y533a2c5a6b952b27@mail.gmail.com>
Subject: Re: [RFC] drivercore: Add of_match_table to the common device drivers
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kay.sievers@vrfy.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 7, 2010 at 11:05 AM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Mar 06, 2010 at 11:47:00PM -0700, Grant Likely wrote:
>> OF-style matching can be available to any device, on any type of bus.
>> This patch allows any driver to provide an OF match table when CONFIG_OF
>> is enabled so that drivers can be bound against devices described in
>> the device tree.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> Hi Greg and Kay,
>>
>> Here is a potentially even more controversial RFC patch, the relevant
>> chunk being the addition of an of-style match table to struct device_driver
>> when CONFIG_OF is set.  The idea being that OF style device binding is
>> applicable on any bus, regardless of the bus type.  Each bus' probe could
>> be trivially extended to allow for an OF-style probe match.
>>
>> I've used a #ifdef in this version, but it doesn't have to be conditional
>> if that would make for cleaner code.  Either way, none of the core code
>> would need to have and #ifdef bits.
>>
>> As with the previous patch, I want to get feedback before I proceed too
>> far down this path.
>
> I have no objection to this patch at all, it looks good to me.
>
> Perhaps, in the future, you might be able to move the OF driver/device
> binding into the driver core itself to make it easier in the end.  But
> for now, feel free to add:
>        Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> and send it off through your tree.

Thanks Greg.

Yes, I seem to be moving in that direction.  The OF api's are turning
out to be quite complementary to the rest of the driver model.  If
CONFIG_OF is enabled, then a whole bunch of routines become available
to drivers for fetching data as an alternative to pdata.  If not, then
the OF apis become empty inline stubs that return invalid or error
codes.  The nice thing is that the apis all work the same, regardless
of the underlying bus interface, so it is usable by more than just the
platform & of_platform busses.

I've got a metric truckload of patches to post that go in this
direction, but I'm waiting until after the merge window so I don't add
to the normal bedlam.  :-)

Cheers,
g.

---
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
