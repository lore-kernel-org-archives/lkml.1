Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXKBNuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXKBNuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXKBNuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:50:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:7451 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXKBNun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:50:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c3neWhjwuswKFta5ASiVTFAI6IYvglq7uAuBpaYxJHDkcgQYpJoX3fbynz8Ry8PRXCbB5C+xCoChXpxn/JFs9DlB2o1R92ve9e5+Od3Nzddo4+tWpF2ukEMsumXqJb02EUoHEJL0ITLTx9IUyH2tgBBBU3DEH9VTHagFSnjNuTQ=
Message-ID: <3ae72650711020650l37870e45yb853f888b4807116@mail.gmail.com>
Date: Fri, 2 Nov 2007 14:50:41 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Cc: "Greg KH" <greg@kroah.com>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Fengguang Wu" <fengguang.wu@gmail.com>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Miklos Szeredi" <miklos@szeredi.hu>
In-Reply-To: <1194009359.27652.377.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193410087.6914.34.camel@twins> <1193412836.27652.11.camel@twins>
	 <1193414147.2431.35.camel@lov.site> <1193429066.5648.35.camel@lappy>
	 <1193447889.5648.44.camel@lappy> <20071027024033.GB29039@kroah.com>
	 <1193474399.27652.15.camel@twins> <20071027160203.GA5709@kroah.com>
	 <1193519317.5776.14.camel@lov.site> <1194009359.27652.377.camel@twins>
X-Google-Sender-Auth: 07184de639e37388
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 2, 2007 2:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Thanks for the help so far, however we're still not quite there.
>
> The below patch still has the funny 20 character name limit. Is there a
> good reason its a char array like this, and not just a char * to a kstr?
> The code does kstrdup all over the place, I can't imagine why suddenly
> limiting it to 20 chars seems like a good idea.

You are absolutely right, it doesn't make any sense. The 20 char limit
is bad, but really,
having the name duplicated in the device structure, while the name is
already in the
embedded kobject, is really bad.

Greg recently got rid of the 20 chars in the kobject, now we need to fix the
devices to completely get rid of the static bus_id string array, and just set
the kobject name directly.
It's all long overdue to fix things like this in the driver core -
it's such a mess. After the
kset cleanup Greg and I are doing currently, we will remove that silly limit.

Hmm, regardless of the limit, isn't there a better device name than a memory
address of a kernel structure. :) If there is no better data,
shouldn't we get something
like an atomic counter somewhere in the nfs code, which just increases
with every
instance, and we could use that number as a connection id?

Kay
