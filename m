Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZD2Bca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZD2Bca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbZD2BcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:32:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758438AbZD2BcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:32:17 -0400
Date: Tue, 28 Apr 2009 18:28:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       efault@gmx.de, tigran aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
Message-Id: <20090428182837.62c51f26.akpm@linux-foundation.org>
In-Reply-To: <409142.83316.qm@web32605.mail.mud.yahoo.com>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 05:45:19 -0700 (PDT) Martin Knoblauch <knobi@knobisoft.de> wrote:

> 
> 
>  OK, I just found the reason for both intel-ucode and tg3 failures. Apparently between 2.6.28 and 2.6.29 the mount of sysfs has subtely changed from:
> 
> /sys /sys sysfs rw 0 0
> 
> to:
> 
> none /sys sysfs rw,relatime 0 0

I assume that you're referring to the contents of /proc/mounts?

>  The "none" breaks the RHEL-4 provided hotplug script "firmware.agent" when it tries to parse the mount point for "/sys". As a result, the firmware loading is never properly finished and the driver(s) just timeout on the value  in /sys/class/firmware/timeout. Bingo. Simple fix in user-pace possible - cool down Martin :-)
> 
> Questions remains: was this intentional? It breaks existing userspace and should therefore be considered a regression - right? On the other hand, it will never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets backported. Any ideas?

afaik that was unintentional and was probably a mistake.

I wonder how we did that.
