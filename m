Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbXAVWOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbXAVWOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 17:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932245AbXAVWOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 17:14:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:58315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbXAVWOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 17:14:02 -0500
Date: Mon, 22 Jan 2007 23:14:00 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org,
       Alon Bar-Lev <alon.barlev@gmail.com>
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Message-ID: <20070122221400.GE6262@strauss.suse.de>
Mail-Followup-To: Tomas Carnecky <tom@dbservice.com>,
	linux-kernel@vger.kernel.org, Alon Bar-Lev <alon.barlev@gmail.com>
References: <20070118125849.441998000@strauss.suse.de> <20070118130028.719472000@strauss.suse.de> <20070118141359.GB31418@flint.arm.linux.org.uk> <45AF92E7.50901@dbservice.com> <20070118152326.GC31418@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070118152326.GC31418@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King <rmk+lkml@arm.linux.org.uk> [2007-01-18 16:23]:
> On Thu, Jan 18, 2007 at 04:31:51PM +0100, Tomas Carnecky wrote:
> > Russell King wrote:
> > > On Thu, Jan 18, 2007 at 01:58:52PM +0100, Bernhard Walle wrote: 
> > >> -static char command_line[COMMAND_LINE_SIZE];
> > >> +static char __initdata command_line[COMMAND_LINE_SIZE];
> > > 
> > > Uninitialised data is placed in the BSS.  Adding __initdata to BSS
> > > data causes grief.
> > > 
> > 
> > Static variables are implicitly initialized to zero. Does that also
> > count as initialization?
> 
> No.  As I say, they're placed in the BSS.  The BSS is zeroed as part of
> the C runtime initialisation.
> 
> If you want to place a variable in a specific section, it must be
> explicitly initialised.  Eg,
> 
> static char __initdata command_line[COMMAND_LINE_SIZE] = "";

Why? It must be initialised if you rely on a initialised value in the
code. But I don't think that this in in case here. Can you tell me the
code where you read from command_line before writing to it?

Thanks.


Regards,
Bernhard
