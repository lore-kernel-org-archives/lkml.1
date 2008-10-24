Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYJXPEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYJXPEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYJXPEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:04:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:53874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbYJXPEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:04:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,478,1220252400"; 
   d="scan'208";a="631227261"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>
Date: Fri, 24 Oct 2008 08:04:01 -0700
Subject: RE: Oops in ACPI with git latest
Thread-Topic: Oops in ACPI with git latest
Thread-Index: Ack1pS0a3lNAe0NTTYaP1A3sXtbl6wARIBqw
Message-ID: <4911F71203A09E4D9981D27F9D8308580AA7FA56@orsmsx503.amr.corp.intel.com>
References: <1224791103.3330.37.camel@localhost.localdomain>
 <200810232242.33480.rjw@sisk.pl>
 <1224811033.3330.54.camel@localhost.localdomain>
 <200810240847.49891.rjw@sisk.pl>
In-Reply-To: <200810240847.49891.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please post the acpidump for the machine, we want to look at this _OSC method.

Thanks.
Bob


>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
>Sent: Thursday, October 23, 2008 11:48 PM
>To: James Bottomley
>Cc: linux-acpi@vger.kernel.org; linux-kernel; Jesse Barnes; Len Brown; Lin,
>Ming M
>Subject: Re: Oops in ACPI with git latest
>
>On Friday, 24 of October 2008, James Bottomley wrote:
>> On Thu, 2008-10-23 at 22:42 +0200, Rafael J. Wysocki wrote:
>> > On Thursday, 23 of October 2008, James Bottomley wrote:
>> > > ACPI Warning (nseval-0168): Insufficient arguments - method [_OSC]
>needs 5, found 4 [20080926]
>> > > ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count
>mismatch - ASL declared 5, expected 4 [20080926]
>> > > ACPI Error (nspredef-0163): \_SB_.PCI0._OSC: Missing expected return
>value [20080926]
>> > > BUG: unable to handle kernel NULL pointer dereference at 00000000
>> > Does this patch help?
>> >
>> > ---
>> >  drivers/pci/pci-acpi.c |    3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > Index: linux-2.6/drivers/pci/pci-acpi.c
>> > ===================================================================
>> > --- linux-2.6.orig/drivers/pci/pci-acpi.c
>> > +++ linux-2.6/drivers/pci/pci-acpi.c
>> > @@ -83,6 +83,9 @@ static acpi_status acpi_run_osc(acpi_han
>> >  	if (ACPI_FAILURE(status))
>> >  		return status;
>> >
>> > +	if (!output.pointer)
>> > +		return AE_NULL_OBJECT;
>> > +
>> >  	out_obj = output.pointer;
>> >  	if (out_obj->type != ACPI_TYPE_BUFFER) {
>> >  		printk(KERN_DEBUG "Evaluate _OSC returns wrong type\n");
>>
>> Yes, that seems to fix it, thanks! ... I suppose the ASL error and
>> warnings need investigating too?
>
>Unfortunately, they seem to indicate a BIOS breakage.
>
>According to the spec, _OSC should take 4 arguments, but apparently on your
>system it wants 5.
>
>The output of acpidump may be helpful, as Lin Ming already said.
>
>Thanks,
>Rafael
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
