Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbZEAQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbZEAQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZEAQQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:16:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZEAQQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:16:18 -0400
Date: Fri, 1 May 2009 18:16:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Oliver Neukum <oliver@neukum.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: What's in hid.git for 2.6.30
In-Reply-To: <200905011809.19971.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.0905011812330.22532@wotan.suse.de>
References: <alpine.LNX.2.00.0903251742520.14346@wotan.suse.de> <200905011102.18945.oliver@neukum.org> <alpine.LNX.2.00.0905011751180.5012@wotan.suse.de> <200905011809.19971.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Oliver Neukum wrote:

> > If driven by usbhid, the only way how keyboard could be handled if not
> > claimed by hid-input is a userspace hiddev or hidraw driver. And we don't
> > suspend if hidraw/hiddev node is open, right?
> What happens if the node is closed? 

That's up to the userspace driver. If it is an input driver, it is 
probably using uinput to inject events into the input system, and 
therefore should properly unregister itself also from uinput together with 
closing the node.

> Will hid forget that a key had been pressed? I must admit that I can't 
> tell where in hid the key repetition logic is located.

The repetition is fully handled in the input core, not in the hid-input 
driver. So if the device is not handled by hid-input, we (the kernel 
driver) haven't registered with the input subsystem, and therefore no 
events go to input subsystem at all.

-- 
Jiri Kosina
SUSE Labs
