Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXGZBdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXGZBdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXGZBcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:32:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:6641 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbXGZBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QNMW8cQZKHKiiCMf5povOgxImc1KjWBIh+4RvcYs7TrdXYOsOM4fW3SSFAhrXAC40ujaP9LX0/gCRItamQfVFdF5vpryOMVjdRUn4vs/Yt0/h0SrIn5cM1q1xWQpzHoMahembc0+Lw+0XbJYQYz3wOfzKOyTN6ma8ziSoOrnUjg=
Message-ID: <2c0942db0707251832i542249d5ve0006b3db0374678@mail.gmail.com>
Date: Wed, 25 Jul 2007 18:32:48 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Matthew Hawkins" <darthmdh@gmail.com>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: linux-kernel@vger.kernel.org, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org
In-Reply-To: <b21f8390707251815o767590acrf6a6c4d7290a26a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com>
	 <2c0942db0707250902v58e23d52v434bde82ba28f119@mail.gmail.com>
	 <b21f8390707251815o767590acrf6a6c4d7290a26a8@mail.gmail.com>
X-Google-Sender-Auth: 715e0721894d8215
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Matthew Hawkins <darthmdh@gmail.com> wrote:
> On 7/26/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> > I'd just like updatedb to amortize its work better. If we had some way
> > to track all filesystem events, updatedb could keep a live and
> > accurate index on the filesystem. And this isn't just updatedb that
> > wants that, beagle and tracker et al also want to know filesystem
> > events so that they can index the documents themselves as well as the
> > metadata. And if they do it live, that spreads the cost out, including
> > the VM pressure.
>
> We already have this, its called inotify (and if I'm not mistaken,
> beagle already uses it).

Yeah, I know about inotify, but it doesn't scale.

ray@phoenix:~$ find ~ -type d | wc -l
17933
ray@phoenix:~$

That's not fun with inotify, and that's just my home directory. The
vast majority of those are quiet the vast majority of the time, which
is the crux of the problem, and why inotify isn't a great fit for
on-demand virus scanners or indexers.

Ray
