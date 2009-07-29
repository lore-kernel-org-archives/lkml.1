Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZG2BEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZG2BEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZG2BEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:04:07 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:43149 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbZG2BEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:04:06 -0400
X-Greylist: delayed 790 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 21:04:05 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907290050.n6T0oL0o024740@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH 6/12] drivers/platform/x86: Correct redundant test
To: pmarques@grupopie.com (Paulo Marques)
Date: Wed, 29 Jul 2009 10:20:21 +0930 (CST)
Cc: julia@diku.dk (Julia Lawall), jwoithe@physics.adelaide.edu.au,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <4A6F3AEA.7090102@grupopie.com> from "Paulo Marques" at Jul 28, 2009 06:52:42 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys

> Julia Lawall wrote:
> > [...]
> > ---
> >  drivers/platform/x86/fujitsu-laptop.c          |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> > index 218b9a1..5306901 100644
> > --- a/drivers/platform/x86/fujitsu-laptop.c
> > +++ b/drivers/platform/x86/fujitsu-laptop.c
> > @@ -745,9 +745,6 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
> >  
> >  	fujitsu = acpi_driver_data(device);
> >  
> > -	if (!device || !acpi_driver_data(device))
> > -		return -EINVAL;
> > -
> 
> Shouldn't this still do a:
> 
>    if (!fujitsu)
>      return -EINVAL;
> 
> to avoid dereferencing a NULL pointer below?

Hmm, yes it should.  Well spotted.  And I'm not certain how the duplicate
test on "device" got in there in the first place.  I suspect it came about
due to some structural changes made a few versions ago and I failed to
notice that the second check became redundant.

So, combining this with the above patch we should instead do

Signed-off-by: jwoithe@physics.adelaide.edu.au <Jonathan Woithe>

--- a/drivers/platform/x86/fujitsu-laptop.c	2009-06-12 19:51:45.333234000 +0930
+++ b/drivers/platform/x86/fujitsu-laptop.c	2009-07-29 10:14:30.610249941 +0930
@@ -745,7 +745,7 @@ static int acpi_fujitsu_remove(struct ac
 
 	fujitsu = acpi_driver_data(device);
 
-	if (!device || !acpi_driver_data(device))
+	if (!fujitsu)
 		return -EINVAL;
 
 	fujitsu->acpi_handle = NULL;

Regards
  jonathan
