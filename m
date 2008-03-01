Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYCAMiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYCAMiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 07:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYCAMh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 07:37:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:32927 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYCAMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 07:37:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 1 Mar 2008 13:36:05 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] firewire: endianess fix
To: linux1394-devel@lists.sourceforge.net
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>,
       Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <47C00DB0.20605@s5r6.in-berlin.de>
Message-ID: <tkrat.8be5d3017a57e1f0@s5r6.in-berlin.de>
References: <20080220220326.GA22328@uranus.ravnborg.org>
 <1203545913.25307.47.camel@brick> <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
 <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
 <47C00DB0.20605@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Feb, I wrote:
>> This needs to be tested on different big endian PCs, if possible with
>> the Apple Uninorth FireWire controller and other types of controllers.

I tested it myself now with VT6306 on PPC32.

> it should be triggered by replacing
> 	&fw_high_memory_region
> by
> 	&fw_private_region
> in drivers/firewire/fw-sbp2.c and testing with any SBP-2 device

This indeed demonstrates the fix.  Any IO to SBP-2 devices fails with
timeouts.  Just removing the posted write enable bit in fw-ohci wasn't
sufficient to catch it though.  Maybe the controller has write posting
enabled by default.

However, this endianess bug was low-profile because there are currently
no kernelspace or userspace drivers for the firewire stack which need to
respond in split transactions.
-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/

