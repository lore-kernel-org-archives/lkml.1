Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXKYMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXKYMcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 07:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXKYMcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 07:32:08 -0500
Received: from osl1smout1.broadpark.no ([80.202.4.58]:52112 "EHLO
	osl1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbXKYMcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 07:32:07 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=utf-8
Subject: Re: [PATCH 5/5] lguest: loading bzImage directly
From: Kjartan Maraas <kmaraas@broadpark.no>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Chris Malley <mail@chrismalley.co.uk>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, lguest <lguest@ozlabs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-reply-to: <4748A23D.2070906@zytor.com>
References: <1191368052.17826.40.camel@localhost.localdomain>
 <1191368106.17826.43.camel@localhost.localdomain>
 <1191368154.17826.44.camel@localhost.localdomain>
 <1191368217.17826.47.camel@localhost.localdomain>
 <1191368399.17826.51.camel@localhost.localdomain>
 <1191368457.17826.53.camel@localhost.localdomain>
 <1191404221.17247.15.camel@feisty>
 <1191456175.8268.6.camel@localhost.localdomain>
 <1195941250.2369.5.camel@localhost.localdomain> <4748A23D.2070906@zytor.com>
Date: Sun, 25 Nov 2007 13:32:03 +0100
Message-id: <1195993923.1386.3.camel@localhost.localdomain>
X-Mailer: Evolution 2.21.2 (2.21.2-2.fc9)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


lø., 24.11.2007 kl. 14.14 -0800, skrev H. Peter Anvin:
> Kjartan Maraas wrote:
> > to., 04.10.2007 kl. 10.02 +1000, skrev Rusty Russell:
> >> On Wed, 2007-10-03 at 10:37 +0100, Chris Malley wrote:
> >>> Hi guys
> >>>
> >>> Would it not be clearer to #include <asm/bootparam.h> and use 
> >>> the relevant named members of struct setup_header / struct boot_params
> >>> rather than the hard-coded values 0x202, 0x1F1, 0x214 ?
> >> Yes, but unfortunately bootparam.h wasn't designed to be included from
> >> userspace.
> >>
> > [snip]
> > 
> > This change seems to have broken build of the battstat applet in
> > gnome-applets or rather the included apmlib in there. Intended?
> > 
> > Any pointers on how to adapt the code in case it was?
> > 
> 
> Perhaps you could actually give some detail how it broke the code?!
> 
Sorry for being terse. It looks to me like apm_event_t is gone, and that
breaks this bit of code:

Making all in apmlib
make[1]: Entering directory
`/home/kmaraas/cvs/gnome/gnome-applets/battstat/apmlib'
gcc -DHAVE_CONFIG_H -I. -I../.. -I../.. -I../../apmlib -DORBIT2=1
-pthread -I/opt/gnome2/include/panel-2.0 -I/opt/gnome2/include/gtk-2.0
-I/opt/gnome2/include/libgnomeui-2.0
-I/opt/gnome2/include/libbonoboui-2.0 -I/opt/gnome2/lib/gtk-2.0/include
-I/opt/gnome2/include/atk-1.0 -I/opt/gnome2/include/cairo
-I/opt/gnome2/include/pango-1.0 -I/opt/gnome2/include/glib-2.0
-I/opt/gnome2/lib/glib-2.0/include -I/opt/gnome2/include/libgnome-2.0
-I/opt/gnome2/include/libgnomecanvas-2.0
-I/opt/gnome2/include/gnome-vfs-2.0
-I/opt/gnome2/lib/gnome-vfs-2.0/include
-I/opt/gnome2/include/libbonobo-2.0 -I/opt/gnome2/include/orbit-2.0
-I/opt/gnome2/include/bonobo-activation-2.0
-I/opt/gnome2/include/libart-2.0 -I/opt/gnome2/include/gconf/2
-DG_LOG_DOMAIN=\"battstat_applet\"  -Wall -g -O0 -D_FORTIFY_SOURCE=2
-Wall -g -O0 -D_FORTIFY_SOURCE=2 -MT apmlib.o -MD -MP
-MF .deps/apmlib.Tpo -c -o apmlib.o apmlib.c
In file included from apmlib.c:32:
apm.h:56: error: expected declaration specifiers or ‘...’ before
‘apm_event_t’
apm.h:63: error: expected ‘)’ before ‘event’
apmlib.c:243: error: expected declaration specifiers or ‘...’ before
‘apm_event_t’
apmlib.c: In function ‘apm_get_events’:
apmlib.c:257: error: ‘events’ undeclared (first use in this function)
apmlib.c:257: error: (Each undeclared identifier is reported only once
apmlib.c:257: error: for each function it appears in.)
apmlib.c:257: error: ‘apm_event_t’ undeclared (first use in this
function)
apmlib.c:258: warning: control reaches end of non-void function
apmlib.c: At top level:
apmlib.c:366: error: expected ‘)’ before ‘event’
make[1]: *** [apmlib.o] Error 1
make[1]: Leaving directory
`/home/kmaraas/cvs/gnome/gnome-applets/battstat/apmlib'
make: *** [all-recursive] Error 1

Cheers
Kjartan


