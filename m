Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYCEUm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYCEUm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYCEUmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:42:46 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:37200 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYCEUmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:42:45 -0500
Date: Wed, 5 Mar 2008 12:42:34 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: Michael Matz <matz@suse.de>
Cc: Aurelien Jarno <aurelien@aurel32.net>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080305204234.GB17267@synopsys.com>
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 09:38:13PM +0100, Michael Matz wrote:
> Hi,
> 
> On Wed, 5 Mar 2008, Aurelien Jarno wrote:
> 
> > > So I think gcc at least needs an *option* to revert to the old behavior,
> > > and there's a good argument to make it the default for now, at least for
> > > x86/x86-64 on Linux.
> > 
> > And for other kernels. I tested OpenBSD 4.1, FreeBSD 6.3, NetBSD 4.0, 
> > they have the same behaviour as Linux, that is they don't clear DF 
> > before calling the signal handler.
> 
> Sigh.  We could perhaps insert a cld for all functions which can be 
> recognized as possible signal handlers and call other unknown or string 
> functions.  But it's probably even faster to emit cld in front of the 
> inline copies of mem functions again :-(

Yes, if there are four kernels that get it "wrong", that effectively means
that the ABI document doesn't describe reality and gcc has to adjust.
