Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXLSSOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXLSSOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXLSSOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:14:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:49169 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXLSSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:14:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uswY90g0pdB64bDhbFIF/LZ8TCtSQP5tLwfpBRjiYH+wyQ9yv89WcMD7Wo1jHM73qGFEYLFDkWBTSOsD7E7lbW3d0C/xpi+GI8oc6JjOOoYe70Sumd+P+RqITnkNVcUZKTuS9XE65FHu38pqzmYcDOrGg4Uvm3UrkFwqxuD3EAA=
Date: Wed, 19 Dec 2007 19:15:56 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/storage/initializers.c: fix signedness difference
Message-ID: <20071219181552.GA18104@joi>
References: <20071209212337.GA9440@joi> <20071218153642.cf8c6a0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071218153642.cf8c6a0b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 03:36:42PM -0800, Andrew Morton wrote:
> On Sun, 9 Dec 2007 22:23:42 +0100
> Marcin __lusarz <marcin.slusarz@gmail.com> wrote:
>
> > usb/storage/initializers.c: fix signedness difference
> >
> > Signed-off-by: Marcin __lusarz <marcin.slusarz@gmail.com>
> > ---
> >  drivers/usb/storage/initializers.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
> > index ee5b42a..187dd1e 100644
> > --- a/drivers/usb/storage/initializers.c
> > +++ b/drivers/usb/storage/initializers.c
> > @@ -66,7 +66,8 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
> >  {
> >  	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap*) us->iobuf;
> >  	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap*) us->iobuf;
> > -	int res, partial;
> > +	int res;
> > +	unsigned int partial;
> >  	static char init_string[] = "\xec\x0a\x06\x00$PCCHIPS";
> >
> >  	US_DEBUGP("Sending UCR-61S2B initialization packet...\n");
>
> Often we just wouldn't bother about something this minor.
>
> But I see later on that we pass the address of `partial' into some other
> function and I am guessing that this produces some warning with some tool
> which you didn't tell us about?
it fixed 2 sparse warnings:
drivers/usb/storage/initializers.c:83:26: warning: incorrect type in argument 5 (different signedness)
drivers/usb/storage/initializers.c:83:26:    expected unsigned int *act_len
drivers/usb/storage/initializers.c:83:26:    got int *<noident>
drivers/usb/storage/initializers.c:89:26: warning: incorrect type in argument 5 (different signedness)
drivers/usb/storage/initializers.c:89:26:    expected unsigned int *act_len
drivers/usb/storage/initializers.c:89:26:    got int *<noident>

After you pointed out that I should include warnings in patch description,
I've sent this: http://lkml.org/lkml/2007/12/15/157

Marcin
