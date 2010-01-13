Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505Ab0AMXUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0AMXUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120Ab0AMXUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:20:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab0AMXUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:20:15 -0500
Date: Wed, 13 Jan 2010 15:19:23 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] lockdep: Fix the way to initialize class_mutex for
 information of file and line
Message-ID: <20100113231923.GB12325@suse.de>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
 <1262860795-5745-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20100113100022.GA11386@elte.hu>
 <20100113231755.GA12325@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113231755.GA12325@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 03:17:55PM -0800, Greg KH wrote:
> On Wed, Jan 13, 2010 at 11:00:22AM +0100, Ingo Molnar wrote:
> > 
> > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > This patch adds __FILE__ and __LINE__ to arguments passed for
> > > __mutex_init() called in __class_register().
> > > This affects to lockdep_map of class_mutex of struct class_private,
> > > and these will be used to make trace lock events more human friendly.
> > > 
> > > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > ---
> > >  drivers/base/class.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/base/class.c b/drivers/base/class.c
> > > index 161746d..cc0630f 100644
> > > --- a/drivers/base/class.c
> > > +++ b/drivers/base/class.c
> > > @@ -162,7 +162,8 @@ int __class_register(struct class *cls, struct lock_class_key *key)
> > >  	klist_init(&cp->class_devices, klist_class_dev_get, klist_class_dev_put);
> > >  	INIT_LIST_HEAD(&cp->class_interfaces);
> > >  	kset_init(&cp->class_dirs);
> > > -	__mutex_init(&cp->class_mutex, "struct class mutex", key);
> > > +	__mutex_init(&cp->class_mutex, "struct class mutex", key,
> > > +		     __FILE__, __LINE__);
> > >  	error = kobject_set_name(&cp->class_subsys.kobj, "%s", cls->name);
> > >  	if (error) {
> > >  		kfree(cp);
> > 
> > Greg, any objection to this type of embellishment of lock data that comes from 
> > the driver core?
> 
> No, I'll queue it up in my tree.

Er, oops, sorry, that would go through your tree, not mine :)

Feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

In looking at it, this might solve the lockdep issue with the device
tree as well, I'll have to play with it once this makes it into Linus's
tree.

thanks,

greg k-h
