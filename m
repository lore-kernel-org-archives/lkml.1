Return-Path: <linux-kernel-owner+w=401wt.eu-S933985AbZGQCRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbZGQCRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933969AbZGQCRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:17:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:8317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933968AbZGQCRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,415,1243839600"; 
   d="scan'208,223";a="533586277"
From: "Lu, Guanqun" <guanqun.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "jeremy@goop.org" <jeremy@goop.org>
Date: Fri, 17 Jul 2009 10:16:55 +0800
Subject: RE: [PATCH 1/3] add flag IRQF_NO_SUSPEND in 'struct irqaction'
Thread-Topic: [PATCH 1/3] add flag IRQF_NO_SUSPEND in 'struct irqaction'
Thread-Index: AcoGgTFli7m1RZHfSlKpvMSulIo4aAAAunUA
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7701E6EA157E@PDSMSX501.ccr.corp.intel.com>
References: <1247834204-3084-1-git-send-email-guanqun.lu@intel.com>
 <200907170352.11749.rjw@sisk.pl>
In-Reply-To: <200907170352.11749.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_8FED46E8A9CA574792FC7AACAC38FE7701E6EA157EPDSMSX501ccrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_8FED46E8A9CA574792FC7AACAC38FE7701E6EA157EPDSMSX501ccrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>Sent: Friday, July 17, 2009 9:52 AM
>To: Lu, Guanqun
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; jeremy@goop.org
>Subject: Re: [PATCH 1/3] add flag IRQF_NO_SUSPEND in 'struct irqaction'
>
>On Friday 17 July 2009, Guanqun Lu wrote:
>> We currently only bypass IRQF_TIMER in '__disable_irq',
>> but Xen specific IRQs should not be disabled either.
>> This commit adds a new flag to accompolish this goal
>> without being mixed up with IRQF_TIMER flag.
>
>For some obscure reasons [2/3] didn't reach my inbox.  The other 2 patches
>look fine to me.

I'm sending patch [2/3] via attachment in case it's lost accidentally by gi=
t-send-email again.
Sorry for the inconvenience it may cause.

Guanqun

>
>Best,
>Rafael
>
>
>> Signed-off-by: Guanqun Lu <guanqun.lu@intel.com>
>> ---
>>  include/linux/interrupt.h |    1 +
>>  kernel/irq/manage.c       |    3 ++-
>>  2 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 2721f07..99264c3 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -58,6 +58,7 @@
>>  #define IRQF_PERCPU		0x00000400
>>  #define IRQF_NOBALANCING	0x00000800
>>  #define IRQF_IRQPOLL		0x00001000
>> +#define IRQF_NO_SUSPEND		0x00002000
>>
>>  /*
>>   * Bits used by threaded handlers:
>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> index 50da676..3dc4e74 100644
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -192,7 +192,8 @@ static inline int setup_affinity(unsigned int irq, s=
truct irq_desc
>*desc)
>>  void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspen=
d)
>>  {
>>  	if (suspend) {
>> -		if (!desc->action || (desc->action->flags & IRQF_TIMER))
>> +		if (!desc->action ||
>> +		    (desc->action->flags & (IRQF_TIMER | IRQF_NO_SUSPEND)))
>>  			return;
>>  		desc->status |=3D IRQ_SUSPENDED;
>>  	}

--_002_8FED46E8A9CA574792FC7AACAC38FE7701E6EA157EPDSMSX501ccrc_
Content-Type: application/octet-stream;
	name="0002-add-IRQF_NO_SUSPEND-for-bind_ipi_to_irqhandler.patch"
Content-Description: 0002-add-IRQF_NO_SUSPEND-for-bind_ipi_to_irqhandler.patch
Content-Disposition: attachment;
	filename="0002-add-IRQF_NO_SUSPEND-for-bind_ipi_to_irqhandler.patch";
	size=882; creation-date="Fri, 17 Jul 2009 10:12:52 GMT";
	modification-date="Fri, 17 Jul 2009 20:30:09 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmY2Q4YTMyYzE2ZDUwOTI3MGVmOTAwNjliOTJkYWRjNTA2Y2U0OWVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHdWFucXVuIEx1IDxndWFucXVuLmx1QGludGVsLmNvbT4KRGF0
ZTogVHVlLCAxNCBKdWwgMjAwOSAwNToxNToxMiAtMDQwMApTdWJqZWN0OiBbUEFUQ0ggMi8zXSBh
ZGQgSVJRRl9OT19TVVNQRU5EIGZvciAnYmluZF9pcGlfdG9faXJxaGFuZGxlcicKClRoaXMgZnVu
Y3Rpb24gZXhwb3J0cyB0aGUgaXBpIGZ1bmN0aW9uYWxpdHkgdG8ga2VybmVsLAphbmQgdGhlIGNv
cnJlc3BvbmRpbmcgaXJxIHNob3VsZCBub3QgYmUgZGlzYWJsZWQgZHVyaW5nCmhvc3QgUzMgc3Vz
cGVuZC4KClNpZ25lZC1vZmYtYnk6IEd1YW5xdW4gTHUgPGd1YW5xdW4ubHVAaW50ZWwuY29tPgot
LS0KIGRyaXZlcnMveGVuL2V2ZW50cy5jIHwgICAgMSArCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9ldmVu
dHMuYyBiL2RyaXZlcnMveGVuL2V2ZW50cy5jCmluZGV4IGFiYWQ3MWIuLmYwNjQ3YmQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMveGVuL2V2ZW50cy5jCisrKyBiL2RyaXZlcnMveGVuL2V2ZW50cy5jCkBA
IC01MzIsNiArNTMyLDcgQEAgaW50IGJpbmRfaXBpX3RvX2lycWhhbmRsZXIoZW51bSBpcGlfdmVj
dG9yIGlwaSwKIAlpZiAoaXJxIDwgMCkKIAkJcmV0dXJuIGlycTsKIAorCWlycWZsYWdzIHw9IElS
UUZfTk9fU1VTUEVORDsKIAlyZXR2YWwgPSByZXF1ZXN0X2lycShpcnEsIGhhbmRsZXIsIGlycWZs
YWdzLCBkZXZuYW1lLCBkZXZfaWQpOwogCWlmIChyZXR2YWwgIT0gMCkgewogCQl1bmJpbmRfZnJv
bV9pcnEoaXJxKTsKLS0gCjEuNi4xLnJjMwoK

--_002_8FED46E8A9CA574792FC7AACAC38FE7701E6EA157EPDSMSX501ccrc_--
