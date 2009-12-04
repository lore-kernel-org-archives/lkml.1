Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZLDHiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZLDHiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZLDHiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:38:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZLDHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:38:01 -0500
Date: 04 Dec 2009 08:37:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: dmitry.torokhov@gmail.com
Cc: awalls@radix.net
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BEFg1n2mqgB@lirc>
In-Reply-To: <20091203221231.GE776@core.coreip.homeip.net>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/ENIatabofSLB78uQjuxCU+VwJilufvoIT/OV
 tjYaaGyztxniFB9EOmvEeclNJRMGGuZdO9r2pvXcDpKU1LiAmJ
 Qy5ljU2iOQXKHbA0oez3xQJ2nBuTNVk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

on 03 Dec 09 at 14:12, Dmitry Torokhov wrote:
[...]
>> Consider passing the decoded data through lirc_dev.
[...]
> I believe it was agreed that lirc-dev should be used mainly for decoding
> protocols that are more conveniently decoded in userspace and the
> results would be looped back into input layer through evdev which will
> be the main interface for consumer applications to use.

Quoting myself:
> Currently I would tend to an approach like this:
> - raw interface to userspace using LIRC

For me this includes both the pulse/space data and also the scan codes  
when hardware does the decoding.
Consider cases like this:
http://lirc.sourceforge.net/remotes/lg/6711A20015N

This is an air-conditioner remote.
The entries that you see in this config file are not really separate  
buttons. Instead the remote just sends the current settings for e.g.  
temperature encoded in the protocol when you press some up/down key. You  
really don't want to map all possible temperature settings to KEY_*  
events. For such cases it would be nice to have access at the raw scan  
codes from user space to do interpretation of the data.
The default would still be to pass the data to the input layer, but it  
won't hurt to have the possibility to access the raw data somehow.

Christoph
