Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbYDYTLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbYDYTLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYDYS77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:59:59 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51124 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbYDYS75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:59:57 -0400
Date: Fri, 25 Apr 2008 21:00:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: silence documentation GEN xml messages according to $(quiet)
Message-ID: <20080425190030.GD10902@uranus.ravnborg.org>
References: <1206371815-32376-1-git-send-email-vapier@gentoo.org> <20080324090939.73f8b00b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324090939.73f8b00b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 09:09:39AM -0700, Randy Dunlap wrote:
> On Mon, 24 Mar 2008 11:16:55 -0400 Mike Frysinger wrote:
> 
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> >  Documentation/DocBook/Makefile |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> > index 300e170..f6a4ba3 100644
> > --- a/Documentation/DocBook/Makefile
> > +++ b/Documentation/DocBook/Makefile
> > @@ -186,8 +186,11 @@ quiet_cmd_fig2png = FIG2PNG $@
> >  
> >  ###
> >  # Rule to convert a .c file to inline XML documentation
> > +       gen_xml = :
> > + quiet_gen_xml = echo '  GEN     $@'
> > +silent_gen_xml = :
> >  %.xml: %.c
> > -	@echo '  GEN     $@'
> > +	@$($(quiet)gen_xml)
> >  	@(                            \
> >  	   echo "<programlisting>";   \
> >  	   expand --tabs=8 < $< |     \
> > -- 
> 
> The Makefile changes are good, but the patch description makes it
> appear that Mike was rushed.  How about something like this?
> 
> Add rules for gen_xml and its quiet & silent variants.
> This causes "make -s" to be silent for gen_xml.
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Applied - but I forgot to add this update.

Sorry,

	Sam
