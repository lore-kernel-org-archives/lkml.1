Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYGOXn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYGOXn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYGOXnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:43:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYGOXnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:43:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Wed, 16 Jul 2008 01:45:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <1216154956.26991.30.camel@shinybook.infradead.org> <1216155444.26991.33.camel@shinybook.infradead.org>
In-Reply-To: <1216155444.26991.33.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160145.56067.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 of July 2008, David Woodhouse wrote:
> On Tue, 2008-07-15 at 13:49 -0700, David Woodhouse wrote:
> > Sam, why do we have FORCE on the rules for $(hostprogs-y)? It forces the
> > ihex2fw tool to be rebuilt, which in turn forces all .HEX->.fw
> > conversions to happen again, which means that 'make modules_install'
> > wants to write to the source tree. That's a problem in some strange
> > situations like Rafael's, where he builds on another host and exports
> > the tree read-only by NFS.
> > 
> > Can we do this? ...
> 
> Alternatively, Rafael, does this do it for you?

No, it doesn't.

> --- a/firmware/Makefile
> +++ b/firmware/Makefile
> @@ -150,11 +150,11 @@ $(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
>  # is actually meaningful, because the firmware has to be loaded in a certain
>  # order rather than as a single binary blob. Thus, we convert them into our
>  # more compact binary representation of ihex records (<linux/ihex.h>)
> -$(obj)/%.fw: $(obj)/%.HEX $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
> +$(obj)/%.fw: $(obj)/%.HEX | $(obj)/ihex2fw $(objtree)/$(obj)/$$(dir %)
>  	$(call cmd,ihex2fw)
>  
>  # .H16 is our own modified form of Intel HEX, with 16-bit length for records.
> -$(obj)/%.fw: $(obj)/%.H16 $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
> +$(obj)/%.fw: $(obj)/%.H16 | $(obj)/ihex2fw $(objtree)/$(obj)/$$(dir %)
>  	$(call cmd,h16tofw)
>  
>  $(firmware-dirs):
> 

Rafael
