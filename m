Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbZGaOcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbZGaOcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZGaOcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:32:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:14676 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZGaOcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pNC6PMRVBNPpsrZV/hkOIhyoG8J8cZxfpCbIRP0dFT52c1k8XhQofKkzgw0uR5jSBi
         +QSIVLBwPBzKoqnl8Et3AlWuEWwvi0gG1CEwp8TZeMH4NFaZ2TJ+LTrNDpTO0IZjw4lI
         7HUIBBuCp9sy8XAUtjYvBnOy0AcaPsKocX0SA=
MIME-Version: 1.0
In-Reply-To: <200907222110.47701.rjw@sisk.pl>
References: <200907221701.50449.rjw@sisk.pl> <200907222110.47701.rjw@sisk.pl>
Date: Fri, 31 Jul 2009 23:32:13 +0900
Message-ID: <aec7e5c30907310732u35faa15fpab070025f596463e@mail.gmail.com>
Subject: Re: [PATCH update] PM: Introduce core framework for run-time PM of 
	I/O devices (rev. 11)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafail

[Runtime PM v11]

Thanks for your work on this. The code is getting better and better.
I've just finished posting a bunch of patches related to v11 of your
Runtime PM patch. Basically everything seems fine except a few minor
details and the code below: =)

On Thu, Jul 23, 2009 at 4:10 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Wednesday 22 July 2009, Rafael J. Wysocki wrote:
> Index: linux-2.6/drivers/base/dd.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/dd.c
> +++ linux-2.6/drivers/base/dd.c
> @@ -23,6 +23,7 @@
>  #include <linux/kthread.h>
>  #include <linux/wait.h>
>  #include <linux/async.h>
> +#include <linux/pm_runtime.h>
>
>  #include "base.h"
>  #include "power/power.h"
> @@ -202,7 +203,9 @@ int driver_probe_device(struct device_dr
>        pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
>                 drv->bus->name, __func__, dev_name(dev), drv->name);
>
> +       pm_runtime_get_noresume(dev);
>        ret = really_probe(dev, drv);
> +       pm_runtime_put_noidle(dev);
>
>        return ret;
>  }

This creates problems when drivers want to performing runtime resume
from within probe(). For more details please have a look at "[PATCH
04/04] video: Runtime PM hack for SuperH LCDC driver".

Cheers,

/ magnus
