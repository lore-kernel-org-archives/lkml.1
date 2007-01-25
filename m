Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXAYNhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXAYNhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965349AbXAYNhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:37:22 -0500
Received: from twin.jikos.cz ([213.151.79.26]:47581 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXAYNhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:37:21 -0500
Date: Thu, 25 Jan 2007 14:37:02 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Markku Savela <msa@moth.iki.fi>
cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: How to get /dev entry created automaticly for dynamic major
 number?
In-Reply-To: <200701251311.l0PDBFD0025319@moth.iki.fi>
Message-ID: <Pine.LNX.4.64.0701251425320.21127@twin.jikos.cz>
References: <200701250735.l0P7Z7aN018630@moth.iki.fi> <20070125082544.GA16300@kroah.com>
 <200701251311.l0PDBFD0025319@moth.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007, Markku Savela wrote:

> Thanks! The solution seems to work. The final *obstacle* was, that
> class_* symbols were not available until I added the
> LICENSE("GPL"). Here is the resulting template, maybe useful for
> someone, and just for verification, that I got it right.
> static struct class_device *foo_device;
[...]
>     foo_device = class_device_create(foo_class, NULL, MKDEV(foo_major, 0), NULL, "foo0");
[...]

You should probably rather move away from struct class_device and 
class_device_create() and use struct device and device_create() instead 
(all the drivers using class_device are currently being converted this 
way, so that class_device could go away), so that your driver is using the 
new kernel driver core API.

The conversion should be really very simple.

-- 
Jiri Kosina
