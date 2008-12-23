Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYLWBHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYLWBHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 20:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYLWBHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 20:07:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:5073 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbYLWBHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 20:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZUfgvTl7H8+9SKMpY2pcILqaliM7XRyZ20X1qEM2poJ3UwhrEHvl1AAw8JaHMUeicw
         Q43TrFYCo4VQMN/kuGHS3Bcm1t0EcchwNiYRX1kqD47n+xKTUu9lyd+OMIlfO6j40HdT
         mEGnVIIpD0mRMkM0cYdupd2SPHkZeUlIIOAto=
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a
 joystick
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-sh@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <20081222150636.8dc20d61.akpm@linux-foundation.org>
References: <1229728542.1441.6.camel@localhost.localdomain>
	 <20081222150636.8dc20d61.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 17:07:35 -0800
Message-Id: <1229994455.22856.61.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-22 at 15:06 -0800, Andrew Morton wrote:
> On Fri, 19 Dec 2008 23:15:42 +0000
> Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> 
> > Not sure what happened with earlier submissions, so here is an up-to-date
> > patch for the Dreamcast Maple controlled.
> > 
> > 
> > Add support for the SEGA Dreamcast Maple controller as a joystick
> > 
> > ...
> >
> > +static void dc_pad_callback(struct mapleq *mq)
> > +{
> > +	unsigned short buttons;
> > +	struct maple_device *mapledev = mq->dev;
> > +	struct dc_pad *pad = maple_get_drvdata(mapledev);
> > +	struct input_dev *dev = pad->dev;
> > +	unsigned char *res = mq->recvbuf;
> > +
> > +	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
> 
> hm, could that be simplified?

And as a bonus fix the obvious sparse warning:

	buttons = ~le16_to_cpup((__le16 *)(res + 8));

Cheers,

Harvey

