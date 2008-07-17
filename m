Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYGQJGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYGQJGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYGQJGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:06:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:25465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbYGQJGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:06:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,202,1215414000"; 
   d="scan'208";a="316072392"
Message-ID: <487F0B85.4030202@linux.intel.com>
Date: Thu, 17 Jul 2008 11:06:13 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Andrew Paprocki <andrew@ishiboo.com>, robert.moore@intel.com,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348	acpi_tb_create_local_fadt+0x147/0x2f4()
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com> <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com> <487F2629.76E4.0078.0@novell.com>
In-Reply-To: <487F2629.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:

> So it's a firmware bug in the system you saw this on. The specification
> is clear about the width being at least 16 bits, and the warning was added
> to indicate the problem you now got: Dividing 8 by 16 yields zero for
> pm1_register_length, which results in acpi_gbl_xpm1a_enable aliasing
> the address of the respective status register. That won't work, hence
> the warning.

When there are systems around where this register is 8 bits then we have 
to handle it. Real systems beat the specification.

The question is just if the hardware is really 8 bits or if the table
is not just wrong. What does lspci say?

>> Also, I noticed that the patch changed the definition of
>> acpi_tb_init_generic_address to name the parameter byte_width instead
>> of bit_width. The declaration at the top of the file and the
>> documentation still refer to it as bit_width.
>>
>> I also added printk()s to the first call to
>> acpi_tb_init_generic_address ~ line 326 and the lengths passed to the
>> function at that point are:
>> [    0.000000] fadt_info_table[i].length=88
>> [    0.000000] fadt_info_table[i].length=89
>> [    0.000000] fadt_info_table[i].length=93
> 
> Hmm, indeed, I didn't notice the (pointless) earlier declaration, I realize
> I failed to update the function description. Bob, could you fix this in
> ACPICA without the need for me to send a patch against it (assuming
> the base patch went into ACPICA)?

No it went directly.

-Andi

