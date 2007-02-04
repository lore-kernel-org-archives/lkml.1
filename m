Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbXBDDMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbXBDDMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 22:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXBDDMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 22:12:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbXBDDMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 22:12:24 -0500
Date: 04 Feb 2007 04:03:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: penberg@cs.helsinki.fi
cc: linux-kernel@vger.kernel.org
Message-ID: <AAEiymxMB9B@bartelmus.de>
In-Reply-To: <Pine.LNX.4.64.0702021038270.21422@sbz-30.cs.Helsinki.FI>
Subject: Re: [PATCH] lirc: remove backwards compatibility macro obfuscation
User-Agent: OpenXP/4.0.7330 (Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:284c5d0e30cf020a3f9a09292c25b7b4
X-Provags-ID2: V01U2FsdGVkX1/+3DQgoggF5ay9dSdmjvpVUUwJ/dD2gYTNdEIpHGWmFCtodDaopVJw5GmDfaMzCngiqVAxlG/2cj/DPf6QuMXTdg3OPBPNQsI+nhd9tGgO6TVk/ySvHHr/
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

on 02 Feb 07 at 10:39, you wrote:
[...]
> On 02 Feb 2007 05:54:00 +0100, Christoph Bartelmus <lirc@bartelmus.de>
> wrote:
>> Any help welcome.

> Here's a start.

As I'm running a 2.4 kernel myself you will probably understand that I  
am a bit reluctant to drop 2.4 support from LIRC right now.

Possible ways to handle this:
1. lirc-0.8.2 will be the last release officially supporting 2.4. I  
remove backwards compatibility after this release.
2. I create a CVS branch for 2.6 only version.

Drawbacks of 1.: also support for some older 2.6 kernels would have to  
be dropped as there have been API changes in 2.6 kernels.

Drawbacks of 2.: have to maintain 2 branches in parallel for some time.

But before continuing to discuss the further procedure and minor code  
optimisations you should know which major changes need to be done to  
LIRC drivers before thinking of a merge to the kernel:

1. LIRC requires an official device major number! A minor number system  
should be defined.
2. Some of the drivers need to be rewritten to support more than one  
device at a time. Esp. lirc_serial needs to be rewritten to handle more  
than one serial port in parallel.

Christoph
