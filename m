Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbXDATJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbXDATJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXDATJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:09:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19258 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbXDATI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:08:59 -0400
Date: Sun, 1 Apr 2007 12:09:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 14/16] kconfig-allow-override.diff
Message-Id: <20070401120950.1cf17dda.randy.dunlap@oracle.com>
In-Reply-To: <20070401184441.GB10113@uranus.ravnborg.org>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012010250.12316@yvahk01.tjqt.qr>
	<20070401184441.GB10113@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:44:41 +0200 Sam Ravnborg wrote:

> This part of kconfig is taken care of by Roman Zippel.
> Kept the full mail for his reference.
> 
> 	Sam

I certainly want this.


> On Sun, Apr 01, 2007 at 08:17:32PM +0200, Jan Engelhardt wrote:
> > 
> > Allow config variables in .config to override earlier ones in the same
> > file. In other words,
> > 
> > 	# CONFIG_SECURITY is not defined
> > 	CONFIG_SECURITY=y
> > 
> > will activate it. This makes it a bit easier to do
> > 
> > 	(cat original-config myconfig myconfig2 ... >.config)
> > 
> > and run menuconfig as expected.
> > 
> > Already posted at http://lkml.org/lkml/2006/10/25/81
> > Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > 
> >  confdata.c |   14 +++++---------
> >  1 file changed, 5 insertions(+), 9 deletions(-)
> > 
> > Index: linux-2.6.21-rc5/scripts/kconfig/confdata.c
> > ===================================================================
> > --- linux-2.6.21-rc5.orig/scripts/kconfig/confdata.c
> > +++ linux-2.6.21-rc5/scripts/kconfig/confdata.c
> > @@ -170,8 +170,7 @@ load:
> >  					sym->type = S_BOOLEAN;
> >  			}
> >  			if (sym->flags & def_flags) {
> > -				conf_warning("trying to reassign symbol %s", sym->name);
> > -				break;
> > +				conf_warning("override: reassigning to symbol %s", sym->name);
> >  			}
> >  			switch (sym->type) {
> >  			case S_BOOLEAN:
> > @@ -210,8 +209,7 @@ load:
> >  					sym->type = S_OTHER;
> >  			}
> >  			if (sym->flags & def_flags) {
> > -				conf_warning("trying to reassign symbol %s", sym->name);
> > -				break;
> > +				conf_warning("override: reassigning to symbol %s", sym->name);
> >  			}
> >  			switch (sym->type) {
> >  			case S_TRISTATE:
> > @@ -288,11 +286,9 @@ load:
> >  				}
> >  				break;
> >  			case yes:
> > -				if (cs->def[def].tri != no) {
> > -					conf_warning("%s creates inconsistent choice state", sym->name);
> > -					cs->flags &= ~def_flags;
> > -				} else
> > -					cs->def[def].val = sym;
> > +				if(cs->def[def].tri != no)
> > +					conf_warning("override: %s turns state choice", sym->name);
> > +				cs->def[def].val = sym;
> >  				break;
> >  			}
> >  			cs->def[def].tri = E_OR(cs->def[def].tri, sym->def[def].tri);
> > #<EOF>


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
