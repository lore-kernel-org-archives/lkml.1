Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZFVPvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZFVPvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZFVPuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:50:55 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:63315 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325AbZFVPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:50:55 -0400
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090622154308.GC29188@n2100.arm.linux.org.uk>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
	 <20090619134446.GI24573@n2100.arm.linux.org.uk>
	 <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
	 <20090622154308.GC29188@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 22 Jun 2009 16:50:46 +0100
Message-Id: <1245685846.15580.107.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 15:50:47.0632 (UTC) FILETIME=[35BE1500:01C9F351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 16:43 +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 22, 2009 at 07:43:40PM +0530, Sudeep K N wrote:
> > Thanks for the suggestion.
> > With the logs it is clear that crash is in the userspace.
> > I am getting one of the 2 logs(below) randomly.
> > >From trial#2,
> > pgd = c60bc000
> > [00000000] *pgd=061ee031, *pte=00000000, *ppte=00000000
> > I could understand that the page tables are not proper.
> > I am not able understand how to proceed.
> > 
> > Trial#1:
> > VFS: Mounted root (ext2 filesystem).
> > Freeing init memory: 108K
> > linuxrc (1): undefined instruction: pc=40008100
> > Code: e08e3003 eb002842 e2801008 e58c217c (e0812103)
> 
> Your processor is misbehaving; none of the above hex codes are undefined
> instructions, so you shouldn't be taking an undefined instruction trap.

The undefined instruction aborts are possible in this situation since
instructions are fetched via the I-cache while the abort handler shows
the code via the D-cache.

-- 
Catalin

