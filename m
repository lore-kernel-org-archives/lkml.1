Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbYJ0Olc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbYJ0Olc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYJ0OlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:41:24 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3948 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYJ0OlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:41:24 -0400
Date: Mon, 27 Oct 2008 15:40:32 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix allmodconfig breakage
In-Reply-To: <20081026051234.GN28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0810271539500.13549@localhost.localdomain>
References: <20081025211107.GA20417@uranus.ravnborg.org>
 <20081026051234.GN28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 26 Oct 2008, Al Viro wrote:

> 	If you use KCONFIG_ALLCONFIG (even with empty file) you get
> broken allmodconfig/allyesconfig; CONFIG_MODULES gets turned off,
> with obvious massive fallout.
> 
> 	Breakage had been introduced when conf_set_all_new_symbols()
> got used for allmodconfig et.al.
> 
> 	What happens is that sym_calc_value(modules_sym) done in
> conf_read_simple() sets SYMBOL_VALID on both modules_sym and MODULES.
> When we get to conf_set_all_new_symbols(), we set sym->def[S_DEF_USER]
> on everything, but it has no effect on sym->curr for the symbols that
> already have SYMBOL_VALID - these are stuck.
> 
> 	Solution: use sym_clear_all_valid() in there.  Note that it
> makes reevaluation of modules_sym redundant - sym_clear_all_valid()
> will do that itself.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks for looking into this.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

bye, Roman
