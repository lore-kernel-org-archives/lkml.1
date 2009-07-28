Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZG1Nki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZG1Nki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZG1Nkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:40:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZG1Nkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:40:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Palix <npalix@diku.dk>
Subject: Re: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and DEVICE_OBJECT typedefs into their corresponding structs
Date: Tue, 28 Jul 2009 15:40:31 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: gregkh@suse.de, hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200907281030.45317.npalix@diku.dk>
In-Reply-To: <200907281030.45317.npalix@diku.dk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907281540.31805.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19GOD9BBXqH4noJGAlva/BCeGAKrOoVSztFn2S
 DGC9WEeJCPYaUqN7ysXXkZhlu4uBq8vqhRrzwwktr3TRLoMGgz
 I3AtXWTUzn3r5C0E7vADHglZUw7dNhG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Nicolas Palix wrote:
> Remove typedef DEVICE_OBJECT and use a struct with the same name
> instead. The new struct name uses lower case (struct device_object).
> 
> Remove typedef PDEVICE_OBJECT which aliases a pointer and use the
> corresponding renamed struct pointer (struct device_object *).
> 
> Here is the semantic patch generated to perform this transformation:
> (http://www.emn.fr/x-info/coccinelle/)
> 

The patch looks technically correct and improves the code, but
I'd suggest renaming the structure to fall into a proper namespace.
The name device_object is extremely generic and should not be
defined as part of a single driver.
Simply putting it into a namespace here would make it hv_device_object,
or even mshv_device_object ('hv' still is very generic), but then the
'object' part is still redundant. Since it is part of the 'vmbus'
layer, how about naming it 'struct vmbus_device'?

	Arnd <><
