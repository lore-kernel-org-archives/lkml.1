Return-Path: <linux-kernel-owner+w=401wt.eu-S1030575AbXBMARY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030575AbXBMARY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030574AbXBMARY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:17:24 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:56708 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030573AbXBMARX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:17:23 -0500
Date: Mon, 12 Feb 2007 16:17:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.19.1: kernel BUG at mm/slab.c:2911!
In-Reply-To: <45BF2418.9010002@ribosome.natur.cuni.cz>
Message-ID: <Pine.LNX.4.64.0702121610240.19380@schroedinger.engr.sgi.com>
References: <45BF2418.9010002@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Martin MOKREJ wrote:

> Hi,
>   is this a known issue? Should I bother to upgrade to 2.6.19.2 if it contains the fix?
> Thank you any help. It might be related to NFS. The machine in question is NFSv3 client,
> udp. And used for computations. The process which died is from torque cluster management
> package.

> 000: 00 00 00 00 fe ff ff ff fe ff ff ff 3a 00 00 00

The beginning of the slab was overwritten. The first two words should have 
been list pointers. color offset is also invalid as is the pointer to the 
slab memory.

Are you using cpu hotplug by chance?

