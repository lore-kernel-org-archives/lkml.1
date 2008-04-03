Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYDCEY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYDCEY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 00:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYDCEYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 00:24:17 -0400
Received: from ozlabs.org ([203.10.76.45]:49837 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYDCEYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 00:24:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18420.22563.895489.490165@cargo.ozlabs.ibm.com>
Date: Thu, 3 Apr 2008 15:08:03 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc8
In-Reply-To: <alpine.LFD.1.00.0804020748100.14670@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org>
	<18418.44094.156352.405647@cargo.ozlabs.ibm.com>
	<alpine.LFD.1.00.0804020748100.14670@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> Well, that part isn't the one that I think is bothersome - I just wonder 
> if the whole "defconfig" mess is worth keeping with the kernel at _all_.
> 
> It also causes tons of noise whenever I happen to do something like "git 
> grep CONFIG_XYZZY" to see where some config variable is used etc.
> 
> So I was more wondering whether maybe there could be better ways of doing 
> that whole thing. 

Having the defconfigs seems to be useful for the embedded folks,
judging by the number of defconfigs they have.  They generally have a
defconfig for each reference board.

Those defconfigs would be much smaller and change much less often if
they could be expressed as a delta from some other defconfig.  So we'd
end up with a small number of base defconfigs plus a set of board
defconfigs that would say effectively "use the options from that other
defconfig, plus turn this on and that off".

On the whole, I think defconfigs are useful because we have so many
configuration options, and the defaults and help texts for many of the
options are not always helpful.

We could possibly do without defconfigs if we put effort into making
sure that all the "depends" and "default" values in all the Kconfig
files are sensible.  Ideally, a user could select something like
"32-bit powermac support" and take the defaults for everything else,
and get something sensible for a 32-bit powermac.  We're not at that
point, and I think it would take considerable effort to get there.

I would like to see something better than what we have at the moment
(whether one of the two ideas above, or something else) because I find
maintaining the defconfigs a bit of a pain myself.

Paul.
