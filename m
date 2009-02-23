Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZBWOZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZBWOZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZBWOZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:25:14 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:35756 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbZBWOZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:25:12 -0500
Message-ID: <49A2B1C3.2010904@hp.com>
Date: Mon, 23 Feb 2009 09:25:07 -0500
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: arvidjaar@mail.ru, vladislav.yasevich@hp.com, chuck.lever@oracle.com,
       tytso@mit.edu, Valdis.Kletnieks@vt.edu, rjw@sisk.pl,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org, fubar@us.ibm.com
Subject: Re: [PATCH] bonding: move IPv6 support into a separate kernel module
References: <499F4B61.3050508@hp.com> <20090221.235901.244910753.davem@davemloft.net>
In-Reply-To: <20090221.235901.244910753.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Brian Haley <brian.haley@hp.com>
> Date: Fri, 20 Feb 2009 19:31:29 -0500
> 
>> [Possible fix for bonding IPv6 regression reported by Andrey Borzenkov,
>> tried to keep all Cc's]
>>
>> This patch moves the IPv6 bonding code into a separate kernel module
>> called bonding_ipv6 if either bonding or IPv6 are built as modules.
>> If both are built into the kernel then this is as well.  Bonding_ipv6.ko
>> registers an "send_unsol_na" function pointer for the unsolicited
>> advertisement function to be called on a failover - the default action
>> is to do nothing.  The notifier callbacks are now registered in this
>> module and not in the base bonding module.
>>
>> Signed-off-by: Brian Haley <brian.haley@hp.com>
> 
> Thanks for taking the time to work on this Brian.
> 
> I wonder if we aren't just trading one evil for another.
> 
> Right now just configuring bonding will get the bonding
> module loaded and the ipv6 facilities will be visible.
> 
> Now with your change, the user has to explicitly load
> the module.  That's extremely user-unfriendly.

I agree, part of me just wanted to make sure it could be done, and figured it 
was just a matter of time before my hand was forced, or the original commit was 
reverted.

One idea is that the IPv6 notifier, addrconf_notify(), could try and load the 
bonding_ipv6 module if a device with IFF_MASTER registered.  I haven't 
prototyped it to see if it would actually work, seemed like a hack.

-Brian
