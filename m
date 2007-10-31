Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbXJaQgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbXJaQgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbXJaQgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:36:03 -0400
Received: from sacred.ru ([62.205.161.221]:41528 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXJaQgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:36:01 -0400
Message-ID: <4728BCBC.8030007@openvz.org>
Date: Wed, 31 Oct 2007 20:34:52 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] The config option itself
References: <47285FEE.9030001@openvz.org>	<4728615D.5070700@openvz.org> <20071031091906.dd84761a.randy.dunlap@oracle.com>
In-Reply-To: <20071031091906.dd84761a.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 31 Oct 2007 19:32:28 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 31 Oct 2007 14:05:01 +0300 Pavel Emelyanov wrote:
> 
>> The option is called NAMESPACES. It can be selectable only
>> if EMBEDDED is chosen (this was Eric's requisition). When
>> the EMBEDDED is off namespaces will be on automatically.
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> 
> and when EMBEDDED is on, it looks like NAMESPACES will be off
> automatically (but user-changeable)?  Is that intended?

Yes. The namespaces are likely not needed on cell-phones or similar,
but if the user does want them - he may turn them on.

This was one of Eric's wishes to give only the embedded people the
choice.

> 
>> ---
>>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index c3de3ed..fc76773 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -400,6 +400,15 @@ config RELAY
>>  
>>  	  If unsure, say N.
>>  
>> +config NAMESPACES
>> +	bool "Namespaces support" if EMBEDDED
>> +	default !EMBEDDED
>> +	help
>> +	  Provides the way to make tasks work with different objects using
>> +	  the same id. For example same IPC id may refer to different objects
>> +	  or same user id or pid may refer to different tasks when used in
>> +	  different namespaces.
>> +
>>  config BLK_DEV_INITRD
>>  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
>>  	depends on BROKEN || !FRV
> 
> 
> ---
> ~Randy
> 

