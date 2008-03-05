Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbYCEUiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbYCEUiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYCEUiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:38:15 -0500
Received: from mx1.suse.de ([195.135.220.2]:53095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbYCEUiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:38:15 -0500
Date: Wed, 5 Mar 2008 21:38:13 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: Joe Buck <Joe.Buck@synopsys.COM>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
In-Reply-To: <20080305202319.GA17053@volta.aurel32.net>
Message-ID: <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com>
 <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 5 Mar 2008, Aurelien Jarno wrote:

> > So I think gcc at least needs an *option* to revert to the old behavior,
> > and there's a good argument to make it the default for now, at least for
> > x86/x86-64 on Linux.
> 
> And for other kernels. I tested OpenBSD 4.1, FreeBSD 6.3, NetBSD 4.0, 
> they have the same behaviour as Linux, that is they don't clear DF 
> before calling the signal handler.

Sigh.  We could perhaps insert a cld for all functions which can be 
recognized as possible signal handlers and call other unknown or string 
functions.  But it's probably even faster to emit cld in front of the 
inline copies of mem functions again :-(


Ciao,
Michael.
