Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYG2IIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYG2IIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYG2IHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:07:32 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:35590 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbYG2IHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:07:30 -0400
Date: Tue, 29 Jul 2008 10:07:27 +0200
From: Bastian Blank <waldi@debian.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/lpar - defer prefered console setup
Message-ID: <20080729080727.GA32595@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20080728185651.GA29530@wavehammer.waldi.eu.org> <1217300778.11188.233.camel@pasglop> <20080729073611.GA30627@wavehammer.waldi.eu.org> <1217317404.11188.242.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1217317404.11188.242.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 05:43:24PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2008-07-29 at 09:36 +0200, Bastian Blank wrote:
> > On Tue, Jul 29, 2008 at 01:06:18PM +1000, Benjamin Herrenschmidt wrote:
> > > On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
> > > > Hi
> > > > 
> > > > The powerpc lpar code adds a prefered console at a very early state,
> > > > during arch_setup. This runs even before the console setup from the
> > > > command line and takes preference.
> > > > 
> > > > This patch moves the prefered console setup into an arch_initcall which
> > > > runs later and allows the specification of the correct console on the
> > > > command line. The udbg console remains as boot console.
> > > > 
> > > Shouldn't it be a console_initcall() ? 
> > 
> > No. console_initcall is for the initial console setup and runs way long
> > before the command line setup. It needs to run after that.
> 
> Hrm... we do most of the console discovery from console_initcall for
> legacy UARTs. see the code in legacy_serial.c, we just avoid doing
> the add_preferred_console() thingy if there's a console= on the command
> line :-)

The code did that, but the check was removed because it trips on
netconsole=. See 5faae2e5d1f53df9dce482032c8486bc3a1feffc.

Bastian

-- 
The heart is not a logical organ.
		-- Dr. Janet Wallace, "The Deadly Years", stardate 3479.4
