Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417AbZG1UMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbZG1UMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZG1UMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:12:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52400 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZG1UMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:12:18 -0400
Date: Tue, 28 Jul 2009 22:11:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Paulo Marques <pmarques@grupopie.com>
Cc: jwoithe@physics.adelaide.edu.au, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/12] drivers/platform/x86: Correct redundant test
In-Reply-To: <4A6F3AEA.7090102@grupopie.com>
Message-ID: <Pine.LNX.4.64.0907282207590.2267@ask.diku.dk>
References: <Pine.LNX.4.64.0907271813490.2682@ask.diku.dk> <4A6F3AEA.7090102@grupopie.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, Paulo Marques wrote:

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

acpi_driver_data just accesses a field of its argument.  Is there a worry 
that from one call to the next it could have a different value?

Perhaps it would be better to first test !device, then initialize fujitsu, 
and then test the result of fujitsu?  The acpi_driver_data, which might 
someday do something more complicated, would only be called once.

julia
