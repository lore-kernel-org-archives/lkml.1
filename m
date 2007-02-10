Return-Path: <linux-kernel-owner+w=401wt.eu-S1946799AbXBJAkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946799AbXBJAkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946794AbXBJAkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:40:35 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946516AbXBJAkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:40:33 -0500
Date: Fri, 9 Feb 2007 16:40:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Russ Cox" <rsc@swtch.com>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix quadratic behavior of shrink_dcache_parent()
Message-Id: <20070209164018.e4d29be0.akpm@linux-foundation.org>
In-Reply-To: <ee9e417a0702091623t1ccf55b8wb05b64b9c51474a6@mail.gmail.com>
References: <E1HFdnm-0006DB-00@dorka.pomaz.szeredi.hu>
	<20070209160055.bbd20c9f.akpm@linux-foundation.org>
	<ee9e417a0702091623t1ccf55b8wb05b64b9c51474a6@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 19:23:31 -0500
"Russ Cox" <rsc@swtch.com> wrote:

> > "The file system mounted on /tmp/z in the example contains 2^50
> > directories".   heh.
> >
> > I do wonder how realistic this problem is in real life.
> 
> That's a fair concern, although I was trying this as part
> of evaluating how much someone could hose a system
> if we let them mount arbitrary FUSE servers.  And the
> answer is: they could make it completely unusable,
> requiring reboot.
> 
> I ran a later test that printed how deep it got into
> the file tree and it was only a few hundred thousand
> if I recall correctly.  A determined attacker might even
> manage to do this in a normal file system.
> 
> But sure, it's not a common case.  ;-)

Well that's a good point - sometimes people do crazy things on purpose.  We
were all University students once ;) 

The patches look nice and as I said, potentially of some use for memory
reclaim.  But I hope that someone who has worked on dcache.c more recently
than I has time to apply a toothcomb to this work.

