Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887Ab0ADTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0ADTzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810Ab0ADTzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:55:19 -0500
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:54415 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752984Ab0ADTzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:55:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=b6SOqTiMeUT9eL7MhacBOurVfHcGsHYZs51nwAcMezu88ZPf5C678xtnkf6tvO1Ph7ue1Y7U5NH9sAqW6j4WbfGbKYSaTuU6tKs+WPeoDqmsgO8LyAeA6Fxd67SneuHb;
Date: Mon, 4 Jan 2010 11:55:14 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: Clean up build for CONFIG_PCI_QUIRKS unset
Message-ID: <20100104115514.22f953ec@jbarnes-piketon>
In-Reply-To: <20100104083401.7d282505@jbarnes-piketon>
References: <201001022257.24701.rjw@sisk.pl>
	<20100104083401.7d282505@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 08:34:01 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Sat, 2 Jan 2010 22:57:24 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Currently, drivers/pci/quirks.c is built unconditionally, but if
> > CONFIG_PCI_QUIRKS is unset, the only things actually built in this
> > file are definitions of global variables and empty functions (due to
> > the #ifdef CONFIG_PCI_QUIRKS embracing all of the code inside the
> > file).  This is not particularly nice and if someone overlooks
> > the #ifdef CONFIG_PCI_QUIRKS, build errors are introduced.
> > 
> > To clean that up, move the definitions of the global variables in
> > quirks.c that are always built to pci.c, move the definitions of
> > the empty functions (compiled when CONFIG_PCI_QUIRKS is unset) to
> > headers (additionally make these functions static inline) and modify
> > drivers/pci/Makefile so that quirks.c is only built if
> > CONFIG_PCI_QUIRKS is set.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> > I thought it might be useful to do something like this.
> > 
> > Please let me know what you think.
> 
> Thanks Rafael, I actually had a fix for this already from Dexuan, but
> I guess Linus applied yours instead.
> 
> Thanks for the fix.
> 

Oops this is a cleanup of the fix.  Will queue it up.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
