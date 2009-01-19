Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZASP3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZASP3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 10:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZASP3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 10:29:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39267 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751511AbZASP3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 10:29:23 -0500
Date: Mon, 19 Jan 2009 15:29:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Regulator: Add a voltage changed event to notify
	consumers
Message-ID: <20090119152921.GA23444@rakim.wolfsonmicro.main>
References: <495FD46E.8040208@cam.ac.uk> <1231065078.11643.116.camel@vega.slimlogic.co.uk> <4973793D.60803@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4973793D.60803@cam.ac.uk>
X-Cookie: BELA LUGOSI is my co-pilot ...
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 06:47:25PM +0000, Jonathan Cameron wrote:

> -out:
> +	mutex_unlock(&rdev->mutex);
> +	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
> +	return 0;
> +out_unlock:

It'd be nice if we could modify _notifier_call_chain() to push the 
locking out a bit so we don't need to drop the lock before calling the
notifier.  On the other hand, for anything that isn't memory mapped or
GPIO controlled (most regulators are in this category) the cost of the
I/O is going to make this a non-issue.
