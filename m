Return-Path: <linux-kernel-owner+w=401wt.eu-S1764159AbYDYTUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764159AbYDYTUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYDYTUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:20:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45131 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbYDYTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:20:19 -0400
Date: Fri, 25 Apr 2008 21:20:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: silence documentation GEN xml messages according to $(quiet)
Message-ID: <20080425192052.GB11509@uranus.ravnborg.org>
References: <1206371815-32376-1-git-send-email-vapier@gentoo.org> <20080324090939.73f8b00b.randy.dunlap@oracle.com> <20080425190030.GD10902@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425190030.GD10902@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 09:00:30PM +0200, Sam Ravnborg wrote:
> On Mon, Mar 24, 2008 at 09:09:39AM -0700, Randy Dunlap wrote:
> > On Mon, 24 Mar 2008 11:16:55 -0400 Mike Frysinger wrote:
> > 
> > > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > > ---
> > >  Documentation/DocBook/Makefile |    5 ++++-
> > >  1 files changed, 4 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> > > index 300e170..f6a4ba3 100644
> > > --- a/Documentation/DocBook/Makefile
> > > +++ b/Documentation/DocBook/Makefile
> > > @@ -186,8 +186,11 @@ quiet_cmd_fig2png = FIG2PNG $@
> > >  
> > >  ###
> > >  # Rule to convert a .c file to inline XML documentation
> > > +       gen_xml = :
> > > + quiet_gen_xml = echo '  GEN     $@'
> > > +silent_gen_xml = :
> > >  %.xml: %.c
> > > -	@echo '  GEN     $@'
> > > +	@$($(quiet)gen_xml)
> > >  	@(                            \
> > >  	   echo "<programlisting>";   \
> > >  	   expand --tabs=8 < $< |     \
> > > -- 
> > 
> > The Makefile changes are good, but the patch description makes it
> > appear that Mike was rushed.  How about something like this?
> > 
> > Add rules for gen_xml and its quiet & silent variants.
> > This causes "make -s" to be silent for gen_xml.
> > 
> > Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> Applied - but I forgot to add this update.

OK - I had not applied the patch so I got it right
in the end. Applied and pushed out.

	Sam
