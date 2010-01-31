Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767Ab0AaRJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0AaRJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437Ab0AaRJ3
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:09:29 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57784 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0AaRJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:09:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NwsAMJTWfkWFOlst3+FBGcMd8qzZsU7iabYMKId1Q3awwYOPejCmt+IZSwNWvJr9jp
         A+7s0onouabyzlnwid+z046uLCBFDhjNYFYml64SYt7MBvA0zfvQgVNiXrW0GONqDAMr
         TIf6FwXy1BqaT3FgdcjUYIGQhh6eo0lMt4C/I=
Subject: Re: [RFC][RFT][PATCH] ACPI: Protection from suspending in the
 middle  of EC transaction
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <9b2b86521001310611m339862afw73410dc7eb5692c8@mail.gmail.com>
References: <201001310029.48717.rjw@sisk.pl>
	 <9b2b86521001310611m339862afw73410dc7eb5692c8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 19:09:20 +0200
Message-ID: <1264957760.7264.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-31 at 14:11 +0000, Alan Jenkins wrote: 
> On 1/30/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > While Maxim is testing if the patch below helps with
> > http://bugzilla.kernel.org/show_bug.cgi?id=14668
> > I think it's necessary anyway.
> >
> > The problem is that currently there's nothing to prevent us from suspending
> > in
> > the middle of an EC transaction in progress, at least as far as I can see.
> > As a result, we can suspend with the ACPI global lock held or something like
> > this, which leads to problems especially for hibernation (if the resume
> > kernel
> > passes control to the image kernel in the middle of an EC transaction,
> > things
> > aren't nice).  For this reason I think we should wait until there are no EC
> > transactions in progress before we suspend and we should prevent any new
> > EC transactions from starting after that point.  The patch below does that.

Unfortunately, this patch even causes regressions on my notebook (it
survive 63 hibernate cycles), but now I battery driver reports 'battery
absent', backlight driver reports 0 brightness, but reload helped.

I think that not only _PTS ans _WAK are problematic. What about other
ACPI drivers that start accessing the EC before it is resumed?
I think that these cause the problems I observe.

Still, at least it does resume.

Best regards,
Maxim Levitsky


