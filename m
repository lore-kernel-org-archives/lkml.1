Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbXJYVa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbXJYVa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXJYVav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:30:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45862 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbXJYVau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:30:50 -0400
Date: Thu, 25 Oct 2007 23:32:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig: conf segfault (with invalid kconfig contents)
Message-ID: <20071025213225.GB15292@uranus.ravnborg.org>
References: <20071024031401.GA13376@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024031401.GA13376@lixom.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof.

On Tue, Oct 23, 2007 at 10:14:01PM -0500, Olof Johansson wrote:
> Hi,
> 
> Sorry, no patch, just a bugreport. :)
> 
> I did a mistake in some Kconfig changes (locally) and got a segfault
> from conf:
> 
> #0  0x10005fe0 in sym_check_deps ()
> #1  0x10005f40 in sym_check_expr_deps ()
> #2  0x1000605c in sym_check_deps ()
> #3  0x1000f3f4 in conf_parse ()
> #4  0x10003824 in main ()
> 
> 
> The way to reproduce is simple. I just added the equivalent of this
> to arch/powerpc/Kconfig:
> 
> ---
> config TEST1
>         bool
>         depends on TEST2 && PCI
>         select TEST2
> 
> config TEST2
>         bool
> ---
> 
> Neither TEST1 nor TEST2 exists in the existing .config when I run make
> oldconfig to reproduce.
> 
> It's clearly invalid in that it depends on what it selects, but it should
> just abort instead.

Thanks for the report and especially for the testcase!
I will try to look at it a bit later if noone bites me (I'm afraid not). 

	Sam
