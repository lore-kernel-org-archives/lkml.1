Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbYG2Hnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbYG2Hnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYG2Hnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:43:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:34036 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYG2Hnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:43:45 -0400
Subject: Re: [PATCH] powerpc/lpar - defer prefered console setup
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bastian Blank <waldi@debian.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080729073611.GA30627@wavehammer.waldi.eu.org>
References: <20080728185651.GA29530@wavehammer.waldi.eu.org>
	 <1217300778.11188.233.camel@pasglop>
	 <20080729073611.GA30627@wavehammer.waldi.eu.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:43:24 +1000
Message-Id: <1217317404.11188.242.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 09:36 +0200, Bastian Blank wrote:
> On Tue, Jul 29, 2008 at 01:06:18PM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
> > > Hi
> > > 
> > > The powerpc lpar code adds a prefered console at a very early state,
> > > during arch_setup. This runs even before the console setup from the
> > > command line and takes preference.
> > > 
> > > This patch moves the prefered console setup into an arch_initcall which
> > > runs later and allows the specification of the correct console on the
> > > command line. The udbg console remains as boot console.
> > > 
> > Shouldn't it be a console_initcall() ? 
> 
> No. console_initcall is for the initial console setup and runs way long
> before the command line setup. It needs to run after that.

Hrm... we do most of the console discovery from console_initcall for
legacy UARTs. see the code in legacy_serial.c, we just avoid doing
the add_preferred_console() thingy if there's a console= on the command
line :-)

> Yep. Would it be a solution to check this in hvc_vio and hvsi and do the
> calls there? They now that the device is available and the correct
> index. But even then it have to run after the command line. (Or the
> console infrastructure fixed to support more then one device of a type.)

Not sure. The console selection process is just plain weird and I never
really took the time to fully figure it out.

Ben.


