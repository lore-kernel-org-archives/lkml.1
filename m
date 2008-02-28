Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbYB1Scg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbYB1Scg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYB1Sc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:32:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42155 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbYB1Sc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:32:27 -0500
Date: Thu, 28 Feb 2008 19:32:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel-doc: set verbose mode via environment
Message-ID: <20080228183234.GA24684@uranus.ravnborg.org>
References: <20080224175358.3202f0d0.randy.dunlap@oracle.com> <20080227191104.6f166972.akpm@linux-foundation.org> <20080228083009.5955a7eb.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228083009.5955a7eb.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 08:30:09AM -0800, Randy Dunlap wrote:
> On Wed, 27 Feb 2008 19:11:04 -0800 Andrew Morton wrote:
> 
> > On Sun, 24 Feb 2008 17:53:58 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Allow setting environment variable "KERNEL_DOC_VERBOSE=1" to enable
> > > verbose mode in scripts/kernel-doc.  Useful for getting more
> > > info and warnings from kernel-doc.
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > ---
> > >  scripts/kernel-doc |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > --- linux-2.6.25-rc3.orig/scripts/kernel-doc
> > > +++ linux-2.6.25-rc3/scripts/kernel-doc
> > > @@ -247,6 +247,10 @@ my ($function, %function_table,%paramete
> > >  my ($type,$declaration_name,$return_type);
> > >  my ($newsection,$newcontents,$prototype,$filelist, $brcount, %source_map);
> > >  
> > > +if (defined($ENV{'KERNEL_DOC_VERBOSE'})) {
> > > +	$verbose = "$ENV{'KERNEL_DOC_VERBOSE'}";
> > > +}
> > > +
> > >  # Generated docbook code is inserted in a template at a point where
> > >  # docbook v3.1 requires a non-zero sequence of RefEntry's; see:
> > >  # http://www.oasis-open.org/docbook/documentation/reference/html/refentry.html
> > 
> > Shouldn't this be, err, documented somewhere?
> 
> I did think about that.  I was still wondering where to add it.
In the same file where you document all the kconfig stuff - so we can let it be
a 'all build features ' document?

> 
> > I'd have expected to obtain this functionality by running `make V=1 foodocs'?
> 
> Sam, any thoughts on Makefile passing "-v" to scripts/kernel-doc ?
Please implemnt this. Either add a flag to docproc or
just read the env-variable KBUILD_VERBOSE in kernel-doc.

	Sam
