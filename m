Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZLCJZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZLCJZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZLCJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:25:39 -0500
Received: from bamako.nerim.net ([62.4.17.28]:58239 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZLCJZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:25:38 -0500
Date: Thu, 3 Dec 2009 10:25:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] DMI: allow omitting ident strings in DMI tables
Message-ID: <20091203102542.6df59efc@hyperion.delvare>
In-Reply-To: <20091203085629.GN9121@core.coreip.homeip.net>
References: <20091203031240.GB9121@core.coreip.homeip.net>
	<20091203093009.059197a6@hyperion.delvare>
	<20091203085629.GN9121@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 00:56:30 -0800, Dmitry Torokhov wrote:
> On Thu, Dec 03, 2009 at 09:30:09AM +0100, Jean Delvare wrote:
> > On Wed, 2 Dec 2009 19:12:40 -0800, Dmitry Torokhov wrote:
> > > diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> > > index 938100f..9116aa7 100644
> > > --- a/drivers/firmware/dmi_scan.c
> > > +++ b/drivers/firmware/dmi_scan.c
> > > @@ -440,6 +440,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
> > >  }
> > >  
> > >  /**
> > > + *	dmi_is_end_of_table - check for end-of-table marker
> > > + *	@dmi: pointer to the dmi_system_id structure to check
> > > + */
> > > +static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
> > > +{
> > > +	return dmi->ident == NULL && dmi->matches[0].slot == DMI_NONE;
> > 
> > If you really want to allow for dmi->ident == NULL, then I guess you can
> > _only_ check for dmi->matches[0].slot == DMI_NONE. I can't think of any
> > legitimate use of DMI_NONE for a used slot.
> 
> Current behavior is that entry with ident and empty match table matches
> everything. If we only check on the first slot then it will not match. I
> wanted to preserve the current behavior.

Is there a use case for this behavior? If not then I don't see the
point of preserving it.

-- 
Jean Delvare
