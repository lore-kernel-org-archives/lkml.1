Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYKRXlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYKRXlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYKRXlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:41:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbYKRXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:41:31 -0500
Date: Tue, 18 Nov 2008 15:41:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: tom.leiming@gmail.com, kay.sievers@vrfy.org, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/ksysfs.c:fix dependence on CONFIG_NET
Message-Id: <20081118154128.56d1d3ca.akpm@linux-foundation.org>
In-Reply-To: <20081118153818.e623ba03.akpm@linux-foundation.org>
References: <1226830929-6610-1-git-send-email-tom.leiming@gmail.com>
	<20081118153818.e623ba03.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 15:38:18 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 16 Nov 2008 18:22:09 +0800
> tom.leiming@gmail.com wrote:
> 
> > From: Ming Lei <tom.leiming@gmail.com>
> > 
> > Access to uevent_seqnum and uevent_helper does not need to
> > depend on CONFIG_NET, so remove it.
> > 
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > ---
> >  kernel/ksysfs.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> > index 08dd8ed..528dd78 100644
> > --- a/kernel/ksysfs.c
> > +++ b/kernel/ksysfs.c
> > @@ -24,7 +24,7 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
> >  static struct kobj_attribute _name##_attr = \
> >  	__ATTR(_name, 0644, _name##_show, _name##_store)
> >  
> > -#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
> > +#if defined(CONFIG_HOTPLUG)
> >  /* current uevent sequence number */
> >  static ssize_t uevent_seqnum_show(struct kobject *kobj,
> >  				  struct kobj_attribute *attr, char *buf)
> > @@ -137,7 +137,7 @@ struct kobject *kernel_kobj;
> >  EXPORT_SYMBOL_GPL(kernel_kobj);
> >  
> >  static struct attribute * kernel_attrs[] = {
> > -#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
> > +#if defined(CONFIG_HOTPLUG)
> >  	&uevent_seqnum_attr.attr,
> >  	&uevent_helper_attr.attr,
> >  #endif
> 
> I think the story here is that uevent uses netlink, and with
> CONFIG_NET=n, we have no netlink, so that code couldn't do anything
> anyway.
> 

Or not.  Perhaps we can still use uevent_helper in this case?

(Getting a bit tired of writing people's changelogs for them!)
