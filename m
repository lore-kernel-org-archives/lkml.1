Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYDCSLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYDCSLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYDCSLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:11:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49779 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbYDCSLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:11:38 -0400
Date: Thu, 3 Apr 2008 20:12:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 01/22] Generic show_mem() implementation
Message-ID: <20080403181202.GA32319@uranus.ravnborg.org>
References: <12071688283927-git-send-email-hannes@saeurebad.de> <1207168839586-git-send-email-hannes@saeurebad.de> <20080403075545.GC4125@osiris.boeblingen.de.ibm.com> <20080403124820.GA30356@uranus.ravnborg.org> <871w5nouwp.fsf@saeurebad.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871w5nouwp.fsf@saeurebad.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 04:49:42PM +0200, Johannes Weiner wrote:
> Hi,
> 
> Sam Ravnborg <sam@ravnborg.org> writes:
> 
> >> e.g. we currently have this in arch/s390/Kconfig:
> >> 
> >> config S390
> >>         def_bool y
> >>         select HAVE_OPROFILE
> >>         select HAVE_KPROBES
> >>         select HAVE_KRETPROBES
> >> 
> >> just add a select HAVE_GENERIC_SHOWMEM or something like that in the arch
> >> specific patches.
> > Seconded.
> > See Documentation/kbuild/kconfig-language.txt for a few more hints
> > how to do it.
> 
> After more thinking about it, wouldn't it be better to have
> HAVE_ARCH_SHOW_MEM in mm/Kconfig and let archs with their own show_mem()
> select it?  Because there are far more archs that use the generic
> version than those having their own.

Positive logic is almost always simpler to grasp.
And the usual way to do this is to let arch's select what they
use.
We do not want to have a situation where in most cases we select
a generic version but in some oddball case we select to have
a local version.

	Sam
