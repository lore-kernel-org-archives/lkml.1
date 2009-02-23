Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZBWHdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZBWHdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZBWHc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:32:59 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41494 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZBWHc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:32:59 -0500
Date: Mon, 23 Feb 2009 08:34:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] ide: flags query macros
Message-ID: <20090223073452.GA1764@uranus.ravnborg.org>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com> <200902171533.29135.bzolnier@gmail.com> <20090223070413.GA17783@gollum.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223070413.GA17783@gollum.tnic>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 08:04:13AM +0100, Borislav Petkov wrote:
> > Since it is not a lot of modified lines and the change is rather
> > straightforward it could as well be done in a single patch...
> 
> here's version 2:
> --
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Mon, 23 Feb 2009 07:58:23 +0100
> Subject: [PATCH] ide: flags query macros
> 
> Add drive->atapi_flags and drive->dev_flags macro wrappers
> 
> v2:
> - use static inlines for better typechecking
> - use macro indirection for convenience
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Version 2 looks much better - thanks.

diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index df3df00..3553759 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -86,7 +86,7 @@ int ide_cdrom_check_media_change_real(struct cdrom_device_info *cdi,

        if (slot_nr == CDSL_CURRENT) {
                (void) cdrom_check_status(drive, NULL);
-               retval = (drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED) ? 1 : 0;
+               retval = ide_dev_media_changed(drive) ? 1 : 0;
                drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
                return retval;
        } else {

The use of ? 1 : 0; here is redundant.

                        if (drive->media == ide_disk) {
-                               printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
+                               pr_info("%s: non-IDE drive, CHS=%d/%d/%d\n",
                                        drive->name, drive->cyl,
                                        drive->head, drive->sect);
                        } else if (drive->media == ide_cdrom) {
-                               printk(KERN_INFO "%s: ATAPI cdrom (?)\n", drive->name);
+                               pr_info("%s: ATAPI cdrom (?)\n", drive->name);
                        } else {
                                /* nuke it */
-                               printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n",
+drive->name);
+                               pr_warning("%s: Unknown device on bus refused "
+                                          "identification, ignoring.\n",
+                                          drive->name);
I did not see this addressed in the changelog?


                                drive->dev_flags &= ~IDE_DFLAG_PRESENT;

You have a nice set of inlines to facilitate testing bits,
but not for the above use?
I guess this was not worth the abstraction for now.


	Sam
