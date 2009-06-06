Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZFFGDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZFFGDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZFFGDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:03:36 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34116 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZFFGDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:03:36 -0400
Date: Sat, 6 Jun 2009 08:05:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH 17/39] kbuild: fix header export when __ASSEMBLY__ is used
Message-ID: <20090606060552.GA22347@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org> <1244245377-17441-17-git-send-email-sam@ravnborg.org> <200906060041.07600.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906060041.07600.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 12:41:07AM +0000, Arnd Bergmann wrote:
> On Friday 05 June 2009 11:42:35 pm Sam Ravnborg wrote:
> > Because it does not know __ASSEMBLY__ it does not
> > detect that htis is not for userspace.
> > This caused too much code to be exported, and headers_check barfed
> > over this code.
> > 
> > For arm this fixes following "make headers_check" warning:
> > /usr/include/asm/hwcap.h:29: extern's make no sense in userspace
> 
> Are you sure that this is safe for all user space? If a user application
> for instance includes asm/signal.h or asm/types.h from assembly (for
> whatever reason), it now breaks.

I had not thought about this implication.
I will drop the patch as this most likely
will break some userspace.

	Sam
