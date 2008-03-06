Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYCFJqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYCFJqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYCFJqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:46:21 -0500
Received: from aun.it.uu.se ([130.238.12.36]:41840 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903AbYCFJqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:46:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18383.48432.414612.650004@harpo.it.uu.se>
Date: Thu, 6 Mar 2008 10:45:20 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: Joe Buck <Joe.Buck@synopsys.COM>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
In-Reply-To: <20080305202319.GA17053@volta.aurel32.net>
References: <20080305153020.GA24631@volta.aurel32.net>
	<47CEC3AA.6080709@zytor.com>
	<20080305195834.GA17267@synopsys.com>
	<20080305202319.GA17053@volta.aurel32.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aurelien Jarno writes:
 > On Wed, Mar 05, 2008 at 11:58:34AM -0800, Joe Buck wrote:
 > > 
 > > Aurelien Jarno wrote:
 > > > >Since version 4.3, gcc changed its behaviour concerning the x86/x86-64 
 > > > >ABI and the direction flag, that is it now assumes that the direction 
 > > > >flag is cleared at the entry of a function and it doesn't clear once 
 > > > >more if needed.
 > > > >...
 > > > >I guess this has to be fixed on the kernel side, but also gcc-4.3 could
 > > > >revert back to the old behaviour, that is clearing the direction flag
 > > > >when entering a routine that touches it until most people are running a
 > > > >fixed kernel.
 > > 
 > > On Wed, Mar 05, 2008 at 08:00:42AM -0800, H. Peter Anvin wrote:
 > > > Linux should definitely follow the ABI.  This is a bug, and a pretty 
 > > > serious such.
 > > 
 > > Unfortunately, there are a lot of kernels out there already with this
 > > problem, and the symptoms are likely to be subtle.  So even if it is true
 > > that it is the kernel that is "in the wrong", I think we still are going
 > > to need to give users a workaround from the gcc side as well.
 > > 
 > > So I think gcc at least needs an *option* to revert to the old behavior,
 > > and there's a good argument to make it the default for now, at least for
 > > x86/x86-64 on Linux.
 > 
 > And for other kernels. I tested OpenBSD 4.1, FreeBSD 6.3, NetBSD 4.0,
 > they have the same behaviour as Linux, that is they don't clear DF
 > before calling the signal handler.

FWIW, Solaris 10 (both 32- and 64-bit) gets it right.
