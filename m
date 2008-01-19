Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbYASEhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbYASEhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761897AbYASEhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:37:45 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:1799 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761697AbYASEho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:37:44 -0500
Date: Sat, 19 Jan 2008 05:36:47 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jan Beulich <jbeulich@novell.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
Subject: Re: non-choice related config entries within choice
In-Reply-To: <478DF61E.76E4.0078.0@novell.com>
Message-ID: <Pine.LNX.4.64.0801171803000.17507@scrub.home>
References: <478DF61E.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 16 Jan 2008, Jan Beulich wrote:

> now that I finally found time to look into the problems that caused the
> patch changing boolean/tristate choice behavior to be reverted I find
> that due to the way things worked in the past there are a couple of
> cases where config options not really belonging to the choice are inside
> the choice scope (drivers/usb/gadget/Kconfig, arch/ppc/Kconfig, and
> arch/mips/Kconfig are where I found such cases, and I hope this is a
> complete list).
> 
> The question is: Is it intended for this to work the way it used to, or
> is it rather reasonable to change these scripts so that stuff dependent
> upon the choice selection is being dealt with outside the choice scope?

This is really a feature, try it with a visible option there which depends 
on a choice option.
First for the choice type I think it's simpler to just look at the first 
choice option, anything more complex simply has to specify the type 
explicitly.

The bigger problem is that menu_finalize() is little complex which makes 
such changes more difficult, basically it does two things (updating the 
dependencies and generating the menu structure) in one pass and it depends 
on a specific order, which is nonobvious. I really should clean this up to 
make it easier to follow what's happening.
For now this means the dependency to the choice symbol has to be added a 
little later right before the call to menu_add_symbol().

bye, Roman
