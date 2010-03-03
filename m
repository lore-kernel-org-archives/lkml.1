Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0CCCTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 21:19:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53469 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab0CCCTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 21:19:02 -0500
Date: Tue, 2 Mar 2010 18:19:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in
	git tree
Message-ID: <20100303021901.GF6786@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100301042249.GA12289@linux.vnet.ibm.com> <201003021619.34793.elendil@planet.nl> <20100303000134.GD6786@linux.vnet.ibm.com> <201003030142.43310.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201003030142.43310.elendil@planet.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 01:42:41AM +0100, Frans Pop wrote:
> On Wednesday 03 March 2010, Paul E. McKenney wrote:
> > > Wouldn't it be more logical to include the line in the dmesg output?
> > > My preference would be a separate line below the existing (Linux
> > > version) line. That line could only be output if the kernel was built
> > > from a VCS. It could then even be repeated in oops output.
> >
> > My concern with only putting it in the dmesg output is that people do
> > not always capture that.  The oops output is more often captured, but
> > the kernel only has this information if CONFIG_LOCALVERSION_AUTO is set.
> 
> Yes, my suggestion is exactly because IMO it should be independent of 
> CONFIG_LOCALVERSION_AUTO.
> 
> I hugely dislike that option because it makes the git version part of the 
> kernel version and thus affects how the kernel gets installed (names of 
> files in /boot, name of the directory in /lib/modules, name of the Debian 
> package created using the deb-pkg target, etc.).
> For all those things I want a "clean" kernel version and thus I will never 
> enable CONFIG_LOCALVERSION_AUTO.

That does sound a bit painful...

> But I do see the value of a reliable and consistent identification of what 
> exact source a kernel was built from. Including the git version separately 
> from the kernel version would allow that.

Fortunately, scripts/setlocalversion seems to run quite a bit faster the
second time I run it, probably due to various caches having been warmed
up the first time.  Because doing all of this straightforwardly means up
to three invocations in a given kernel build.  ;-)

							Thanx, Paul
