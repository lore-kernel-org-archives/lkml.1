Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZCKQgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZCKQgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZCKQf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:35:57 -0400
Received: from mail-gx0-f167.google.com ([209.85.217.167]:42571 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZCKQf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <20090311162623.GE21831@suse.de>
References: <20090306160818.404.92700.stgit@localhost.localdomain>
	 <20090311162623.GE21831@suse.de>
Date: Wed, 11 Mar 2009 10:35:29 -0600
Message-ID: <fa686aa40903110935g155fbf7m83f4aead71d72488@mail.gmail.com>
Subject: Re: [RFC] drivers/base: Add bus_register_notifier_alldev() variant
From: Grant Likely <grant.likely@secretlab.ca>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:26 AM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Mar 06, 2009 at 09:10:19AM -0700, Grant Likely wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>>
>> bus_register_notifier_alldev() is a variation on bus_register_notifier()
>> which also triggers the notifier callback for devices already on the bus
>> and already bound to drivers.
>>
>> This function is useful for the case where a driver needs to get a
>> reference to a struct device other than the one it is bound to and
>> it is not known if the device will be bound before or after this
>> function is called.  For example, an Ethernet device connected to
>> a PHY that is probed separately.
>
> Can't you just walk the list of all devices already on the bus to get
> "notified" of them, and then register your notifier handler as well (or
> register it first, and then walk the list, which is pretty much what
> your patch does)?

Yes, and I originally did, but it looks to me like a useful common
pattern that is less error prone than open coding it.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
