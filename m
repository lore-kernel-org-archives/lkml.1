Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab0BULWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 06:22:05 -0500
Received: from ist.d-labs.de ([213.239.218.44]:40164 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab0BULWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 06:22:01 -0500
Date: Sun, 21 Feb 2010 12:21:55 +0100
From: Florian Mickler <florian@mickler.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] Document the rfkill sysfs ABI
Message-ID: <20100221122155.7b163b55@schatten.dmk.lab>
In-Reply-To: <1266746930.18491.1.camel@violet>
References: <1266702045-6062-1-git-send-email-florian@mickler.org>
	<1266702045-6062-2-git-send-email-florian@mickler.org>
	<1266704345.32739.0.camel@jlt3.sipsolutions.net>
	<1266746930.18491.1.camel@violet>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010 11:08:50 +0100
Marcel Holtmann <marcel@holtmann.org> wrote:

> Hi Johannes,
> 
> > > This moves sysfs ABI info from Documentation/rfkill.txt to the
> > > ABI subfolder and reformats it.
> > > 
> > > Signed-off-by: Florian Mickler <florian@mickler.org>
> > 
> > This is fine with me.
> 
> we have to be careful here. Some of these sysfs details needs to be
> deprecated and removed. Applications should use /dev/rfkill actually.
> 
> Regards
> 
> Marcel
> 

There are three different categories: 
Documentation/ABI/stable 
Documentation/ABI/obsolete
Documentation/ABI/testing

Quoting from the ABI/README:
> The different levels of stability are:
> 
>   stable/
>         This directory documents the interfaces that the developer has
>         defined to be stable.  Userspace programs are free to use these
>         interfaces with no restrictions, and backward compatibility for
>         them will be guaranteed for at least 2 years.  Most interfaces
>         (like syscalls) are expected to never change and always be
>         available.
> 
>   testing/
>         This directory documents interfaces that are felt to be stable,
>         as the main development of this interface has been completed.
>         The interface can be changed to add new features, but the
>         current interface will not break by doing this, unless grave
>         errors or security problems are found in them.  Userspace
>         programs can start to rely on these interfaces, but they must be
>         aware of changes that can occur before these interfaces move to
>         be marked stable.  Programs that use these interfaces are
>         strongly encouraged to add their name to the description of
>         these interfaces, so that the kernel developers can easily
>         notify them if any changes occur (see the description of the
>         layout of the files below for details on how to do this.)
> 
>   obsolete/
>         This directory documents interfaces that are still remaining in
>         the kernel, but are marked to be removed at some later point in
>         time.  The description of the interface will document the reason
>         why it is obsolete and when it can be expected to be removed.
>         The file Documentation/feature-removal-schedule.txt may describe
>         some of these interfaces, giving a schedule for when they will
>         be removed.
> 
>   removed/
>         This directory contains a list of the old interfaces that have
>         been removed from the kernel.
> 


So the question is: are the state and claim file deprecated or obsolete? 
If they are considered obsolete I presume it would be ok, to put this
part of the ABI description into the obsolete/ subfolder. 

And should they be obsolete, should there be a new file ("blocked",
"state2.0",whatever,...) which exposes all possible states? I assume it
do be handy for scripted access to the rfkill device. 

cheers,
Flo
