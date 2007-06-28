Return-Path: <linux-kernel-owner+w=401wt.eu-S1764814AbXF1UjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764814AbXF1UjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbXF1Ui5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:38:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413AbXF1Ui5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:38:57 -0400
Date: Thu, 28 Jun 2007 13:37:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: Introduce set_target method in pm_ops
Message-Id: <20070628133724.31cc9ace.akpm@linux-foundation.org>
In-Reply-To: <200706272356.29475.rjw@sisk.pl>
References: <200706272356.29475.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 23:56:28 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> [Please consider as 2.6.22 material.]

The patch tries to patch the function suspend_devices_and_enter() which is
introduced by pm-reduce-code-duplication-between-mainc-and-userc.patch,
which won't be in 2.6.22.

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Commit 52ade9b3b97fd3bea42842a056fe0786c28d0555 changed the suspend code
> ordering to execute pm_ops->prepare() after the device model per-device
> .suspend() calls in order to fix some ACPI-related issues.  Unfortunately, it
> broke the at91 platform which assumed that pm_ops->prepare() would be called
> before suspending devices.
> 
> at91 used pm_ops->prepare() to get notified of the target system sleep state, so
> that it could use this information while suspending devices.  However, with the
> current suspend code ordering pm_ops->prepare() is called too late for this
> purpose.  Thus, at91 needs an additional method in 'struct pm_ops' that will
> be used for notifying the platform of the target system sleep state.  Moreover,
> in the future such a method will also be needed by ACPI.
> 
> This patch adds the .set_target() method to 'struct pm_ops' and makes the
> suspend code call it, if implemented, before executing the device model
> per-device .suspend() calls.  It also modifies the at91 code to implement
> pm_ops->set_target() instead of pm_ops->prepare().
> 

