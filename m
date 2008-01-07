Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYAGJB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYAGJB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYAGJBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:01:51 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52024 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYAGJBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:01:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Peer Chen" <pchen@nvidia.com>
Cc: "peerchen" <peerchen@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Andy Currid" <ACurrid@nvidia.com>
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability
References: <200712182300373901202@gmail.com>
	<m14pefaclv.fsf@ebiederm.dsl.xmission.com>
	<15F501D1A78BD343BE8F4D8DB854566B1F24C119@hkemmail01.nvidia.com>
	<m1d4t17zkn.fsf@ebiederm.dsl.xmission.com>
	<15F501D1A78BD343BE8F4D8DB854566B1F571D0F@hkemmail01.nvidia.com>
	<m1lk7kl3de.fsf@ebiederm.dsl.xmission.com>
	<15F501D1A78BD343BE8F4D8DB854566B1FD7D6B5@hkemmail01.nvidia.com>
Date: Mon, 07 Jan 2008 02:01:01 -0700
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B1FD7D6B5@hkemmail01.nvidia.com>
	(Peer Chen's message of "Mon, 7 Jan 2008 13:32:28 +0800")
Message-ID: <m163y6ko1e.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peer Chen" <pchen@nvidia.com> writes:

> Eric,
> Any decision for this patch, if not, currently we prefer to add all our
> code to quirks.c.

Sorry.  I think adding the code to quirks.c is fine.

For bisection and code inspection purposes I would prefer the code
to come as a patchset of two patches.  With the generic change
first.

I wanted to understand where you were coming from to make certain
I had not looked over something generic.  The closest to generic
I can make of your concern is that we are doing useless work if
we know there is an upstream msi to irq mapper that we can just
tunnel to over hypertransport.  At the generic level we can't know
that there is an upstream mapping capability as nothing reports
it, so we even if it is a good idea we can't do anything.

So a quirk looks fine to do what you are doing. 

Just please next round handle the address part of the msi mapping
capability if it is present, in the x86 part of the generic code.
Just in case someone implements that.

Eric
