Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYG3G33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYG3G33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYG3G3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:29:21 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:49121 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYG3G3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:29:21 -0400
Date: Wed, 30 Jul 2008 08:29:19 +0200
From: Bastian Blank <waldi@debian.org>
To: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/lpar - defer prefered console setup
Message-ID: <20080730062919.GA27281@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20080728185651.GA29530@wavehammer.waldi.eu.org> <1217385291.10646.2.camel@localhost> <20080730062313.GA26044@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080730062313.GA26044@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 08:23:13AM +0200, Bastian Blank wrote:
> On Wed, Jul 30, 2008 at 12:34:51PM +1000, Michael Ellerman wrote:
> > On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
> >  * add_preferred_console - add a device to the list of preferred consoles.
> >  ...
> >  * The last preferred console added will be used for kernel messages
> >  * and stdin/out/err for init. 
> > 
> > The last console will be added by the console= parsing, and so that will
> > be used. The console we add in the pseries setup is only used if nothing
> > is specified on the command line.
> 
> Okay, then there is a completely different problem. In the case of
> "console=hvc0 console=hvc1" it uses the _first_ add stdin/out bla and
> ignores the second one completely.

Okay, so hvc_console is the culprit. It don't register a preferred
console if it knows it is not the first in the list.

Bastian

-- 
Intuition, however illogical, is recognized as a command prerogative.
		-- Kirk, "Obsession", stardate 3620.7
