Return-Path: <linux-kernel-owner+w=401wt.eu-S937412AbYEUVdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937412AbYEUVdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYEUVdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:33:40 -0400
Received: from mail.queued.net ([207.210.101.209]:4477 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbYEUVdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:33:39 -0400
Date: Wed, 21 May 2008 17:38:32 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080521173832.68e9d267@ephemeral>
In-Reply-To: <20080521211139.GA22591@codemonkey.org.uk>
References: <20080429183531.GB19652@uranus.ravnborg.org>
	<20080502190949.GA30270@uranus.ravnborg.org>
	<20080521164703.61c7d715@ephemeral>
	<20080521211139.GA22591@codemonkey.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 17:11:39 -0400
Dave Jones <davej@codemonkey.org.uk> wrote:

> On Wed, May 21, 2008 at 04:47:03PM -0400, Andres Salomon wrote:
> 
>  > > 3) Implement newsymbolsconfig (any better name?)
>  > >    Shall list all new symbols and shall not write
>  > >    any config
>  > 
>  > I'm not sure I see the point of #3.
> 
> It's something we've had in Fedora kernels forever, because
> when rebasing to a new upstream version the process becomes
> 
> make newsymbolsconfig
> take list of symbols, and make decisions on them
> make oldconfig
> 
>

Ah, I see.  My process has always been:


cp arch/x86/configs/foo_defconfig .config
make oldconfig
make obvious decisions about new symbols, choose defaults if unknown
diff -u arch/x86/configs/foo_defconfig .config
figure out if any decisions or defaults are incorrect, change accordingly
make oldconfig (more decisions if there are new symbols exposed)
cp .config arch/x86/configs/foo_defconfig && commit


> without it, the process would be..
> 
> make oldconfig
> note new symbol, make decision
> make oldconfig
> note a 2nd new symbol, make decision
> make oldconfig
> note a 3rd new symbol..
> make oldconfig..
> you get the idea.
> 
> The way we have it isn't perfect, (adding a new symbol may unhide
> another set of new symbols), but it reduces the number of iterations
> needed dramatically.
> 
> 	Dave
> 

My build has broken again, which is why I'm inquiring about the status
of this; I'm not going to bother fixing it if my patches are never going
to end up upstream..

