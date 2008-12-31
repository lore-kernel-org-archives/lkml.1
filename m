Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYLaNhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYLaNhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYLaNhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:37:24 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:39833 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbYLaNhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:37:23 -0500
Date: Wed, 31 Dec 2008 14:39:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 01/15] ACPI: create kernel/acpi/
Message-ID: <20081231133901.GB2388@uranus.ravnborg.org>
References: <1230720725-9376-1-git-send-email-lenb@kernel.org> <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/acpi/Makefile b/kernel/acpi/Makefile
> new file mode 100644
> index 0000000..92a1f94
> --- /dev/null
> +++ b/kernel/acpi/Makefile
> @@ -0,0 +1,26 @@
> +#
> +# Makefile for the Linux/ACPI
> +#
> +
> +export ACPI_CFLAGS
> +

Why is ACPI_CFLAGS exported?
> +ACPI_CFLAGS	:= -Os
> +
> +ifdef CONFIG_ACPI_DEBUG
> +  ACPI_CFLAGS	+= -DACPI_DEBUG_OUTPUT
> +endif
> +
> +EXTRA_CFLAGS	+= $(ACPI_CFLAGS)
A better way:

ccflags-$(CONFIG_ACPI_DEBUG) := -DACPI_DEBUG_OUTPUT

Note: EXTRA_CFLAGS is deprecated in favour of ccflags-y.

> +export ACPI_CFLAGS
> +
> +ACPI_CFLAGS	:= -Os
> +
> +ifdef CONFIG_ACPI_DEBUG
> +  ACPI_CFLAGS	+= -DACPI_DEBUG_OUTPUT
> +endif
> +
> +EXTRA_CFLAGS	+= $(ACPI_CFLAGS)

Same construct - see above.

	Sam
