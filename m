Return-Path: <linux-kernel-owner+w=401wt.eu-S937299AbYEUVMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937299AbYEUVMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYEUVKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:10:36 -0400
Received: from testure.choralone.org ([194.9.77.134]:47373 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937424AbYEUVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:10:32 -0400
Date: Wed, 21 May 2008 17:11:39 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Andres Salomon <dilinger@queued.net>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080521211139.GA22591@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Andres Salomon <dilinger@queued.net>,
	Sam Ravnborg <sam@ravnborg.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Roland McGrath <roland@redhat.com>,
	Roman Zippel <zippel@linux-m68k.org>
References: <20080429183531.GB19652@uranus.ravnborg.org> <20080502190949.GA30270@uranus.ravnborg.org> <20080521164703.61c7d715@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521164703.61c7d715@ephemeral>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 04:47:03PM -0400, Andres Salomon wrote:

 > > 3) Implement newsymbolsconfig (any better name?)
 > >    Shall list all new symbols and shall not write
 > >    any config
 > 
 > I'm not sure I see the point of #3.

It's something we've had in Fedora kernels forever, because
when rebasing to a new upstream version the process becomes

make newsymbolsconfig
take list of symbols, and make decisions on them
make oldconfig


without it, the process would be..

make oldconfig
note new symbol, make decision
make oldconfig
note a 2nd new symbol, make decision
make oldconfig
note a 3rd new symbol..
make oldconfig..
you get the idea.

The way we have it isn't perfect, (adding a new symbol may unhide
another set of new symbols), but it reduces the number of iterations
needed dramatically.

	Dave

-- 
http://www.codemonkey.org.uk
