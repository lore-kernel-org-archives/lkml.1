Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYANVil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYANVil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYANVic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:38:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYANVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:38:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Smith <dds@google.com>
Subject: Re: [tpmdd-devel] [PATCH] - TPM save state before suspending to ram
Date: Mon, 14 Jan 2008 22:40:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Kent Yoder <shpedoikal@gmail.com>,
       Marcel Selhorst <tpm@selhorst.net>, Andrew Morton <akpm@osdl.org>,
       TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
References: <477D491F.1060001@selhorst.net> <20080104234413.GB800@elf.ucw.cz> <200801051354.37843.dds@google.com>
In-Reply-To: <200801051354.37843.dds@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801142240.59174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of January 2008, David Smith wrote:
> > On Fri 2008-01-04 14:09:01, Kent Yoder wrote:
> > > On Jan 4, 2008 10:39 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > > > On Thu 2008-01-03 21:44:15, Marcel Selhorst wrote:
> > > > > Dear list,
> > > > >
> > > > > this patch fixes a bug, that prevents the TPM chip to resume
> > > > > correctly from a suspended state.
> > > > >
> > > > > Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
> > >
> > > [cut]
> > >
> > > > I'm not sure if we want to use variable-size array on stack. What
> > > > hacks are you doing with max_t/max?
> > > >                                                                        
> > > > Pavel
> > >
> > > Hi Pavel,
> > >
> > >   Here's an alternate solution from David, signoffs pending --
> > >
> > > commit 058f1e3c4d4e2de5a7188608a1c2e0722498fd4b
> > > Author: David Smith <davidsmith@acm.org>
> > > Date:   Fri Jan 4 03:33:11 2008 +0900
> > >
> > >     Fix for TPM suspend/resume failure
> > >
> > > diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> > > index 9bb5429..79d2fd5 100644
> > > --- a/drivers/char/tpm/tpm.c
> > > +++ b/drivers/char/tpm/tpm.c
> > > @@ -1046,12 +1046,6 @@ void tpm_remove_hardware(struct device *dev)
> > >  }
> > >  EXPORT_SYMBOL_GPL(tpm_remove_hardware);
> > >
> > > -static u8 savestate[] = {
> > > -	0, 193,			/* TPM_TAG_RQU_COMMAND */
> > > -	0, 0, 0, 10,		/* blob length (in bytes) */
> > > -	0, 0, 0, 152		/* TPM_ORD_SaveState */
> > > -};
> > > -
> > >  /*
> > >   * We are about to suspend. Save the TPM state
> > >   * so that it can be restored.
> > > @@ -1059,8 +1053,14 @@ static u8 savestate[] = {
> > >  int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
> > >  {
> > >  	struct tpm_chip *chip = dev_get_drvdata(dev);
> > > +        u8 savestate[] = {
> > > +          0, 193,		/* TPM_TAG_RQU_COMMAND */
> > > +          0, 0, 0, 10,		/* blob length (in bytes) */
> > > +          0, 0, 0, 152		/* TPM_ORD_SaveState */
> > > +        };
> > > +
> > >  	if (chip == NULL)
> > > -		return -ENODEV;
> > > +          return -ENODEV;
> > >
> > >  	tpm_transmit(chip, savestate, sizeof(savestate));
> > >  	return 0;
> >
> > Yep, but please fix the whitespace.
> > 									Pavel
> 
> OK, attached.

Is anyone taking care of this patch or should I do that?

Rafael




-- 
"Premature optimization is the root of all evil." - Donald Knuth
