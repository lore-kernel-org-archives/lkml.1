Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYGQJB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYGQJB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYGQJBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:01:19 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:33124 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbYGQJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:01:18 -0400
To: "Andrew Paprocki" <andrew@ishiboo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Jan Beulich" <jbeulich@novell.com>,
       "Andi Kleen" <ak@linux.intel.com>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, robert.moore@intel.com
Subject: Re: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348 acpi_tb_create_local_fadt+0x147/0x2f4()
From: Andi Kleen <andi@firstfloor.org>
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
	<76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
Date: Thu, 17 Jul 2008 11:00:14 +0200
In-Reply-To: <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com> (Andrew Paprocki's message of "Wed, 16 Jul 2008 23:34:45 -0400")
Message-ID: <8763r4yjfl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2008 09:00:13.0900 (UTC) FILETIME=[8671E0C0:01C8E7EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andrew Paprocki" <andrew@ishiboo.com> writes:

[cc Bob More. What is your opinion?]

> This most definitely broke because of:
>
> commit 01a5bba576b9364b33f61f0cd9fa70c2cf5535e2
> Author: Jan Beulich <jbeulich@novell.com>
> Date:   Wed Jul 16 23:27:08 2008 +0200
>
>     Fix FADT parsing
>
> I added printk()s and this is what is reported here:

Thanks for the detailed analysis. 


>
>         printk(KERN_INFO
>                "xpm1a_event_block bit_width=%d pm1_register_length=%d\n",
>                acpi_gbl_FADT.xpm1a_event_block.bit_width, pm1_register_length);
>         acpi_tb_init_generic_address(&acpi_gbl_xpm1a_enable,
>                                      pm1_register_length,
>                                      (acpi_gbl_FADT.xpm1a_event_block.address +
>                                       pm1_register_length));
>
> [    0.000000] xpm1a_event_block bit_width=8 pm1_register_length=0
>
> The bit width is not % 16, so the following patch addition a few lines
> earlier fails:
>
>         WARN_ON(ACPI_MOD_16(acpi_gbl_FADT.xpm1a_event_block.bit_width));

I'll queue a revert for now until this can be resolved properly.

-Andi
