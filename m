Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZFCGZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZFCGZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZFCGZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:25:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbZFCGZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:25:17 -0400
Date: Tue, 2 Jun 2009 23:25:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl
Subject: Re: [PATCH] Fix floppy hibernation
Message-Id: <20090602232502.b05302d3.akpm@linux-foundation.org>
In-Reply-To: <200906030813.27625.linux@rainbow-software.org>
References: <200905301804.26762.linux@rainbow-software.org>
	<200906021830.53531.linux@rainbow-software.org>
	<20090602151556.5df9167c.akpm@linux-foundation.org>
	<200906030813.27625.linux@rainbow-software.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009 08:13:26 +0200 Ondrej Zary <linux@rainbow-software.org> wrote:

> > > +static int floppy_resume(struct platform_device *dev)
> > > +{
> > > +	int fdc;
> > > +
> > > +	for (fdc = 0; fdc < N_FDC; fdc++)
> > > +		if (FDCS->address != -1)
> > > +			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
> > > +
> > > +	return 0;
> > > +}
> >
> > The patch changes the driver so that it calls user_reset_fdc() for each
> > device at resume-time.
> >
> > Why?  What effect does this have on the hardware and why does it fix
> > things?
> 
> I don't know at all, it's complete guesswork. The first thing I tested was 
> rmmod floppy && modprobe floppy after resume - it worked. Narrowing the 
> initialization code down resulted in this patch.

lol, OK.  I added this to the changelog:

  This fix resets the floppy controller on resume.  It was
  experimentally determined to bring the controller back to life - we
  don't really know why it works.

  floppy_init() does the same thing at boot/modprobe time.

Let's see how it goes...  If someone reports breakage then we can
always change the driver so that activation of your new code requires a
module parameter.
