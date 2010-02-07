Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0BGX4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 18:56:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51534 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754373Ab0BGX4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:56:52 -0500
Date: Sun, 7 Feb 2010 23:56:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Subject: Re: [PATCH] regulator: Add enable_time on probe of WM8994
Message-ID: <20100207235650.GA14408@opensource.wolfsonmicro.com>
References: <4B6E0C36.3090608@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6E0C36.3090608@samsung.com>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 09:41:26AM +0900, Joonyoung Shim wrote:
> WM8994 regulator needs some delay to enable when it is probed too.

What is the problem that's fixed by this change?

The only case I can think of where it would help is if the regulator
constraints are used to enable the regulators and run them at a
non-default voltage.  (which is not a recommended configuration since
this would mean raising the voltage and therefore increasing power
consumption).  For that case this is not quite enough of a change since
the LDO that is being controlled may not be the one that brings the
device out of power on reset.  More extensive rearrangement of the core
regulator code would be required to deal with that, reordering the
application of constraints.
