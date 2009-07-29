Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZG2CnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZG2CnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZG2CnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:43:09 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:54586 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756115AbZG2CnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:43:07 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907290242.n6T2gbP1025488@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH 6/12] drivers/platform/x86: Correct redundant test
To: julia@diku.dk (Julia Lawall)
Date: Wed, 29 Jul 2009 12:12:37 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       pmarques@grupopie.com (Paulo Marques), linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0907290422121.16543@ask.diku.dk> from "Julia Lawall" at Jul 29, 2009 04:22:51 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia

> > > Julia Lawall wrote:
> > > > [...]
> > > > ---
> > > >  drivers/platform/x86/fujitsu-laptop.c          |    3 ---
> > > >  1 files changed, 0 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> > > > index 218b9a1..5306901 100644
> > > > --- a/drivers/platform/x86/fujitsu-laptop.c
> > > > +++ b/drivers/platform/x86/fujitsu-laptop.c
> > > > @@ -745,9 +745,6 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
> > > >  
> > > >  	fujitsu = acpi_driver_data(device);
> > > >  
> > > > -	if (!device || !acpi_driver_data(device))
> > > > -		return -EINVAL;
> > > > -
> > > 
> > > Shouldn't this still do a:
> > > 
> > >    if (!fujitsu)
> > >      return -EINVAL;
> > > 
> > > to avoid dereferencing a NULL pointer below?
> > 
> > Hmm, yes it should.  Well spotted.  And I'm not certain how the duplicate
> > test on "device" got in there in the first place.  I suspect it came about
> > due to some structural changes made a few versions ago and I failed to
> > notice that the second check became redundant.
> 
> If you are going to check fujitsu afterwards, then I think there is no 
> need to test the result of acpi_driver_data before.

Yes, of course.  I'll wake up soon, promise!

So we're left with this.

Signed-off-by: jwoithe@physics.adelaide.edu.au <Jonathan Woithe>

--- a/drivers/platform/x86/fujitsu-laptop.c	2009-06-12 19:51:45.333234000 +0930
+++ b/drivers/platform/x86/fujitsu-laptop.c	2009-07-29 12:10:11.504901871 +0930
@@ -740,12 +740,12 @@ static int acpi_fujitsu_remove(struct ac
 {
        struct fujitsu_t *fujitsu = NULL;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device)
 		return -EINVAL;
 
 	fujitsu = acpi_driver_data(device);
 
-	if (!device || !acpi_driver_data(device))
+	if (!fujitsu)
 		return -EINVAL;
 
	fujitsu->acpi_handle = NULL;


Regards
  jonathan
