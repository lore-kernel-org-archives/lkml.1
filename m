Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbXIFJAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbXIFJAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 05:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXIFJAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 05:00:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44179 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbXIFJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:00:22 -0400
Date: Thu, 6 Sep 2007 01:56:03 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm] Hibernation: Check if ACPI is enabled during restore in the right place
Message-ID: <20070906015603.GA5097@ucw.cz>
References: <200709020021.37881.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200709020021.37881.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-09-02 00:21:37, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The following scenario leads to total confusion of the platform firmware on
> some boxes (eg. HPC nx6325):
> * Hibernate with ACPI enabled
> * Pass "acpi=off" to the boot kernel
> 
> To prevent this from happening it's necessary to check if ACPI is enabled (and
> enable it if that's not the case) _right_ _after_ control has been transfered
> from the boot kernel to the image kernel, before device_power_up() is called
> (ie. with interrupts disabled).  Enabling ACPI after calling device_power_up()
> turns out to be insufficient.
> 
> For this reason, introduce new hibernation callback ->leave() that will be
> executed before device_power_up() by the restored image kernel.  To make it
> work, it also is necessary to move swsusp_suspend() from swsusp.c to disk.c
> (it's name is changed to "create_image", which is more up to the point).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
