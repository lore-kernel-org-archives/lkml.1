Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYAGNZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYAGNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYAGNZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:25:10 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46943 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYAGNZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:25:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <478227D5.8050402@s5r6.in-berlin.de>
Date: Mon, 07 Jan 2008 14:23:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Greg KH <gregkh@suse.de>, Dave Young <hidave.darkstar@gmail.com>,
       stern@rowland.harvard.edu, peterz@infradead.org, davem@davemloft.net,
       jarkao2@gmail.com, krh@redhat.com, dbrownell@users.sourceforge.net,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org,
       linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com> <20080107020944.GA3637@darkstar.te-china.tietoenator.com> <20080107084528.GA8365@suse.de> <200801070101.15168.david-b@pacbell.net>
In-Reply-To: <200801070101.15168.david-b@pacbell.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Monday 07 January 2008, Greg KH wrote:
>> Most of the non-driver core code should be converted to not use the
>> lock in the class at all.  They should use a local lock instead.
> 
> Or better yet, that yet-to-be-written class_for_each_instance()
> iterator ... :)

By far most of the usages of class.semaphore or class.mutex in drivers
are to protect the class.devices list.  The only¹ right thing to do
there is to keep using the class.{semaphore,mutex}.  The more elegant
variation of this would be David's class_for_each_instance() iterator
which would allow us to hide the locking details from the drivers.

-------
¹)  Well, another correct thing to do would be to not take any locks or
mutexes in the driver core but instead let the drivers do the necessary
serialization between calls like class_device_add() and the likes and
list iterations.  But this would complicate the API because of the
additional locking requirements, and hence would invariably result in
buggy usages of the API.
-- 
Stefan Richter
-=====-==--- ---= --===
http://arcgraph.de/sr/
