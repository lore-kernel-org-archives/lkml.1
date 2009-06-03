Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZFCKJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZFCKJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 06:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZFCKJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 06:09:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45462
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178AbZFCKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 06:09:10 -0400
Date: Wed, 03 Jun 2009 03:09:11 -0700 (PDT)
Message-Id: <20090603.030911.162861804.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: dbaryshkov@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, sfr@canb.auug.org.au,
       slapin@ossfans.org
Subject: Re: [PATCH 4/6] net: add NL802154 interface for configuration of
 802.15.4 devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1244021964.10665.5.camel@johannes.local>
References: <1244021629-18409-4-git-send-email-dbaryshkov@gmail.com>
	<1244021629-18409-5-git-send-email-dbaryshkov@gmail.com>
	<1244021964.10665.5.camel@johannes.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 03 Jun 2009 11:39:24 +0200

> On Wed, 2009-06-03 at 13:33 +0400, Dmitry Eremin-Solenikov wrote:
> 
>> +enum {
>> +	__IEEE802154_COMMAND_INVALID,
>> +
>> +	IEEE802154_ASSOCIATE_REQ,
>> +	IEEE802154_ASSOCIATE_CONF,
>> +	IEEE802154_DISASSOCIATE_REQ,
>> +	IEEE802154_DISASSOCIATE_CONF,
>> +	IEEE802154_GET_REQ,
>> +	IEEE802154_GET_CONF,
>> +/* 	IEEE802154_GTS_REQ, */
>> +/* 	IEEE802154_GTS_CONF, */
>> +	IEEE802154_RESET_REQ,
>> +	IEEE802154_RESET_CONF,
>> +/* 	IEEE802154_RX_ENABLE_REQ, */
>> +/* 	IEEE802154_RX_ENABLE_CONF, */
> 
> This is a recipe for disaster. Somebody will come along and uncomment
> things. Why this is bad, I leave as an exercise for the reader.

Right, it changes the other request numbers and breaks userspace.

Dmitry you have to pick these numbers as fixed numbers now and do
so in such a way that they will remain unchanged forever because
they are part of the user visible interface.
