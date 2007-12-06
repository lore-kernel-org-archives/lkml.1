Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXLFVgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXLFVgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXLFVgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:36:41 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55597 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXLFVgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:36:41 -0500
Date: Thu, 6 Dec 2007 22:38:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071206213829.GB24807@uranus.ravnborg.org>
References: <20071204210433.4d7ee66c@osprey.hogchain.net> <20071205210003.GA15366@uranus.ravnborg.org> <20071205213126.43548ccf@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205213126.43548ccf@osprey.hogchain.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 09:31:26PM -0600, Jay Cliburn wrote:
> On Wed, 5 Dec 2007 22:00:03 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Tue, Dec 04, 2007 at 09:04:33PM -0600, Jay Cliburn wrote:
> > > Sam,
> > > 
> > > This piece of the top-level Makefile in current git causes an
> > > out-of-tree driver Makefile to fail.
> > > 
> > > 101 ifdef O
> > > 102   ifeq ("$(origin O)", "command line")
> > > 103     KBUILD_OUTPUT := $(O)
> > > 104   endif
> > > 105 endif
> > > 
> > > The out-of-tree driver Makefile contains an O=... directive that
> > > (correctly) does _not_ specify the kernel source dir, and apparently
> > > isn't overridden by the command line either. If in the above
> > > Makefile snippet I change "command line" to "file", my out-of-tree
> > > make succeeds. What do you think about allowing O= to come from a
> > > file in addition to the command line?
> > 
> > When you change "command line" to "file" you actually makes kbuild
> > ignore the O=... value which is why it succeeds.
> 
> I'm puzzled by your statement.  Isn't the opposite true?  When using
> "command line", doesn't the following happen?
> 
> 1. My makefile sets O=/foo
It does so as an argument to make so it is considered "command line" by make.
> 2. My makefile invokes your makefile with O=/foo
> 3. Your makefile ignores my O=/foo because it requires O=/foo to
> originate from the command line
It comes from the command line in your case.
> 4. KBUILD_OUTPUT never gets set to /foo and we hit the error
We hit the error because kbuild see the srctree and objtree points at the
same directory so outputmakefile will overwrite the kernel Makefile
if it is writeable.

> OTOH, if I use "file":
Then you never get KBUILD_OUTPUT set.
Try adding a:
$(warning origin=$(origin O))
just above the lines with the check that fails.

I will try to fix this during the weeken - but Linux time is sparse these days.

	Sam
