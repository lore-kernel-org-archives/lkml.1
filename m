Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbXIZI6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbXIZI6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXIZI6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:58:42 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:37979 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbXIZI6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:58:41 -0400
In-Reply-To: <200709251639.06414.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] ibmebus: Add device creation and bus probing based on of_device
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF5734B9D1.E734A7F1-ONC1257362.002FF979-C1257362.0031501B@de.ibm.com>
Date: Wed, 26 Sep 2007 10:58:37 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 26/09/2007 10:58:39,
	Serialize complete at 26/09/2007 10:58:39
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/* These devices will automatically be added to the bus during init 
*/
> > +static struct of_device_id builtin_matches[] = {
> > +   { .name = "lhca" },
> > +   { .compatible = "IBM,lhca" },
> > +   { .name = "lhea" },
> > +   { .compatible = "IBM,lhea" },
> > +   {},
> > +};
> > +
> 
> Hmm, do you have devices that only have the matching name property
> but not the compatible property? If not, I'd suggest only looking
> for compatible, so you have less chance of false positives.

If a device that's not an lhca is called "lhca", that's its own fault, i 
guess ;) But i concur that looking for the compatible property will 
probably suffice.
 
> > +static int ibmebus_create_device(struct device_node *dn)
> > [...]
> 
> nice!

Thanks.
 
> > -      rc = IS_ERR(dev) ? PTR_ERR(dev) : count;
> > +      rc = rc ? rc : count;
> 
> the last line looks a bit silly. Maybe instead do
> 
>       rc = ibmebus_create_device(dn);
>         of_node_put(dn);
>    }
> 
>    kfree(path);
>    if (rc)
>       return rc;
>    return count;
> }

More code lines? ;) But yes, that looks more like "standard kernel 
pattern" - I'll change that.

Joachim
