Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYIWU7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYIWU7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYIWU7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:59:40 -0400
Received: from [198.145.64.141] ([198.145.64.141]:54623 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752671AbYIWU7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:59:39 -0400
Date: Tue, 23 Sep 2008 13:56:40 -0700
From: Greg KH <greg@kroah.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH v2] Fix "notes" kobject leak
Message-ID: <20080923205640.GA17785@kroah.com>
References: <20080830044246.GA26435@x200.localdomain> <20080830054343.GA16899@suse.de> <20080906054522.GA3191@x200.localdomain> <20080912155105.GA3526@suse.de> <20080914084225.GA3133@x200.localdomain> <20080915225322.GA4504@suse.de> <20080915233504.GB21012@x200.localdomain> <20080915234050.GA10876@suse.de> <20080923195111.GA22247@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923195111.GA22247@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:51:11PM +0400, Alexey Dobriyan wrote:
> > > > > --- a/kernel/module.c
> > > > > +++ b/kernel/module.c
> > > > > @@ -1174,6 +1174,7 @@ static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
> > > > >  			sysfs_remove_bin_file(notes_attrs->dir,
> > > > >  					      &notes_attrs->attrs[i]);
> > > > >  		kobject_del(notes_attrs->dir);
> > > > > +		kobject_put(notes_attrs->dir);
> > > > 
> > > > Hm, no, that should just be a call to kobject_put() instead of
> > > > kobject_del(), can you try that instead and see if that solves the issue
> > > > (am at a conference and can't test that at the moment, sorry.)
> > > 
> > > Why?! kobject_del() puts parent kobject.
> > 
> > And that's about it (well, it also tears down the sysfs stuff.)
> > 
> > If you call kobject_put() instead, and it's the last put, it will also
> > call kobject_del() and do everything else that it needs to do.
> > 
> > Try it and let me know if I'm right or not :)
> 
> OK, this works too.
> 
> 
> [PATCH v2] Fix "notes" kobject leak

Great, thanks for testing, I'll apply this to my trees.

greg k-h
