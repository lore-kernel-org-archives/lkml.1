Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZFOI6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZFOI6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZFOI6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:58:38 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:41564 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZFOI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b6F7MD2ABczWFTbUY5lpWKtJVcCJtdo2babB1+wfmoW9S/e1oUWQAGvAJn4i9h9wlO
         Dj2eC6vomaPMc4RAioR3/C443mqthIxI6tYYbCIWE3lOTSOkgM+ji4MeMuw9WNtwBBDY
         J/DURwnyzFdhmBNKn9YYxGs9wdVMc8iaUWqXQ=
Date: Mon, 15 Jun 2009 17:00:50 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
Message-ID: <20090615090050.GA4422@cr0.nay.redhat.com>
References: <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com> <m1ab4i11zx.fsf@fess.ebiederm.org> <20090611050929.GA2706@cr0.nay.redhat.com> <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0> <m17hzg7oil.fsf@fess.ebiederm.org> <20090615021457.GA3388@cr0.nay.redhat.com> <4A35E32C.30609@oracle.com> <20090615070018.GD3544@cr0.nay.redhat.com> <4A360793.6060000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A360793.6060000@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please don't top-post.

On Mon, Jun 15, 2009 at 04:34:27PM +0800, Tao Ma wrote:
> Hi Amerigo,
>
> The wrong number I mean is 131941393240064.
>
> So do you think
> [root@test3 ~]# ls -l /proc/kcore
> -r-------- 1 root root 131941393240064 Jun 15 13:39 /proc/kcore
>
> is better than
>
> [taoma@test2 ~]$ ll /proc/kcore
> -r-------- 1 root root 281474974617600 Jun 15 15:20 /proc/kcore
> ?

Yes, the former *is* what I can expect.


>
> I don't think so.
>
> Actually the right result should look like
>
> [root@test8 ~]# ls -l /proc/kcore
> -r-------- 1 root root 5301604352 Jun 15 13:35 /proc/kcore
>
> And with your patch I can't get this number.

Of course not.

Again and again, kernel modules and vsyscall are also included
into kcore, unless doing this is wrong you will never get the
number you mentioned above, because they sit above the
phy mem map on x86_64.

Please read the code, I don't want to explain again and again.

