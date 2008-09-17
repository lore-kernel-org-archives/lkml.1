Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYIQS5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYIQS5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYIQS5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:57:17 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:35872 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbYIQS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W33Dt/NChV7dbZkWZpG+OowPmZQuL0p2p/QU/I9schCVgnQxwMSJ6emA4vYZLATHkF
         3Z5mVWyAfoGSDvc8gMI2t4OI5tHScykraTvM6UwedBFs8TEbEiJHT8ohtXV1k2m/JEcE
         wrXOim/5FUAo6RgnTCvyOZGj1JRO0ZOlFa3rg=
Date: Wed, 17 Sep 2008 20:56:38 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] apci: dump slit with printk(KERN_ACPI...)
Message-ID: <20080917185632.GC5524@joi>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <1221640067-24389-6-git-send-email-yhlu.kernel@gmail.com> <20080917181856.GA5524@joi> <86802c440809171128y17cbb6b6mca9c5beae0b2dcd4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809171128y17cbb6b6mca9c5beae0b2dcd4@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 11:28:48AM -0700, Yinghai Lu wrote:
> On Wed, Sep 17, 2008 at 11:19 AM, Marcin Slusarz
> <marcin.slusarz@gmail.com> wrote:
> > On Wed, Sep 17, 2008 at 01:27:46AM -0700, Yinghai Lu wrote:
> >> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >>
> >> ---
> >>  drivers/acpi/numa.c |    9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>
> >> Index: linux-2.6/drivers/acpi/numa.c
> >> ===================================================================
> >> --- linux-2.6.orig/drivers/acpi/numa.c
> >> +++ linux-2.6/drivers/acpi/numa.c
> >> @@ -150,6 +150,15 @@ static __init int slit_valid(struct acpi
> >>  {
> >>       int i, j;
> >>       int d = slit->locality_count;
> >> +     printk(KERN_DEBUG KERN_ACPI "ACPI: SLIT: nodes = %d\n", d);
> >> +     for (i = 0; i < d; i++) {
> >> +             printk(KERN_DEBUG KERN_ACPI "  ");
> >> +             for (j = 0; j < d; j++)  {
> >> +                     u8 val = slit->entry[d*i + j];
> >> +                     printk(KERN_CONT KERN_ACPI " %d", val);
> >> +             }
> >> +             printk(KERN_CONT KERN_ACPI "\n");
> >> +     }
> >
> > It will produce something like this:
> > <7><acpi>ACPI: SLIT: nodes = %d\n
> > <7><acpi>  <acpi> %d<acpi> %d<acpi> %d<acpi> %d<acpi>\n
> >
> > bit wrong... ;)
> 
> did you check v6...?

No, I didn't test it.
Sorry for the noise.

Marcin
