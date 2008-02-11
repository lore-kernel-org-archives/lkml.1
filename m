Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbYBKLca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbYBKLca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYBKLcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:32:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbYBKLcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:32:15 -0500
Date: Mon, 11 Feb 2008 06:32:06 -0500
From: Alan Cox <alan@redhat.com>
To: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@redhat.com, jeff@garzik.org
Subject: Re: [PATCH] libata: Forcing PIO0 mode on reset must not freeze system
Message-ID: <20080211113206.GD28762@devserv.devel.redhat.com>
References: <20080210195556.GA5261@homac> <47AFB4DB.1000204@gmail.com> <20080211102907.GC4646@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211102907.GC4646@homac.suse.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:29:07AM +0100, Holger Macht wrote:
> > In the above example, even the reset sequence itself can cause hang if
> > the hardware is implemented slightly differently.  The reason why
> > set_piomode() locks up but reset sequence doesn't is simple dumb luck.
> 
> Another thing, whether it's poor luck or not, it worked like this than at
> least 2.6.22. And it was _heavily_ tested. The above commit broke it
> between 2.6.24-rc1 and 2.6.24-rc2, which is at least a regression.

Not neccessarily. It may just be timing chance on your box.

I agree however we should be doing the reset after the PIO0 switch if it
turns out that the precise order of the two events matters.

Alan

