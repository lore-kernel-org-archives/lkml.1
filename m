Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZGVVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZGVVsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZGVVso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:48:44 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43252 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbZGVVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:48:43 -0400
Date: Wed, 22 Jul 2009 23:48:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Cheng Renquan <crq@kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       crquan@gmail.com, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 0/6] kbuild configuration system improvements
Message-ID: <20090722214842.GA8695@merkur.ravnborg.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org> <20090718072138.GA7711@merkur.ravnborg.org> <20090722134321.34f1ebf7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722134321.34f1ebf7.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 01:43:21PM -0700, Randy Dunlap wrote:
> On Sat, 18 Jul 2009 09:21:38 +0200 Sam Ravnborg wrote:
> 
> > On Sun, Jul 12, 2009 at 04:11:42PM +0800, Cheng Renquan wrote:
> > > From: Cheng Renquan <crquan@gmail.com>
> > > 
> > > These patches improve usability of kernel configuration system,
> > > 
> > > 1. add symbol's value shown accompanied in config item's help message;
> > > 2. move the real plumbing functions code from mconf.c to menu.c, make them
> > >    be able to be shared with other configuration methods;
> > > 3. add "symbol's value shown" support for gconfig/xconfig/config;
> > > 
> > >     0001-add-symbol-value-to-help-find-the-real-depend.patch
> > >     0002-add-menu_get_ext_help-function-to-display-more-infor.patch
> > >     0003-menuconfig-improvements.patch
> > >     0004-make-use-of-menu_get_ext_help-in-gconfig.patch
> > >     0005-make-use-of-menu_get_ext_help-in-qconfig.patch
> > >     0006-make-use-of-menu_get_ext_help-in-make-config.patch
> > 
> > I fixed them all up to:
> > 1) include "kconfig:" prefix in subject
> > 2) cc: of Roman Zippel which is kconfig maintainer
> > 
> > There were a few checkpatch issues that I decided to ignore for now.
> > 
> > Please always cc: Roman on kconfig patches as he is the mintainer.
> > 
> > Applied to kbuild-next.git.
> 
> 
> FWIW, I still get a segfault in gconfig (as I reported several months ago).
> I suppose that if it's a real issue, someone else will also see this.

I assumed it was fixed - the changelog patches did
not mention any outstanding issues.

Following fix is needed.

	Sam

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 931d782..b74f746 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -528,5 +528,6 @@ void menu_get_ext_help(struct menu *menu, struct gstr *help)
 	} else {
 		str_append(help, nohelp_text);
 	}
-	get_symbol_str(help, sym);
+	if (sym)
+		get_symbol_str(help, sym);
 }




> 
> ---
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
> 
