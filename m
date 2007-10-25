Return-Path: <linux-kernel-owner+w=401wt.eu-S1762251AbXJYPyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762251AbXJYPyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760428AbXJYPyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:54:06 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:4109 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760390AbXJYPyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:54:04 -0400
X-Greylist: delayed 7529 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 11:54:04 EDT
Date: Thu, 25 Oct 2007 17:54:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>, Andrew Morton <akpm@osdl.org>
Cc: Thomas Renninger <trenn@suse.de>, linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with
 ACPI Operation Region resources
Message-ID: <20071025175401.6a5ac8cc@hyperion.delvare>
In-Reply-To: <20071025120438.GJ30546@jupiter.solarsys.private>
References: <1193236319.4590.225.camel@queen.suse.de>
	<20071025120438.GJ30546@jupiter.solarsys.private>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, 25 Oct 2007 08:04:38 -0400, Mark M. Hoffman wrote:
> Hi Thomas:
> 
> I recently told someone in private that ACPI vs. hwmon conflicts are the
> biggest open problems for the hwmon subsystem.  Thank you (and Jean) for
> doing this.
> 
> * Thomas Renninger <trenn@suse.de> [2007-10-24 16:31:59 +0200]:
> > Hi,
> > 
> > it seems Len's test tree and Linus tree diverged a bit, at least with
> > this patch set things do not apply cleanly.
> > 
> > Therefore I post these for discussion whether and in which kernel tree
> > they should end up before doing work for nothing.
> > If they are still a candidate for 2.6.24 (rather unintrusive), pls tell
> > me whether and when I should base them against Len's test/release branch
> > or whatever other tree.
> > If not, it would be great if they can be included into the -mm tree and
> > I can rebase them against this one.
> 
> Andrew has already picked this series; I vote for extended time in -mm.  On the
> hwmon side, there is almost guaranteed to be fallout from this that may take
> time to resolve.

Of course, otherwise we wouldn't have done it ;)

> > A boot parameter acpi_enforce_resources=strict/lax/no is provided, which
> > is default set to lax:
> >   - strict: let conflicting drivers fail to load with an error message
> >   - lax:    let conflicting driver work normal with a warning message
> >   - no:     no functional change at all
> > Depending on the feedback and the kind of interferences we see, this
> > should be set to strict at later time.
> 
> As long as it's in -mm, you may as well default to =strict right away.  This
> will force people to report.  Open the floodgates; I hope I don't drown.

Good point. Here's a patch. Andrew, can you please apply this on top of
the other patches? Thanks.

Subject: Enforce ACPI resource conflict checks

In -mm, enforce ACPI resource conflict checks, so that users will report
to us.

This patch is NOT meant to go to Linus at this point.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc1.orig/drivers/acpi/osl.c	2007-10-24 10:01:16.000000000 +0200
+++ linux-2.6.24-rc1/drivers/acpi/osl.c	2007-10-25 17:13:58.000000000 +0200
@@ -1076,7 +1076,7 @@ __setup("acpi_wake_gpes_always_on", acpi
 #define ENFORCE_RESOURCES_LAX    1
 #define ENFORCE_RESOURCES_NO     0
 
-static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
 
 static int __init acpi_enforce_resources_setup(char *str)
 {


-- 
Jean Delvare
