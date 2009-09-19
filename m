Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZISX4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZISX4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 19:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZISX4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 19:56:12 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:48139 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZISX4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 19:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=x7bxgtA5ht8MeA5vjTViOrh1+dCmnJMNKUUwBDI9FXRawH7NVgBZaNjjFBygpxDT3/
         KqBWC56p+8dfT54b5zDh2NlamKxkSI2rH1Sh7nHwkuZo2tael9n6PGJAAJ4gK37ObLdD
         sXok+AxET/I00i2CVSseNGeo6WzjgJUcut84I=
MIME-Version: 1.0
In-Reply-To: <20090919220232.GB31849@suse.de>
References: <20090917161108.GA3361@infradead.org>
	 <19122.65335.126937.476968@notabene.brown>
	 <20090918200803.GM23126@kernel.dk>
	 <20090919141334N.fujita.tomonori@lab.ntt.co.jp>
	 <20090919220232.GB31849@suse.de>
Date: Sat, 19 Sep 2009 16:56:15 -0700
X-Google-Sender-Auth: c76a36c04121a13b
Message-ID: <e9c3a7c20909191656p625ccfa4pcef94cbe8a232bae@mail.gmail.com>
Subject: Re: [GIT PULL] DRBD for 2.6.32
From: Dan Williams <dan.j.williams@intel.com>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com,
       neilb@suse.de, hch@infradead.org, James.Bottomley@suse.de,
       lars.ellenberg@linbit.com, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 3:02 PM, Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2009-09-19T14:14:30, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>> I guess that Christoph is worry about adding another user interface
>> for kinda device management; once we merge this, we can't fix it (for
>> the raid unification).
>
> Why can't it be fixed?
>
> Either
>
> a) there's going to be a transition period during which the "old"
> interface is supported but depreciated and scheduled to be removed (all
> driving the new unified same back-end),
>
> or b) there's going to be a new kernel which requires new user-space
> tools sharp.
>
> In either case, dm/md are affected by this, so a third interface doesn't
> really make much difference. The refactoring needs to happen in the
> back-end anyway, and that actually becomes easier when all concurrent
> implementations are present and can be reworked at the same time.

It's actually four "raid" implementations in the kernel if you count
the multiple-disk functionality of btrfs.  The precedent is already
set for merging new multiple-disk management interfaces.

Neil has come the closest to actually trying to start (i.e. code) the
unification effort [1] and that was for the relatively straightforward
case of mapping the dm-raid5 backend to md-raid5... no uptake to date.
 There are no strictly equivalent drbd-backends in the kernel
presently, so leaving this out of tree is a net-loss for mainline.

--
Dan

[1]: http://marc.info/?l=dm-devel&m=124567352518676&w=2
