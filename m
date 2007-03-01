Return-Path: <linux-kernel-owner+w=401wt.eu-S932927AbXCAB3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbXCAB3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932933AbXCAB3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:29:21 -0500
Received: from [139.30.44.16] ([139.30.44.16]:18639 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932927AbXCAB3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:29:21 -0500
Date: Thu, 1 Mar 2007 02:29:19 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] udivdi3: 64 bit divide
In-Reply-To: <20070227122437.da27c3cd.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.63.0703010220210.21277@gockel.physik3.uni-rostock.de>
References: <20070226173517.66bf0fec@freekitty> <20070227122437.da27c3cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007, Andrew Morton wrote:
> > On Mon, 26 Feb 2007 17:35:17 -0800 Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > The kernel already has several implmentations and usages of 64 by 64 
> > bit divide.
> > 
> > Although it is significantly slower, there are places that need it so
> > provide one generic version using scaling, and allow existing platform
> > versions to continue.
> 
> The reason we implement 64/32 via do_div() is, for better or for worse, to
> make people think before they use it.  And to make it stand out, and so
> that we discover places that are using it by accident, where they could use
> something cheaper.

IMHO it is even more important that the user of your 64/64 div is aware 
that it only returns an approximate result.

I certainly don't want to have any code in the kernel that by accident 
makes an allocation a few bytes short of the actual size of the object 
(just to make up a drastic example).

Tim
