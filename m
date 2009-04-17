Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbZDQNJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbZDQNJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZDQNJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:09:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZDQNJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:09:08 -0400
Date: Fri, 17 Apr 2009 15:12:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [22/28] x86: MCE: Default to panic timeout for machine checks
Message-ID: <20090417131214.GM14687@one.firstfloor.org>
References: <20090407507.636692542@firstfloor.org> <20090407150805.588AA1D046D@basil.firstfloor.org> <49E866E0.2090007@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E866E0.2090007@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 08:24:16PM +0900, Hidetoshi Seto wrote:
> Andi Kleen wrote:
> > Fatal machine checks can be logged to disk after boot, but only if
> > the system did a warm reboot. That's unfortunately difficult with the
> > default panic behaviour, which waits forever and the admin has to
> > press the power button because modern systems usually miss a reset button.
> > This clears the machine checks in the registers and make
> > it impossible to log them.
> > 
> > This patch changes the default for machine check panic to always
> > reboot after 30s. Then the mce can be successfully logged after
> > reboot.
> 
> In case if user already set panic_timeout to 5s, the that user need to
> wait extra 25s for machine check panic... ?

That's true. I'll fix that.

> 
> The idea is good, but I think some switch like "no_reboot_on_mce" would
> be required.

mce=nobootlog should do that.
If someone feels strongly I can add a separate switch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
