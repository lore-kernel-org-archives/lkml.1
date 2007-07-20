Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbXGTEXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbXGTEXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXGTEWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:22:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:51326 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXGTEWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hk9oX5oivn5xXakX6VwHd2XJtiG0i2kulAMnzKTD2KlcV1X7gnhWxQB5Yt5pZH0Z6SeOYDuE/UKm3Slv3YqVR/wOSVedOG3LwpcP5qxx+7jBl/i9LXYhcXpRiKru8VmnERFfkAr19oEoiGuRMKLKvP1+QGpX2auSA7lkjztJQYM=
Message-ID: <a781481a0707192122w13b82f38h3408c3cd77ed0790@mail.gmail.com>
Date: Fri, 20 Jul 2007 09:52:49 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: [NFS] [PATCH 013 of 20] knfsd: nfsd: factor out code from show_expflags
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <18080.7196.844577.295882@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710121949.12548.patches@notabene>
	 <1070710022737.13509@suse.de>
	 <20070713002933.f15724a7.akpm@linux-foundation.org>
	 <20070718230555.GN7111@fieldses.org>
	 <18078.44366.961344.428533@notabene.brown>
	 <20070719153536.GB23093@fieldses.org>
	 <18080.7196.844577.295882@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Neil Brown <neilb@suse.de> wrote:
> On Thursday July 19, bfields@fieldses.org wrote:
> > On Thu, Jul 19, 2007 at 10:16:14AM +1000, Neil Brown wrote:
> > > On Wednesday July 18, bfields@fieldses.org wrote:
> > > > OK, here I'm still confused--what should we be doing instead?
> > >
> > > Cast the variable to a type that printf knows about.
> > >        seq_printf(m, ",anonuid=%d", (int)anonu);
> > >
> > > Or maybe cast it to (long) and use %ld, just in case...
> >
> > OK.  In the event that uid_t some day ceases to eventually become an
> > int, will the casts help, or will they just suppress useful warnings?
>
> Probably not.  Just leave it as it is.
>
> >
> > > Note the stray 's' in the current patch, after the comma!
> >
> > Sharp eyes, thanks!  I'll make a patch.  Uh, any objection if I print
> > all those uid's as unsigned while I'm at it?
>
> I wondered about that too.  I think we have completely removed the
> fiction that 'nobody' is '-2' rather than '65534' so it should be both
> safe and sensible to make them unsigned.

Ummm ... sorry for butting in here :-) But uid_t is always unsigned, yes.
