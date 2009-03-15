Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbZCOTIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbZCOTIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZCOTIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:08:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:27406 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbZCOTIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:08:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,367,1233561600"; 
   d="scan'208";a="120470213"
From: "Moore, Robert" <robert.moore@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>, Len Brown <lenb@kernel.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "rjw@sisk.pl" <rjw@sisk.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Date: Sun, 15 Mar 2009 12:08:10 -0700
Subject: RE: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by
 zero
Thread-Topic: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by
 zero
Thread-Index: AcmlW2jiqfERlKzbQLOxVVIb4oxxpwAReyDw
Message-ID: <4911F71203A09E4D9981D27F9D83085814F8A39D@orsmsx503.amr.corp.intel.com>
References: <49BCDCAA.8040309@gmail.com>
In-Reply-To: <49BCDCAA.8040309@gmail.com>
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

Can you please send or post the acpidump for the machine? Thanks.

>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Jiri Slaby
>Sent: Sunday, March 15, 2009 3:47 AM
>To: Len Brown
>Cc: linux-acpi@vger.kernel.org; rjw@sisk.pl; Linux kernel mailing list;
>torvalds@linux-foundation.org
>Subject: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by zero
>
>Hi,
>
>sometimes, when booting up/resuming from disk, I get an oops[1].
>
>obj_desc->common_field.access_bit_width is zero, but even after the
>loop. Division before the loop is apparently OK.
>
>This is the case:
>         /* Mask off any extra bits in the last datum */
>
>         buffer_tail_bits = obj_desc->common_field.bit_length %
>             obj_desc->common_field.access_bit_width;
>
>.L39:
>         xorl    %edx, %edx      #
>         movzbl  37(%rbx), %esi  #
><variable>.common_field.access_bit_width,
><variable>.common_field.access_bit_width
>         movl    24(%rbx), %eax  # <variable>.common_field.bit_length,
><variable>.common_field.bit_length
>--------------- here:
>         divl    %esi    # <variable>.common_field.access_bit_width
>         movl    %edx, %ecx      #, tmp121
>         testl   %edx, %edx      # tmp121
>         je      .L41    #,
>
>[1] http://www.fi.muni.cz/~xslaby/sklad/panics/acpi_oops.png
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
