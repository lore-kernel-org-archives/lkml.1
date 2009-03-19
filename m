Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbZCSTZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbZCSTZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZCSTYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:24:55 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:34790 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbZCSTYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:24:55 -0400
Date: Thu, 19 Mar 2009 12:24:52 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/12] PCI Hotplug: restore fakephp interface with
 complete reimplementation
In-Reply-To: <20090319024555.1fed0dac.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0903191215160.28292@shell2.speakeasy.net>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224016.887.47034.stgit@bob.kio>
 <20090319024555.1fed0dac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009, Andrew Morton wrote:
> On Wed, 18 Mar 2009 16:40:16 -0600 Alex Chiang <achiang@hp.com> wrote:
>
> > A complete re-implementation of fakephp is necessary if it is to
> > present its former interface (pre-2.6.27, when it broke).
>
> We broke an existing interface?  wtf?
>
> If it's been broken for this long then do we actually need to
> resurrect it?

I found out it had been broken several months ago and made some of these
patches to fix it, but then lost my motivation for getting them into the
kernel.

There are people who use the old fakephp interface.  I was one of them.
They probably don't update their kernels in production systems and embedded
devices very often and haven't discovered the breakage in 2.6.27.

> If so, do we need to resurrect it in its old form?  This would appear
> to be an opportunity to improve that interface, unless the old one
> was perfect?

That's what I did in my initial patches.  I created a new interface with
the 'remove' file in the pci device's sysfs directory and the 'rescan' file
in /sys/bus/pci.  This is the new better interface.  legacy_fakephp is a
module that provides a compatible interface to the pre-2.6.27 one, though
it fixes some bugs with the old one and is overall much less code.
