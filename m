Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbYBUAZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbYBUAZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYBUAZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:25:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33306 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYBUAZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:25:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: [BUG?] APM is hidden in menuconfig
Date: Thu, 21 Feb 2008 01:23:44 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20080220120828.GD3885@ff.dom.local>
In-Reply-To: <20080220120828.GD3885@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210123.44367.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Jarek Poplawski wrote:
> Hi,
> 
> I needed APM to have poweroff on old box. So, in 2.6.24.2 menuconfig:
> 
> 1) Power management options -->
>    No APM.
> 2) [*] Power Management support
>    No APM. I can see ACPI...
> 3) I try searching with "/" + "APM"
>    APM [=n]
>    Depends on: !X86_VOYAGER && X86_32 && PM_SLEEP && !X86_VISWS
> 4) I check above: all correct except:
>    Symbol: PM_SLEEP [=n]
>    No more "depends on".
> 5) Exit menuconfig - enter grep:
> 6) Some time wasting in arch/.
> 7) less kernel/power/Kconfig:
>    config PM_SLEEP
>         bool
>         depends on SUSPEND || HIBERNATION
>         default y
>    ... 
>    config SUSPEND
>         bool "Suspend to RAM and standby"
>         depends on PM
>         depends on SUSPEND_UP_POSSIBLE || SUSPEND_SMP_POSSIBLE
>         default y
>         ---help---
>           Allow the system to enter sleep states in which main memory is
>           powered and thus its contents are preserved, such as the
>           suspend-to-RAM state (i.e. the ACPI S3 state).
> 
> 8) Back to menuconfig:
>    [*] Suspend to RAM and standby
> 
>    Bingo! APM revealed! (And not even "DEPRECATED"!)
> 
> So, has it to be so hard? It seems not - at least in good old times...

Something in APM uses some code from drivers/base/power/main.c that depends
on PM_SLEEP.

Thanks,
Rafael
