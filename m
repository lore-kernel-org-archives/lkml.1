Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYGVUxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYGVUxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYGVUwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:52:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:45763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYGVUw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:52:29 -0400
Date: Tue, 22 Jul 2008 13:50:15 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 02/79] kobject: replace '/' with '!' in name
Message-ID: <20080722205015.GB3028@suse.de>
References: <20080722051805.GA17373@suse.de> <1216703983-21448-2-git-send-email-gregkh@suse.de> <200807222012.39852.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807222012.39852.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 08:12:38PM +0200, Ingo Oeser wrote:
> Hi Greg,
> hi Kay,
> 
> On Tuesday 22 July 2008, Greg Kroah-Hartman wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > 
> > Some (block) devices have a '/' in the name, and need special
> > handling. Let's have that rule to the core, so we can remove it
> > from the block class.
> 
> Yes, but why replace only one?

Do you know of block devices with more than one?

> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index dcade05..7444015 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -216,13 +216,19 @@ static int kobject_add_internal(struct kobject *kobj)
> >  static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> >  				  va_list vargs)
> >  {
> > -	/* Free the old name, if necessary. */
> > -	kfree(kobj->name);
> > +	const char *old_name = kobj->name;
> > +	char *s;
> >  
> >  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> >  	if (!kobj->name)
> >  		return -ENOMEM;
> >  
> > +	/* ewww... some of these buggers have '/' in the name ... */
> > +	s = strchr(kobj->name, '/');
> > +	if (s)
> > +		s[0] = '!';
> > +
> > +	kfree(old_name);
> >  	return 0;
> >  }
> 
> while (s = strchr(kobj->name, '/')) {
> 	s[0] = '!';
> }
> 
> instead?

Nice, care to send a follow-on patch for this?

thanks,

greg k-h
