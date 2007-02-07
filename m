Return-Path: <linux-kernel-owner+w=401wt.eu-S1161462AbXBGWYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161462AbXBGWYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161460AbXBGWYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:24:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:46662 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161455AbXBGWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=VSC+1TtjALY7mKWZawF+dUPSRCVvec0I3dNhbxTCDbpF30XYXsB/mTDrwQIZm5H11+O/2YKrK5WH/IvrCGTKjkpkdRkXe0qjx6BjOBUz0FjQhi3LGwOm2CHsnZXbsRQNYMGgSk0bWD4ew4yQI2XJImxlCchft88du0KFhnPBXYc=
Date: Wed, 7 Feb 2007 23:24:21 +0100 (CET)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Esben Nielsen <nielsen.esben@googlemail.com>,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: [PATCH] Broken ArcNet com20020 pcmcia driver in 2.6.20
In-Reply-To: <45CA0373.5080508@oracle.com>
Message-ID: <Pine.LNX.4.64.0702072315080.31566@frodo.shire>
References: <Pine.LNX.4.64.0702071418440.31566@frodo.shire> <45CA0373.5080508@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Feb 2007, Randy Dunlap wrote:

> Esben Nielsen wrote:
>>  Hi,
>>  I can not get my com20020 pcmcia driver to work as a module under 2.6.20.
>>  There is the build problem:
>
> Please send me your .config file.  I can't seem to reproduce this.

The relevant parts:
...
CONFIG_ARCNET_COM20020=m
# CONFIG_ARCNET_COM20020_ISA is not set
# CONFIG_ARCNET_COM20020_PCI is not set
...
CONFIG_ARCNET_COM20020_CS=m

In this hiracy it is not nice for the com20020 module to check wether 
there are users for it. It breaks the direction of dependency. What if I 
first compile com20020 install it, and then decide I want one of the other
modules? Then would I have to recompile com20020 and reload it.
Therefore: Remove the check, do always export the symbols.

As for actually testing: I have access to ArcNet hardware for 3 more 
weeks. Then I will start at a new job, where there is no ArcNet.

Esben

>
>>  MODPOST 30 modules
>> WARNING:  "com20020_found" [drivers/net/pcmcia/com20020_cs.ko] undefined!
>> WARNING:  "com20020_check" [drivers/net/pcmcia/com20020_cs.ko] undefined!
>>
>>  The solution:
>>  Always export com20020_found and com20020_check.
>>
>>  Esben
>>
>>   drivers/net/arcnet/com20020.c |    3 ---
>>   1 file changed, 3 deletions(-)
>>
>>  Index: linux-2.6.20/drivers/net/arcnet/com20020.c
>>  ===================================================================
>>  --- linux-2.6.20.orig/drivers/net/arcnet/com20020.c
>>  +++ linux-2.6.20/drivers/net/arcnet/com20020.c
>>  @@ -337,11 +337,8 @@ static void com20020_set_mc_list(struct
>>       }
>>   }
>>
>>  -#if defined(CONFIG_ARCNET_COM20020_PCI_MODULE) || \
>>  -    defined(CONFIG_ARCNET_COM20020_ISA_MODULE)
>>   EXPORT_SYMBOL(com20020_check);
>>   EXPORT_SYMBOL(com20020_found);
>>  -#endif
>>
>>   MODULE_LICENSE("GPL");
>
> -- 
> ~ Randy
>
