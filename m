Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZKBVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZKBVfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbZKBVfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:35:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:48417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbZKBVfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:35:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,670,1249282800"; 
   d="scan'208";a="206679065"
From: "Moore, Robert" <robert.moore@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thiago Farina <tfransosi@gmail.com>
CC: "trivial@kernel.org" <trivial@kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       "jkosina@suze.cz" <jkosina@suze.cz>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 2 Nov 2009 13:35:33 -0800
Subject: RE: [PATCH] trivial: remove ACPI_ARRAY_LENGTH macro.
Thread-Topic: [PATCH] trivial: remove ACPI_ARRAY_LENGTH macro.
Thread-Index: Acpb3IX9GV9zEkeWTqmmzxB2uPSXxQAJ8kOg
Message-ID: <4911F71203A09E4D9981D27F9D8308583B6FCBE0@orsmsx503.amr.corp.intel.com>
References: <1257114972-16039-1-git-send-email-tfransosi@gmail.com>
 <200911020949.58412.bjorn.helgaas@hp.com>
In-Reply-To: <200911020949.58412.bjorn.helgaas@hp.com>
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

I seem to remember that Len Brown had some text like this.


>-----Original Message-----
>From: Bjorn Helgaas [mailto:bjorn.helgaas@hp.com]
>Sent: Monday, November 02, 2009 8:50 AM
>To: Thiago Farina
>Cc: trivial@kernel.org; lenb@kernel.org; Lin, Ming M; Moore, Robert;
>jkosina@suze.cz; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] trivial: remove ACPI_ARRAY_LENGTH macro.
>
>On Sunday 01 November 2009 03:36:12 pm Thiago Farina wrote:
>> Since the kernel already has a macro (ARRAY_SIZE) that does the same
>thing,
>> just use it instead of defining another macro for the same propose.
>
>This changes the ACPICA, which is used in several OSes besides Linux.
>The CA is designed to have a small, controlled interface to the host OS.
>This patch would expand that interface, which would work fine on Linux,
>but would cause problems on other OSes that don't provide ARRAY_SIZE().
>
>It'd be nice to have a little text in Documentation/acpi/ that covered
>issues like this.  It could also talk about the special licensing
>requirements for ACPICA changes.  And MAINTAINERS could mention it for
>the path prefix "drivers/acpi/acpica/".
>
>Bjorn
>
>>  drivers/acpi/acpica/hwvalid.c |    2 +-
>>  drivers/acpi/acpica/uteval.c  |    4 ++--
>>  include/acpi/actypes.h        |    4 ----
>>  3 files changed, 3 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/acpi/acpica/hwvalid.c
>b/drivers/acpi/acpica/hwvalid.c
>> index ec33f27..ca2eb02 100644
>> --- a/drivers/acpi/acpica/hwvalid.c
>> +++ b/drivers/acpi/acpica/hwvalid.c
>> @@ -103,7 +103,7 @@ static const struct acpi_port_info
>acpi_protected_ports[] = {
>>  	{"PCI", 0x0CF8, 0x0CFF, ACPI_OSI_WIN_XP}
>>  };
>>
>> -#define ACPI_PORT_INFO_ENTRIES  ACPI_ARRAY_LENGTH (acpi_protected_ports)
>> +#define ACPI_PORT_INFO_ENTRIES  ARRAY_SIZE(acpi_protected_ports)
>>
>>
>/**************************************************************************
>****
>>   *
>> diff --git a/drivers/acpi/acpica/uteval.c b/drivers/acpi/acpica/uteval.c
>> index 5d54e36..54efbaa 100644
>> --- a/drivers/acpi/acpica/uteval.c
>> +++ b/drivers/acpi/acpica/uteval.c
>> @@ -126,7 +126,7 @@ acpi_status acpi_ut_osi_implementation(struct
>acpi_walk_state *walk_state)
>>
>>  	/* Compare input string to static table of supported interfaces */
>>
>> -	for (i = 0; i < ACPI_ARRAY_LENGTH(acpi_interfaces_supported); i++) {
>> +	for (i = 0; i < ARRAY_SIZE(acpi_interfaces_supported); i++) {
>>  		if (!ACPI_STRCMP(string_desc->string.pointer,
>>  				 acpi_interfaces_supported[i].name)) {
>>  			/*
>> @@ -186,7 +186,7 @@ acpi_status acpi_osi_invalidate(char *interface)
>>  {
>>  	int i;
>>
>> -	for (i = 0; i < ACPI_ARRAY_LENGTH(acpi_interfaces_supported); i++) {
>> +	for (i = 0; i < ARRAY_SIZE(acpi_interfaces_supported); i++) {
>>  		if (!ACPI_STRCMP(interface, acpi_interfaces_supported[i].name))
>{
>>  			*acpi_interfaces_supported[i].name = '\0';
>>  			return AE_OK;
>> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
>> index 153f12d..641d746 100644
>> --- a/include/acpi/actypes.h
>> +++ b/include/acpi/actypes.h
>> @@ -441,10 +441,6 @@ typedef unsigned long long acpi_integer;
>>  #define ACPI_MIN(a,b)                   (((a)<(b))?(a):(b))
>>  #define ACPI_MAX(a,b)                   (((a)>(b))?(a):(b))
>>
>> -/* Size calculation */
>> -
>> -#define ACPI_ARRAY_LENGTH(x)            (sizeof(x) / sizeof((x)[0]))
>> -
>>  /* Pointer manipulation */
>>
>>  #define ACPI_CAST_PTR(t, p)             ((t *) (acpi_uintptr_t) (p))
>

