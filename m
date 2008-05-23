Return-Path: <linux-kernel-owner+w=401wt.eu-S934663AbYEWHFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbYEWHFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYEWHFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:05:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3191 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757814AbYEWHFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:05:05 -0400
Date: Fri, 23 May 2008 09:04:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Anas Nashif <nashif@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20080523070452.GA8193@ucw.cz>
References: <4832174A.20905@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4832174A.20905@linux.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The Intel Management Engine Interface (aka HECI: Host Embedded
> Controller Interface ) enables communication between the host OS and
> the Management Engine firmware. MEI is bi-directional, and either the
> host or Intel AMT firmware can initiate transactions.

* uses homebrewn DBG(), could it use dprintk() or something.

* should probably come with Documentation/ file

* defines like H_IE are a bit too terse.

> +extern const struct guid heci_pthi_guid;
> +extern const struct guid heci_wd_guid;
> +extern const __u8 start_wd_params[];
> +extern const __u8 stop_wd_params[];
> +extern const __u8 heci_wd_state_independence_msg[2][4];

Externs should go to header file.

No need to use __u8 in kernel.

Variables need good names. pthi_guid is not one of them.

> +/**
> + * memory IO BAR definition
> + */
> +#define     BAR_0                        0
> +#define     BAR_1                        1
> +#define     BAR_5                        5

Heh. And comments should tell us what it is.

Hmm, is this kerneldoc? Does not seem like one. So don't use /**. Fix
this all over the patch.

> +/**
> + * heci_fe_same_id - tell if file extensions have same id
> + * @fe1 -file extension
> + * @fe2 -file extension
> + *
> + * @return :
> + *  1 - if ids are the same,
> + *  0 - if differ.
> + */

File extensions?!

> +static inline int heci_fe_same_id(struct heci_file_private *fe1,
> +				  struct heci_file_private *fe2)
> +{
> +	if ((fe1->host_client_id == fe2->host_client_id)
> +	    && (fe1->me_client_id == fe2->me_client_id)) {
> +		return 1;
> +	} else {
> +		return 0;
> +	}
> +}

This can be written without the if.


> +#endif /* _HECI_H_ */
> diff --git a/drivers/char/heci/heci_data_structures.h
> b/drivers/char/heci/heci_data_structures.h
> new file mode 100644
> index 0000000..ac0f488
> --- /dev/null
> +++ b/drivers/char/heci/heci_data_structures.h
> @@ -0,0 +1,507 @@
> +/*
> + * Part of Intel(R) Manageability Engine Interface Linux driver
> + *
> + * Copyright (c) 2003 - 2008 Intel Corp.
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions, and the following disclaimer,
> + *    without modification.
> + * 2. Redistributions in binary form must reproduce at minimum a disclaimer
> + *    substantially similar to the "NO WARRANTY" disclaimer below
> + *    ("Disclaimer") and any redistribution must be conditioned upon
> + *    including a substantially similar Disclaimer requirement for further
> + *    binary redistribution.
> + * 3. Neither the names of the above-listed copyright holders nor the names
> + *    of any contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.

What kind of ninja mutant license is this?

> +/**
> + * Number of queue lists used by this driver
> + */
> +#define NUMBER_OF_LISTS        7

Yes, how very useful name. Plus, it is too generic and likely to
conflict with someone else.

> +#define IAMTHIF_MTU 4160

And this one seems encrypted.

> +
> +/**
> + * HECI HW Section
> + */
> +
> +/* HECI addresses and defines */
> +#define H_CB_WW    0
> +#define H_CSR      4
> +#define ME_CB_RW   8
> +#define ME_CSR_HA  0xC

As do this and registers below.

> +/**
> + * time to wait event
> + */
> +#define HECI_INTEROP_TIMEOUT    (HZ * 7)

Could we get _useful_ comments?

> +/* File state */
> +enum file_state {
> +	HECI_FILE_INITIALIZING = 0,
> +	HECI_FILE_CONNECTING,
> +	HECI_FILE_CONNECTED,
> +	HECI_FILE_DISCONNECTING,
> +	HECI_FILE_DISCONNECTED
> +};

What kind of files is this handling? Surely this is not a filesystem?


> +/* HECI states */
> +enum heci_states{

Missing space, and evil comment.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
