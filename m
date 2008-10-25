Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYJYGwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYJYGwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 02:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYJYGwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 02:52:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYJYGwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 02:52:34 -0400
Date: Sat, 25 Oct 2008 09:00:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MCEs
Message-ID: <20081025070013.GJ27492@one.firstfloor.org>
References: <20081024124502.GA9425@codeblau.de> <87r66598eq.fsf@basil.nowhere.org> <20081024230748.GA21365@codeblau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024230748.GA21365@codeblau.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 01:07:48AM +0200, Felix von Leitner wrote:
> > It's some sort of hardware problem, debugging it typically
> > either involves fixing the cooling or exchanging components.
> 
> Using an older kernel I get actual MCE messages that I can write down
> and decode using mcelog.

You mean when you switch back to the old kernel it's recoverable
and then switch to the new kernel it is not?

If yes then bisect it please.

> 
> It looks like the MCE handler is buggy in current kernels and will cause
> a panic instead of the MCE messages (or maybe in addition to and the

The CPU tells the kernel if a machine check should cause a panic or not.
Usually when you actually get an MC _E_xception it's panic time.

> panic obscures them by scrolling them out of my 80x25 screen).

Panic should be one line, unless you're bitten by the 2.6.27 
smp_call_function in panic bug (see 
http://bugzilla.kernel.org/show_bug.cgi?id=11569)

Please post concrete logs from a serial or netconsole.

-Andi

-- 
ak@linux.intel.com
