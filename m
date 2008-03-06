Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbYCFWag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbYCFWag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbYCFWaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:30:14 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39071 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYCFWaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:30:12 -0500
Date: Thu, 6 Mar 2008 23:30:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Adrian Bunk <bunk@kernel.org>,
       Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
Message-ID: <20080306223027.GA2869@uranus.ravnborg.org>
References: <200803062009.20309.toralf.foerster@gmx.de> <20080306202246.GB5259@cs181133002.pp.htv.fi> <20080306203558.GA7430@tree.beaverton.ibm.com> <1204839126.3062.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1204839126.3062.57.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 03:32:06PM -0600, James Bottomley wrote:
> On Thu, 2008-03-06 at 12:35 -0800, Darrick J. Wong wrote:
> > On Thu, Mar 06, 2008 at 10:22:46PM +0200, Adrian Bunk wrote:
> > > This patch fixes the following build error reported by Toralf Förster:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > >   MODPOST 243 modules
> > > ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!
> > 
> > <snip>
> > 
> > > --- a/drivers/scsi/aic94xx/Kconfig
> > > +++ b/drivers/scsi/aic94xx/Kconfig
> > 
> > Maybe I'm missing something here, but how does patching aic94xx Kconfig
> > fix an mvsas build problem?
> 
> Actually, it's a dependency chain fault.  The config this was generated
> from has
> 
> CONFIG_SCSI=m
> 
> CONFIG_SCSI_AIC94XX=y
> 
> the latter then forces
> 
> CONFIG_SCSI_SAS_LIBSAS=y
> 
> I think the error reported is wrong: the kernel just should have failed
> to link, since both the built in aic94xx and libsas have scsi
> dependencies.
> 
> We have a few other drivers in this category (like ibmvscsi).  The root
> cause seems to be that SCSI_LOWLEVEL doesn't act as a tristate.  I think
> a fix that will prevent all of these issues from recurring is this one.

Until kconfig is fixed - never select a symbol with a prompt or dependencies.
Then most issues are gone.

	Sam
