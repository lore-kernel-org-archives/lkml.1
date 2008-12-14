Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYLNRF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYLNRF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYLNRFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:05:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYLNRFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:05:10 -0500
Date: Sun, 14 Dec 2008 12:05:09 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Better way to force a rebuild
In-Reply-To: <20081213231654.GA32446@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0812141204480.20467@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com> <20081210200242.GA15692@uranus.ravnborg.org> <20081210212821.GA18348@uranus.ravnborg.org> <20081213231654.GA32446@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 14 Dec 2008, Sam Ravnborg wrote:

> On Wed, Dec 10, 2008 at 10:28:21PM +0100, Sam Ravnborg wrote:
> > 
> > I made the following quick hack.
> > I think it should do the trick.
> > 
> > 	Sam
> > 
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index 468fbc9..8b5bf43 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -215,7 +215,8 @@ define rule_cc_o_c
> >  	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
> >  	$(cmd_modversions)						  \
> >  	$(cmd_record_mcount)						  \
> > -	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
> > +	scripts/basic/fixdep $(depfile) $@                                \
> > +	'$(call make-cmd,cc_o_c) $(call make-cmd,record_mcount)' >        \
> >  	                                              $(dot-target).tmp;  \
> >  	rm -f $(depfile);						  \
> >  	mv -f $(dot-target).tmp $(dot-target).cmd
> 
> Hi Steven.
> 
> Did you try the above?
> If it works I will add it to kbuild-next.git

I started to but got distracted :-/   I'll retry it on Monday.

-- Steve

