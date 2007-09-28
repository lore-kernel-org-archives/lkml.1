Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbXI1I11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbXI1I11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbXI1I1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:27:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:61939 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbXI1I1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LsojLKYSUIgVYFRYRuJ1l9l+Yg3MUxo8YuS2zBx67wwCCLZ1D+31qyjv244Ng2/ePOY+a/IpInwgrXqm9sPUegGEr8oERSfFoFr+oD8tjMK+LxoGmpdbVpb3dncq1gYs2VxwxJpnyNCacIQJmria2+aTS5ZhvehHhKN5Gr5QSy4=
Message-ID: <92cbf19b0709280127yba48b60wfe58e532944894ca@mail.gmail.com>
Date: Fri, 28 Sep 2007 01:27:18 -0700
From: "Chakri n" <chakriin5@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
In-Reply-To: <1190962752.31636.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	 <1190962752.31636.15.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

The BDI dirty limits sounds like a good idea.

Is there already a patch for this, which I could try?

I believe it works like this,

Each BDI, will have a limit. If the dirty_thresh exceeds the limit,
all the I/O on the block device will be synchronous.

so, if I have sda & a NFS mount, the dirty limit can be different for
each of them.

I can set dirty limit for
 -  sda to be 90% and
 -  NFS mount to be 50%.

So, if the dirty limit is greater than 50%, NFS does synchronously,
but sda can work asynchronously, till dirty limit reaches 90%.

Thanks
--Chakri

On 9/27/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2007-09-27 at 23:50 -0700, Andrew Morton wrote:
>
> > What we _don't_ want to happen is for other processes which are writing to
> > other, non-dead devices to get collaterally blocked.  We have patches which
> > might fix that queued for 2.6.24.  Peter?
>
> Nasty problem, don't do that :-)
>
> But yeah, with per BDI dirty limits we get stuck at whatever ratio that
> NFS server/mount (?) has - which could be 100%. Other processes will
> then work almost synchronously against their BDIs but it should work.
>
> [ They will lower the NFS-BDI's ratio, but some fancy clipping code will
>   limit the other BDIs their dirty limit to not exceed the total limit.
>   And with all these NFS pages stuck, that will still be nothing. ]
>
>
>
>
