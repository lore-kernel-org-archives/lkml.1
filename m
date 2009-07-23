Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbZGWAP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbZGWAP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZGWAP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:15:56 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:22934 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZGWAPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:15:55 -0400
Date: Wed, 22 Jul 2009 17:12:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Cheng Renquan <crq@kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       crquan@gmail.com, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 0/6] kbuild configuration system improvements
Message-Id: <20090722171224.d5ceaf39.randy.dunlap@oracle.com>
In-Reply-To: <20090722214842.GA8695@merkur.ravnborg.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org>
	<20090718072138.GA7711@merkur.ravnborg.org>
	<20090722134321.34f1ebf7.randy.dunlap@oracle.com>
	<20090722214842.GA8695@merkur.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A67AAEB.002F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 23:48:42 +0200 Sam Ravnborg wrote:

> On Wed, Jul 22, 2009 at 01:43:21PM -0700, Randy Dunlap wrote:
> > On Sat, 18 Jul 2009 09:21:38 +0200 Sam Ravnborg wrote:
> > 
> > > On Sun, Jul 12, 2009 at 04:11:42PM +0800, Cheng Renquan wrote:
> > > > From: Cheng Renquan <crquan@gmail.com>
> > > > 
> > > > These patches improve usability of kernel configuration system,
> > > > 
> > > > 1. add symbol's value shown accompanied in config item's help message;
> > > > 2. move the real plumbing functions code from mconf.c to menu.c, make them
> > > >    be able to be shared with other configuration methods;
> > > > 3. add "symbol's value shown" support for gconfig/xconfig/config;
> > > > 
> > > >     0001-add-symbol-value-to-help-find-the-real-depend.patch
> > > >     0002-add-menu_get_ext_help-function-to-display-more-infor.patch
> > > >     0003-menuconfig-improvements.patch
> > > >     0004-make-use-of-menu_get_ext_help-in-gconfig.patch
> > > >     0005-make-use-of-menu_get_ext_help-in-qconfig.patch
> > > >     0006-make-use-of-menu_get_ext_help-in-make-config.patch
> > > 
> > > I fixed them all up to:
> > > 1) include "kconfig:" prefix in subject
> > > 2) cc: of Roman Zippel which is kconfig maintainer
> > > 
> > > There were a few checkpatch issues that I decided to ignore for now.
> > > 
> > > Please always cc: Roman on kconfig patches as he is the mintainer.
> > > 
> > > Applied to kbuild-next.git.
> > 
> > 
> > FWIW, I still get a segfault in gconfig (as I reported several months ago).
> > I suppose that if it's a real issue, someone else will also see this.
> 
> I assumed it was fixed - the changelog patches did
> not mention any outstanding issues.
> 
> Following fix is needed.

Ack, that works.  Thanks.


> 	Sam
> 
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index 931d782..b74f746 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -528,5 +528,6 @@ void menu_get_ext_help(struct menu *menu, struct gstr *help)
>  	} else {
>  		str_append(help, nohelp_text);
>  	}
> -	get_symbol_str(help, sym);
> +	if (sym)
> +		get_symbol_str(help, sym);
>  }
> 
> 
> 
> 
> > 
> > ---
> > ~Randy
> > LPC 2009, Sept. 23-25, Portland, Oregon
> > http://linuxplumbersconf.org/2009/
> > 


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
