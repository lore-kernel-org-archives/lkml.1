Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbYD3TDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbYD3TDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759855AbYD3TDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:03:42 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7222 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759486AbYD3TDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:03:41 -0400
Subject: Re: [patch, -git] isdn: hysdn_procconf.c build fix
From: "Denis V. Lunev" <den@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080430114731.7e71f3d2.akpm@linux-foundation.org>
References: <1207653508.7171.18.camel@iris.sw.ru>
	 <1207653576-12640-25-git-send-email-den@openvz.org>
	 <20080430175740.GA26612@elte.hu>
	 <20080430111052.9c0c8974.akpm@linux-foundation.org>
	 <20080430183051.GA3008@elte.hu>
	 <20080430114731.7e71f3d2.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Wed, 30 Apr 2008 23:03:05 +0400
Message-Id: <1209582185.4310.1.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 11:47 -0700, Andrew Morton wrote:
> On Wed, 30 Apr 2008 20:30:51 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 30 Apr 2008 19:57:40 +0200
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > Ob'grumpy: this file was not even build-tested by any of the parties 
> > > > who turned it into upstream commit ac41cfd19b ("isdn: use non-racy 
> > > > method for proc entries creation").
> > > 
> > > That's because this stupidity:
> > > 
> > > config HYSDN
> > >         tristate "Hypercope HYSDN cards (Champ, Ergo, Metro) support (module only)"
> > >         depends on m && PROC_FS && PCI && BROKEN_ON_SMP
> > > 
> > > breaks allmodconfig coverage testing.
> > 
> > yeah. There's a trick though that we use in the x86 tree (and which i'm 
> > using in a script when queuing up new patches). The following command 
> > will punch through any Kconfig black holes:
> > 
> >   make drivers/isdn/hysdn/hysdn_procconf.o
> 
> That's daft, sorry.  We shouldn't expect everyone to do stuff like that.
> 
> > (it wont always work as it needs a halfways reasonable .config, but it 
> > works well enough to be part of my workflow.)
> > 
> > note that there's tons more stuff and dependencies that plain 
> > allmodconfig does not catch - in this merge window alone i'm at around 
> > 20 fixes so far.
> 
> allmodconfig is for one thing and one thing only: compilation coverage
> testing.  If there is anything which is not compiled after `make
> allmodconfig' then that's a bug.
> 
> But how to fix it?  Perhaps we need to add a CONFIG_ALLFOOCONFIG which can
> be tested at the appropriate places.

I think that the same should be applied to allyesconfig

