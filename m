Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXE1U0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXE1U0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760342AbXE1U0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:26:09 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4990 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbXE1U0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:26:08 -0400
Date: Mon, 28 May 2007 21:25:58 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ARM: Section mismatch warnings
Message-ID: <20070528202558.GG5737@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20070528163253.GA29174@uranus.ravnborg.org> <20070528170430.GB5737@flint.arm.linux.org.uk> <20070528183629.GA30821@uranus.ravnborg.org> <20070528192548.GD5737@flint.arm.linux.org.uk> <20070528195847.GB31233@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528195847.GB31233@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 09:58:47PM +0200, Sam Ravnborg wrote:
> Declaring neponset_probe __init cured it.
> Sorry for posting the wrong patch in the first place.

Arguably, making neponset_probe __devinit and neponset_port_fns
__devinitdata is arguably more correct since any device driver can
be bound and unbound at any time (grumble).

I don't think David's platform_driver_probe() is a proper answer
since it's still possible to unbind the driver, leaving no way to
re-bind.  IOW, it only solves half the problem.  Really, the
allowance of bind/unbind should be a per-driver and per-bus thing
imho.  That's for a separate discussion though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
