Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869Ab0AGWwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0AGWwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711Ab0AGWwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:52:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473Ab0AGWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:52:13 -0500
Date: Thu, 7 Jan 2010 14:51:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [PATCH] acpi: Fix unused variable warning in sbs.c
Message-Id: <20100107145126.22271109.akpm@linux-foundation.org>
In-Reply-To: <b9df5fa11001030527h71b66dbcgd4ef29c04545cdaf@mail.gmail.com>
References: <b9df5fa11001030527h71b66dbcgd4ef29c04545cdaf@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jan 2010 19:27:56 +0600
Rakib Mullick <rakib.mullick@gmail.com> wrote:

>  Fix unused variabled warning.
> 
> When CONFIG_ACPI_SYSFS_POWER=n and CONFIG_ACPI_PROCFS_POWER=n, then
> we're warned by the following warning:
> 
> drivers/acpi/sbs.c: In function `acpi_battery_remove':
> drivers/acpi/sbs.c:825: warning: unused variable `battery'
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> --- linus/drivers/acpi/sbs.c	2009-12-28 12:37:29.000000000 +0600
> +++ rakib/drivers/acpi/sbs.c	2010-01-03 11:29:07.000000000 +0600
> @@ -822,7 +822,10 @@ static int acpi_battery_add(struct acpi_
> 
>  static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
>  {
> +#if defined(CONFIG_ACPI_SYSFS_POWER) || defined(CONFIG_ACPI_PROCFS_POWER)
>  	struct acpi_battery *battery = &sbs->battery[id];
> +#endif
> +
>  #ifdef CONFIG_ACPI_SYSFS_POWER
>  	if (battery->bat.dev) {
>  		if (battery->have_sysfs_alarm)

Rather an unpleasant patch to a rather unpleasant function :( Oh well,
it's better than a warning.

I wonder if it can be fixed in Kconfig.  Is there any sane use of
this code when CONFIG_ACPI_SYSFS_POWER=n && CONFIG_ACPI_PROCFS_POWER=n?
