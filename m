Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbXJXUfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbXJXUfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbXJXUfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:35:06 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4194 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbXJXUfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:35:04 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 24 Oct 2007 20:35:02.0712 (UTC) FILETIME=[5A9E8380:01C8167D]
Content-class: urn:content-classes:message
Subject: Re: [PATCH] fix "passing argument # of '__memcpy' discards qualifiers from pointer target type" warnings
Date: Wed, 24 Oct 2007 16:35:01 -0400
Message-ID: <Pine.LNX.4.61.0710241632240.19021@chaos.analogic.com>
In-reply-to: <E1Iki6s-0000g8-N2@be1.lrz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fix "passing argument # of '__memcpy' discards qualifiers from pointer target type" warnings
Thread-Index: AcgWfVqot1PQMwZySIW1Lsu7fZMWKw==
References: <9hPIG-7In-19@gated-at.bofh.it> <E1Iki6s-0000g8-N2@be1.lrz>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Bodo Eggert" <7eggert@gmx.de>
Cc: =?iso-8859-1?Q?Miguel_Bot=F3n?= <mboton.lkml@gmail.com>,
       <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Oct 2007, Bodo Eggert wrote:

> Miguel Botón <mboton.lkml@gmail.com> wrote:
>
>> This patch fixes the warnings "passing argument 1 of '__memcpy' discards
>> qualifiers from pointer target type" and "passing argument 2 of '__memcpy'
>> discards qualifiers from pointer target type" when compiling some files.
>>
>> I don't really know if this is the best way but at least I don't get more
>> warnings.
>
>> +++ linux-2.6.24-rc1/fs/cifs/dir.c    2007-10-24 15:49:44.000000000 +0200
>> @@ -585,6 +585,7 @@
>
>> +     unsigned char *dstname = (unsigned char *)a->name;
>
>> @@ -593,7 +594,7 @@
>
>> -             memcpy((unsigned char *)a->name, b->name, a->len);
>> +             memcpy(dstname, b->name, a->len);
>
> This looks like a compiler bug. Get the gcc people to fix it.
> -- 
> Top 100 things you don't want the sysadmin to say:
> 20. ...and if we just swap these two disc controllers like _this_...
>
> Friß, Spammer: wd@bse.7eggert.dyndns.org esmpv@zxw.7eggert.dyndns.org
> -

According to the header, the pointer is a (const struct qstr *). Not
a gcc bug if somebody is writing there. Probably the header needs
fixing.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
