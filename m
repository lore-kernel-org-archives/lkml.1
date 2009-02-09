Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbZBIWql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbZBIWql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZBIWqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:46:18 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:45979 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752140AbZBIWqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:46:16 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] auxdisplay: remove PARPORT dependency
Date: Mon, 9 Feb 2009 17:46:05 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090120C0B8@mi8nycmail19.Mi8.com>
In-Reply-To: <20090209143716.57467016.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] auxdisplay: remove PARPORT dependency
Thread-Index: AcmLBwph6v907Sz+SK+4aNP91ipQ/wAADUig
References: <BD79186B4FD85F4B8E60E381CAEE19090120BD69@mi8nycmail19.Mi8.com> <20090209143716.57467016.akpm@linux-foundation.org>
From: "hartleys" <hartleys@visionengravers.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <miguel.ojeda.sandonis@gmail.com>
X-OriginalArrivalTime: 09 Feb 2009 22:46:11.0134 (UTC) FILETIME=[345DEDE0:01C98B08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 09, 2009 3:37 PM, Andrew Morton wrote:
> (please cc the maintainers on patches)

Sorry about missing that.  I wasn't sure how patches to Kconfig were
handled.

>> Remove PARPORT dependency for Auxiliary Display support.
>> 
>> This is not needed since the dependency for the KS0108 driver is 
>> PARPORT_PC.
>> 
>
> OK, but the patch also accidentally removes the parport dependency
> from cfag12864b.c and cfag12864bfb.c.
>
> A quick grep indicates that those drivers don't need parport, but I
> didn't look very closely.

I think the dependency will be handled automatically.  Both cfag12864b.c
and cfag12864bfb.c are enabled by CFAG12864B which has a dependency on
KS0108, which it turn depends on PARPORT_PC.

>> 
>> diff --git a/drivers/auxdisplay/Kconfig b/drivers/auxdisplay/Kconfig 
>> index 14b9d5f..c07e725 100644
>> --- a/drivers/auxdisplay/Kconfig
>> +++ b/drivers/auxdisplay/Kconfig
>> @@ -6,7 +6,6 @@
>>  #
>>  
>>  menuconfig AUXDISPLAY
>> -	depends on PARPORT
>>  	bool "Auxiliary Display support"
>>  	---help---
>>  	  Say Y here to get to see options for auxiliary display
drivers.
>> @@ -14,7 +13,7 @@ menuconfig AUXDISPLAY
>>  
>>  	  If you say N, all options in this submenu will be skipped and 
>> disabled.
>>  
>> -if AUXDISPLAY && PARPORT
>> +if AUXDISPLAY
>>  
>>  config KS0108
>>  	tristate "KS0108 LCD Controller" 
>
> Your email client wordwraps patches.  Please fix that up for next
time.

Sorry about that also.  Do you have any idea how to correctly configure
Outlook to not mess with wordwraps?  I know, it's a stupid client, but's
that's what I'm stuck with here at work.  I've been beating my head with
it trying to get it to work correctly.

