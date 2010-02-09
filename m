Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0BIRZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:25:54 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:58334 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0BIRZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <20100205205043.GB4178@oksana.dev.rtsoft.ru>
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru> <20100205205043.GB4178@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Feb 2010 10:25:22 -0700
X-Google-Sender-Auth: ef7a8ae5262124e7
Message-ID: <fa686aa41002090925q30f362d6x4d14894a72439125@mail.gmail.com>
Subject: Re: [PATCH 2/3] of: Introduce safe accessors for node->data
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 1:50 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> Platform code use node->data to store some private information
> associated with a node.
>
> Previously there was no need for any locks and accessors since we were
> initializing the data mostly at boot time and never modified it later.
>
> Though, nowadays OF GPIO infrastructure supports GPIO chips detaching,
> so to handle this correctly we have to introduce locking for the
> node->data field.

I'm not convinced this is needed.  What's wrong with using the
whole-tree devtree_lock?

g.
