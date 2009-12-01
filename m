Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZLATJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZLATJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 14:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZLATJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 14:09:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54788 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLATJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 14:09:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Lpb5sejP05KDx7fDH0sLVBcnpNrDMBY065qkWk4WooduZwqwip45K+NySyT+vyN8iy
         FftuHUBtA+rw9PSo0/uQ7ep7wlMtJinIIJ3gEcKkhNxvlJrO9V/33SEP1r8yqQ2T+gOC
         9eJBVq/R+YnKR6Jp8j27qIU+cunlV6YrksRZc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] drivers/block/floppy.c: stylistic cleanups
Date: Tue, 1 Dec 2009 20:09:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <1259001504.16503.79.camel@Joe-Laptop.home> <1259640820.13592.37.camel@Joe-Laptop.home> <20091201084550.586a728b@nehalam>
In-Reply-To: <20091201084550.586a728b@nehalam>
MIME-Version: 1.0
Message-Id: <200912012009.00812.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 December 2009 05:45:50 pm Stephen Hemminger wrote:
> On Mon, 30 Nov 2009 20:13:40 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > On Mon, 2009-11-30 at 09:28 -0800, Stephen Hemminger wrote:
> > > Rather than playing with the dangling operator format which seems to be a coding
> > > style that only David cares about. Why not go through and fix the really ugly old
> > > drivers that need it. For a good horror experience, go look at the floppy driver.
> > 
> > Just for you Stephen, here's a cleaned up version.
> > Now to see if it gets applied, which I rather doubt.
> > 
> > Changes:
> > 
> > Removed macro definitions and uses of
> > 	IN, OUT, LAST_OUT, CLEARSTRUCT, and CHECK_RESET
> > Used C99 initializers
> > Removed assigns from if statements
> > Converted printks without KERN_ levels to pr_info and pr_cont
> > Removed unnecessary braces
> > Used print_hex_dump
> > Moved leading logical tests to end of previous line
> > Surrounded still ugly CALL and ECALL macro with do {} while (0)
> > 
> > Checkpatch complaints before:
> > total: 393 errors, 132 warnings, 4647 lines checked
> > 
> > after:
> > total: 1 errors, 11 warnings, 5352 lines checked
> > 
> > Compile tested only, x86 allyesconfig
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> I have a fix (to get rid of Buffer I/O error when testing for drive present),
> so I'll put your cleanup in first.

Could you please tell us how are we going to back-port your fix to
-stable after such amount of changes:

  drivers/block/floppy.c | 1853 +++++++++++++++++++++++++++++++++---------------
  1 files changed, 1279 insertions(+), 574 deletions(-)

gets applied first?

--
Bartlomiej Zolnierkiewicz
