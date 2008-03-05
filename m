Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbYCEVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbYCEVqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761018AbYCEVqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:46:00 -0500
Received: from hall.aurel32.net ([88.191.38.19]:46327 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759179AbYCEVp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:45:59 -0500
Message-ID: <47CF146B.6090905@aurel32.net>
Date: Wed, 05 Mar 2008 22:45:15 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Richard Guenther <richard.guenther@gmail.com>
CC: Joe Buck <Joe.Buck@synopsys.com>, Michael Matz <matz@suse.de>,
       Jan Hubicka <hubicka@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <20080305153020.GA24631@volta.aurel32.net>	 <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com>	 <20080305202319.GA17053@volta.aurel32.net>	 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>	 <20080305204234.GB17267@synopsys.com>	 <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>	 <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>	 <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
In-Reply-To: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guenther a écrit :
> On Wed, Mar 5, 2008 at 10:20 PM, Joe Buck <Joe.Buck@synopsys.com> wrote:
>>
>>  On Wed, 5 Mar 2008, Jan Hubicka wrote:
>>  > > Linux kernel is disabling red zone and use kernel code model, yet the
>>  > > ABI is not going to be adjusted for that.
>>  > >
>>  > > This is resonably easy to fix on kernel side in signal handling, or by
>>  > > removing std usage completely
>>
>>  On Wed, Mar 05, 2008 at 10:02:07PM +0100, Michael Matz wrote:
>>  > That is true.  But it requires updating the kernel to a fixed one if you
>>  > want to run your programs compiled by 4.3 :-/  Not something we'd like to
>>  > demand.
>>
>>  I changed the title just for emphasis.
>>
>>  I think that we can't ship 4.3.0 if signal handlers on x86/x86_64
>>  platforms for both Linux and BSD systems will mysteriously (to the users)
>>  fail, and it doesn't matter whose fault it is.
> 
> We didn't yet run into this issue and build openSUSE with 4.3 since more than
> three month.
> 

The problem can be easily reproduced by using a glibc built with gcc
4.3, with SBCL (the gcc version doesn't matter). The signal handler in
SBCL calls sigemptyset() which uses memset().


-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
