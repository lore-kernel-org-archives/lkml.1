Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbZKMXh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbZKMXh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932496AbZKMXh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:37:26 -0500
Received: from mail.perches.com ([173.55.12.10]:1044 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414AbZKMXhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:37:25 -0500
Subject: Re: [PATCH] drivers/thermal/thermal_sys.c: fix strncmp tests
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Sujith Thomas <sujith.thomas@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091113142254.73f82283.akpm@linux-foundation.org>
References: <1257804769.12852.22.camel@Joe-Laptop.home>
	 <20091113142254.73f82283.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 15:37:30 -0800
Message-ID: <1258155450.16857.129.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 14:22 -0800, Andrew Morton wrote:
> On Mon, 09 Nov 2009 14:12:49 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > Use strncmp(var, "foo", sizeof("foo") - 1)
> > not strncmp(var, "foo", sizeof("foo"))
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> > index 4e83c29..c35d538 100644
> > --- a/drivers/thermal/thermal_sys.c
> > +++ b/drivers/thermal/thermal_sys.c
> > @@ -147,9 +147,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
> >  	if (!tz->ops->set_mode)
> >  		return -EPERM;
> >  
> > -	if (!strncmp(buf, "enabled", sizeof("enabled")))
> > +	if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
> 
> How about
> 
> 	if (!strcmp(buf, "enabled"))

Fine with me.

I think strncmp(foo, "bar", sizeof("bar"))
where foo has a trailing 0 should be
converted to strcmp(foo, "bar");



