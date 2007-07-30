Return-Path: <linux-kernel-owner+w=401wt.eu-S936260AbXG3XH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936260AbXG3XH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759422AbXG3XHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:07:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:51933 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbXG3XHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DKepz7Vr/H9WYOAVhAeFdpaftzx4+wgeHFUVlGSSFSgfj3XpyqlnZY1yAjiXouqyC+lXWzqTJc2aQFrp4vTD+8JFtPZY7xz6BRgWwT+yjuFSpd+OsOXODoiX/XZzGdkuWMxl2mgMiul8j4OKMXeM6m1zeYNhahPYtR24O9IsGSs=
Message-ID: <6bffcb0e0707301607x5484f114q9117007d131f7118@mail.gmail.com>
Date: Tue, 31 Jul 2007 01:07:03 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Doug Chapman" <doug.chapman@hp.com>
Subject: Re: regression on HP zx1 platform from ACPI autoload modules patches
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-ia64@vger.kernel.org, trenn@suse.de
In-Reply-To: <1185836238.31298.36.camel@deimos.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185836238.31298.36.camel@deimos.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 31/07/07, Doug Chapman <doug.chapman@hp.com> wrote:
> I am seeing a regression on the HP ia64 zx1 platforms when using
> a .config with CONFIG_IA64_HP_ZX1=y.  Oddly it works OK with
> CONFIG_IA64_GENERIC=y.
>
>
> During bootup it panics with:
>
> Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or DIG kernel
>
> I can provide the full console output if that is helpful.

Yes, it is very useful.

>  Also, please let
> me know if there is any other data I can provide that would be helpful.

Kernel .config file.

>
> Using git bisect I have narrowed it down to these 2 commits.  These commits
> cannot be built separately as they appear to have code that depends on each
> other.
>
>
> commit 29b71a1ca74491fab9fed09e9d835d840d042690
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Mon Jul 23 14:43:51 2007 +0200
>
>     ACPI: autoload modules - Create ACPI alias interface
>
>     Modify modpost (file2alias.c) to add acpi*:XYZ0001: alias in modules.alias
>     like:
>     grep acpi /lib/modules/2.6.22-rc4-default/modules.alias
>     alias acpi*:SNY5001:* sony_laptop
>     alias acpi*:SNY6001:* sony_laptop
>     for e.g. the sony_laptop module.
>     This module matches against all ACPI devices with a HID or CID of SNY5001
>     or SNY6001
>
>     Export an uevent and modalias sysfs file containing the string:
>     [MODALIAS=]acpi:PNP0C0C:
>     additional CIDs are concatenated at the end.
>
>     Signed-off-by: Thomas Renninger <trenn@suse.de>
>     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: Len Brown <len.brown@intel.com>
>
>
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Mon Jul 23 14:43:32 2007 +0200
>
>     ACPI: autoload modules - ACPICA modifications
>
>     Define standardized HIDs - Rename current acpi_device_id to acpica_device_id
>
>     Signed-off-by: Thomas Renninger <trenn@suse.de>
>     Signed-off-by: Len Brown <len.brown@intel.com>
>
>
>
> - Doug
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
