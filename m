Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbZABVuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbZABVuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbZABVub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:50:31 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:46608 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbZABVub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:50:31 -0500
Date: Fri, 2 Jan 2009 22:52:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [incremental-PATCH-for-Sam's-Review] ACPI: use ccflags-y instead of EXTRA_CFLAGS
Message-ID: <20090102215208.GA8494@uranus.ravnborg.org>
References: <1230720725-9376-1-git-send-email-lenb@kernel.org> <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com> <20081231133901.GB2388@uranus.ravnborg.org> <87bpusv31n.fsf@basil.nowhere.org> <20081231153441.GA3475@uranus.ravnborg.org> <alpine.LFD.2.00.0901021636050.3590@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901021636050.3590@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 04:44:02PM -0500, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/acpi/Makefile       |   11 ++---------
>  kernel/acpi/Makefile        |   11 ++---------
>  kernel/acpi/acpica/Makefile |   12 ++----------
>  3 files changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 5f4096d..a4c0582 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -2,15 +2,8 @@
>  # Makefile for the Linux ACPI Drivers
>  #
>  
> -export ACPI_CFLAGS
> -
> -ACPI_CFLAGS	:= -Os
> -
> -ifdef CONFIG_ACPI_DEBUG
> -  ACPI_CFLAGS	+= -DACPI_DEBUG_OUTPUT
> -endif
> -
> -EXTRA_CFLAGS	+= $(ACPI_CFLAGS)
> +ccflags-y			:= -Os
> +ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT

The conversion from ACPI_CFLAGS to ccflags-y is fine.
And if acpi really require -Os then this part is also OK -
I just did not get *why* acpi needs -Os

On the assumption the the -Os requirement is a hard requirement:

Acked-by: Sam Ravnborg <sam@ravnborg.org>
[For the full patch - I just quoted the first part]

	Sam
