Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbXESSUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbXESSUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbXESSUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:20:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58621 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758195AbXESSUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:20:45 -0400
Date: Sat, 19 May 2007 11:20:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Indan Zupancic <indan@nul.nu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG: 2.6.22-rc2] SLAB doesn't like usb_get_configuration()
In-Reply-To: <3642.81.207.0.53.1179584891.squirrel@secure.samage.net>
Message-ID: <Pine.LNX.4.64.0705191119460.17008@schroedinger.engr.sgi.com>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
 <3642.81.207.0.53.1179584891.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007, Indan Zupancic wrote:

> I had two SLAb related bugs, both with usb_get_configuration()
> near the end of the backtrace. First one was with git between
> rc1 and rc2, but very close to rc2, second one was with rc2,
> both at bootup.

Well usb_get_configuration seems to do a kmalloc(0) which is a bit 
strange and this is why we flagged the allocation in the slab allocators. 
Is there some way to avoid allocating an object of zero length?
