Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYBXLAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYBXLAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYBXK7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:59:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYBXK7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:59:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC 03/11] slim down debugfs
Date: Sun, 24 Feb 2008 11:59:41 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
References: <20080219040435.825494460@arndb.de> <20080219040828.823685054@arndb.de> <20080223123753.GP27894@ZenIV.linux.org.uk>
In-Reply-To: <20080223123753.GP27894@ZenIV.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802241159.41895.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+zOswQuffX4heH4ZU9xH9dsm88gBVRkHc1bSE
 cgiG7BDX509PTG7TR4jQWgTfw7I5noxpEaubh6iYYyOeUzO/bl
 TuPAb0HieXHEnb0yaxZxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008, Al Viro wrote:
> > +config LIBFS
> > +     tristate
> > +     default m
> > +     help
> > +       libfs is a helper library used by many of the simpler file
> > +       systems. Parts of libfs can be modular when all of its users
> > +       are modules as well, and the users should select this symbol.
> 
> NAK.  For one thing, you need dependencies or selects and none of the
> patches later in the series introduces them.  For another, neither
> dependencies nor selects work well if you have non-modular users of
> that sucker.  Seriously, try to add those and do allmodconfig.  Then
> look what a mess it produces.

Sorry about that hunk, I didn't mean to keep that in there. In
my testing, I used the newly introduced parts as a loadable
module, and at one point the intention was to keep the existing
libfs functions as builtin and add a new Kconfig dependency in every
user of the new stuff whenever a file system gets converted.

I figured out later that hardly anyone could even try to build
without them as soon as all the trival file systems are moved
over, but forgot to make it always builtin.

	Arnd <><
