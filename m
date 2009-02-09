Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbZBISRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbZBISRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbZBISRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:17:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:2108 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbZBISRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fsCDbCAou8EBzhq8kj+7N4G2Osq/8xNYE2XS0DkXKD7Vw8si8sURICHXk//aQu1UVf
         f93yQa31HTGdoJr/eGgJlvlcTX7B1USaebJfGqlGrlfDSWNql4TaOjih7WKFQzA7Lw3+
         IKH0yq6E5587nhLd1z+watzQWW0zzsui4l5HI=
MIME-Version: 1.0
In-Reply-To: <20090209175514.GB19453@n2100.arm.linux.org.uk>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
	 <20090209171042.GA19453@n2100.arm.linux.org.uk>
	 <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com>
	 <20090209175514.GB19453@n2100.arm.linux.org.uk>
Date: Mon, 9 Feb 2009 19:17:07 +0100
Message-ID: <8447d6730902091017m21cb30d0w6be6fbbbf33db4f3@mail.gmail.com>
Subject: Re: [PATCH 1/2] User access to internal clocks
From: Davide Rizzo <elpa.rizzo@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You're not understanding the issue(s).
>
> 1. there is no 1:1 mapping between the identifiers (struct device +
>   connection ID) and the struct clk.  It's actually a many-to-one
>   mapping.
>
>   That means there is _no_ name associated with a struct clk.
>
>   Conceptually, clk_get() gives you a struct clk for the struct device
>   and a connection ID.  How that mapping is achieved isn't specified
>   in the API, all that's required is that such a mapping is performed.
>   It is _specifically_ intended that more than one set of {device,id}
>   pairs will map to the same clk.
>
>   So, now to insist that you can go from a struct clk to some kind of
>   string identifier for it is changing this - you're now requiring
>   that every struct clk has a unique name.  This is not the case.
>   PXA, for instance, struct clk's are now completely nameless.  They
>   have no identifier.
>
>   If you want to have a string identifier which works in every case,
>   this will:
>
>        sprintf(identifer, "%p", clk);
>
>   Or, I guess you could force every struct clk to have a 'sysfs_name'
>   field just to export them out via sysfs - and that'll be all that
>   it's used for.
>
> 2. there is no generic way to walk a set of struct clk's - indeed, there
>   may be no list of them (and there exists implmentations where that is
>   true) and the only list which does exist is a set ID to clk mapping
>   structures.
>
>> Otherwise, what do you suggest to enumerate and distinguish all system
>> clocks ?
>
> There exists no such concept in the API, what you're asking for is
> implementation specific.
>

Thank you for this explanation, now it's much more clear to me.

What about adding a dedicated function to clk api that registers a struct clk
 in a linked list and associates it with a name, with the only specific purpose
 to enumerate and list (and possibly change rate and parents) all
clocks in sysfs ?
Obviously only specifically registered clocks will be visible in sysfs...
