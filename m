Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbXJBOio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbXJBOio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXJBOih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:38:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:13483 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbXJBOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A+WrXeqeYi+x+bIBUwyiGelSfSe01dEC+bp5e7A1rGmlD1y1dTc3qKAggygzYy6AqPaLu+hNf77phSZSLKKOB+C2mlKqeOCEgzMuYpdNq9PXrarx30Z7lShtZxD8iD3JV1+2JNj7evSxuFW8/+weZi5XTZoNATBWruvQ6MY1/a0=
Message-ID: <3ae72650710020738g7c80135au8618cf2dd2850eb@mail.gmail.com>
Date: Tue, 2 Oct 2007 16:38:24 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Fengguang Wu" <fengguang.wu@gmail.com>, greg@kroah.com
In-Reply-To: <1191325226.13204.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <1191313025.13204.30.camel@twins>
	 <20071002013148.18958af2.akpm@linux-foundation.org>
	 <1191314911.13204.41.camel@twins>
	 <3ae72650710020331o2ce5bd20wccc1964855279796@mail.gmail.com>
	 <1191321861.13204.53.camel@twins>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
X-Google-Sender-Auth: 81aed3ccf7aac9c8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2007-10-02 at 13:21 +0200, Kay Sievers wrote:
> > On 10/2/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, 2007-10-02 at 12:31 +0200, Kay Sievers wrote:
> > >
> > > > What would be the point in another top-level tree for device
> > > > information? All devices you are exporting information for, are
> > > > already in the sysfs tree, right?
> > >
> > > Never did find NFS mounts/servers/superblocks or whatever constitutes a
> > > BDI for NFS in there. Same goes for all other networked filesystems for
> > > that matter.
> >
> > How about adding this information to the tree then, instead of
> > creating a new top-level hack, just because something that you think
> > you need doesn't exist.
>
> So you suggest adding all the various network filesystems in there
> (where?), and adding the concept of a BDI, and ensuring all are properly
> linked together - somehow. Feel free to do so.

No, I propose to add only sane new userspace interfaces. That you miss
infrastructure to use, should never be the reason to add conceptually
broken new interfaces. A new device related top-level directory in
/sys is not going to happen. Better don't add new stuff, if you can't
do it right.

> > You called sysfs a mess, seems you work on that topic too. :)
>
> I called the in-kernel API to create sysfs files a mess. Not that I have
> another opinion on the content of /sys though, always takes to damn long
> to find anything in there.

Sure, it's a mess, we are trying to clean that up, it's hard, and
therefore we can not accept stuff like you propose, that makes it even
harder.

Use debugfs, if you can't add a sane interface. There are no rules,
you can do whatever you want there. If over time the stuff you need
gets added, you can always switch over.

Or add an attribute group to the existing devices, and leave the ones
out, which are not in sysfs right now, until they are added.

Or use a device class and use the existing devices as parents. If you
don't have a parent, they will show up in "virtual" until someone adds
the right parent devices. (If you are going to do this, make sure
nothing depends on a device being "virtual", it must be allowed to
re-parent these device with any future kernel release.)

Thanks,
Kay
