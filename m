Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbYALLOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbYALLOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761985AbYALLNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:13:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59627 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761829AbYALLNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:13:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4788A0E9.9090201@s5r6.in-berlin.de>
Date: Sat, 12 Jan 2008 12:13:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: gregkh@suse.de, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ieee1394 : use class iteration api
References: <20080112095008.GB2893@darkstar.te-china.tietoenator.com> <4788A039.4090802@s5r6.in-berlin.de>
In-Reply-To: <4788A039.4090802@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dave Young wrote:
>> +++ linux.new/drivers/ieee1394/nodemgr.c	2008-01-12 15:20:27.000000000 +0800
> ...
>>  static void nodemgr_remove_uds(struct node_entry *ne)
>>  {
>>  	struct device *dev;
>> -	struct unit_directory *tmp, *ud;
>> +	struct unit_directory *ud;
>>  
>> -	/* Iteration over nodemgr_ud_class.devices has to be protected by
>> -	 * nodemgr_ud_class.sem, but device_unregister() will eventually
>> -	 * take nodemgr_ud_class.sem too. Therefore pick out one ud at a time,
>> -	 * release the semaphore, and then unregister the ud. Since this code
>> -	 * may be called from other contexts besides the knodemgrds, protect the
>> -	 * gap after release of the semaphore by nodemgr_serialize_remove_uds.
>> +	/* Use class_find device to iterate the devices. Since this code
>> +	 * may be called from other contexts besides the knodemgrds,
>> +	 * protect it by nodemgr_serialize_remove_uds.
>>  	 */
>>  	mutex_lock(&nodemgr_serialize_remove_uds);

Hmm, maybe we actually don't need that special mutex after all.  I shall
check that sometime later, independently of your patch series.
-- 
Stefan Richter
-=====-==--- ---= -==--
http://arcgraph.de/sr/
