Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYCKXuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYCKXuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYCKXt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:49:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37092 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYCKXt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:49:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -mm] kexec jump -v9
Date: Wed, 12 Mar 2008 00:49:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Vivek Goyal <vgoyal@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080311211004.GA30164@redhat.com> <20080311232415.GA26320@elf.ucw.cz>
In-Reply-To: <20080311232415.GA26320@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120049.06491.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of March 2008, Pavel Machek wrote:
> Hi!

Hi,

> > > This is a minimal patch with only the essential features. All
> > > additional features are split out and can be discussed later. I think
> > > it may be easier to get consensus on this minimal patch.
> > > 
> > 
> > Hi Huang,
> > 
> > This patchset is slowly getting better. True that first we need to come
> > up with minimal infrastructure patch and then think of building more
> > functionality on top of it.
> > 
> ...
> > > The features of this patch can be used for as follow:
> > > 
> > > - A simple hibernation implementation without ACPI support. You can
> > >   kexec a hibernating kernel, save the memory image of original system
> > >   and shutdown the system. When resuming, you restore the memory image
> > >   of original system via ordinary kexec load then jump back.
> > > 
> > 
> > The main usage of this functionality is for hibernation. I am not sure
> > what has been the conclusion of previous discussions.
> > 
> > Rafael/Pavel, does the approach of doing hibernation using a separate
> > kernel holds promise?
> 
> Its certainly "more traditional" method of doing hibernation than
> tricks swsusp currently plays.

What exactly are you referring to?

> Yes, I'd like these patches to go in, being able to switch kernels seems like
> useful tool. 

No objection from me.
 
> Now, I guess they are some difficulties, like ACPI integration, and
> some basic drawbacks, like few seconds needed to boot second kernel
> during suspend.
> 
> ...OTOH this is probably only chance to eliminate freezer from
> swsusp...

Some facts:

* In order to be able to do suspend (STR) without the freezer, we need to make
  device drivers block access to devices from applications during suspend.
* There's no reason to think that we can't use this same mechanism for
  hibernation (the only difficulty seems to be the handling of devices used for
  saving the image).
* We need the drivers to quiesce devices to be able to do the kexec jump in the
  first place (and to avoid races, we'll need them to block applications'
  access to devices just like for STR, which is the sufficient condition for
  removing the freezer).

So, I don't really think that the "freezer removal" argument is valid here.

Moreover, if this had been the _only_ argument for the $subject functionality,
I'd have been against it.

Thanks,
Rafael
