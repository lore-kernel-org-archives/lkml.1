Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYHRK7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYHRK7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYHRK7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:59:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYHRK7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:59:13 -0400
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <200808181943.23034.rusty@rustcorp.com.au>
References: <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>
	 <87hc9kxpp8.fsf@basil.nowhere.org> <20080818034851.GB30843@kroah.com>
	 <200808181943.23034.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 12:58:44 +0200
Message-Id: <1219057124.21867.6.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19PkDMiLFroObEzf4fPZAWb5IPSrhSi2BSW8iv
 J0XEkf/VIpTkvbCo10Rwfw+X8Ymd7zfPWJRYJr8AvAr6Xb2x2W
 uCT4R0DFlEbYUi5mVCnVd+HDivj3ezH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 19:43 +1000, Rusty Russell wrote:
> On Monday 18 August 2008 13:48:51 Greg KH wrote:
> > On Sun, Aug 17, 2008 at 05:53:07AM +0200, Andi Kleen wrote:
> > > Greg KH <greg@kroah.com> writes:
> > > >> No!
> > > >
> > > > What you are doing here is wrong, trying to create two files with the
> > > > same name.  You just should not be doing that at all, it's that simple.
> > > > Fix the broken code/link order, don't paper it over in the sysfs layer.
> > >
> > > Sorry, but relying on link order for anything is a mistake. It is subtle
> > > and fragile and just means it'll eventually break again because it's
> > > near impossible to properly maintain.
> >
> > We rely on link order for all sorts of things, this isn't new at all.
> 
> Sure, but this code should be rewritten to check if the directory exists,
> rather assuming it based on "previous prefix was the same".
> 
> It's relying on a horribly undocumented assumption, and it broke.
> 
> We need to change kernel_param_sysfs_setup() to do something
> like "kobject_find(module_kset, name)" and only allocate a new mk if that
> fails.

kobj = kset_find_obj(module_kset, name) should return an existing object
with that name (and take a reference on it, which needs to be dropped).

Kay

