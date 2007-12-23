Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbXLWUIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbXLWUIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXLWUHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:07:55 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44858 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbXLWUHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:07:54 -0500
Date: Sun, 23 Dec 2007 21:09:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20071223200946.GA21826@uranus.ravnborg.org>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071223130029.GA6815@elte.hu> <200712231448.33882.rjw@sisk.pl> <200712231453.35497.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712231453.35497.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 02:53:34PM +0100, Rafael J. Wysocki wrote:
> On Sunday, 23 of December 2007, Rafael J. Wysocki wrote:
> > On Sunday, 23 of December 2007, Ingo Molnar wrote:
> > > 
> > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > 
> > > > Well it doesn't build on x86-64 for me:
> > > > 
> > > >   CHK     include/linux/compile.h
> > > >   CC      arch/x86/ia32/../../../fs/compat_binfmt_elf.o
> > > > Assembler messages:
> > > > Fatal error: can't create arch/x86/ia32/../../../fs/.tmp_compat_binfmt_elf.o: No such file or directory
> > > > make[2]: *** [arch/x86/ia32/../../../fs/compat_binfmt_elf.o] Error 2
> > > > 
> > > > I will post the .config if anyone is interested.
> > > 
> > > yes, please send the .config.
> > 
> > Attached.
> > 
> > It also may be relevant that I compile the kernel with "make O=../build".
> 
> I ran the compilation once again and it worked.  Strange.
Try to delete your fs/ directory in your output dir.
Then I expect the same bug to surface again.

I guess it is because arch/x86/ia32/ is built before fs/ and
gcc cannot create directories for the output files and
it is the dependency files that triggers the error as this
is the first file to be generated.
The right fix is to move the build of compat_binfmt_elf to
fs/Makefile as already discussed.

	Sam
