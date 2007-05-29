Return-Path: <linux-kernel-owner+w=401wt.eu-S1763765AbXE2JZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763765AbXE2JZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXE2JZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:25:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:48372 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbXE2JZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qWjdbIY+pR8+olkPAohvYFRBmxEQU5B76mWWhNrNRHyuluVwThLfOLoeMrPe+MWHgBmRVshX1WVcX4o28zz7qcbIIs88hbTyrZEq9wNTINeTTydojbDNiORXbb8Jk+4xbDnKmsuInqHtkV4OpfAOC9+hXK5zG/yW7hd+0p5+r0o=
Message-ID: <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
Date: Tue, 29 May 2007 11:25:42 +0200
From: "Stefan Bader" <sbader3@googlemail.com>
To: "device-mapper development" <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "David Chinner" <dgc@sgi.com>, "Phillip Susi" <psusi@cfl.rr.com>,
       "Stefan Bader" <Stefan.Bader@de.ibm.com>,
       "Andreas Dilger" <adilger@clusterfs.com>,
       "Tejun Heo" <htejun@gmail.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
In-Reply-To: <20070528094358.GM25091@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18006.38689.818186.221707@notabene.brown>
	 <18010.12472.209452.148229@notabene.brown>
	 <20070528094358.GM25091@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/28, Alasdair G Kergon <agk@redhat.com>:
> On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
> > 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
>
> The device-mapper position has always been that we require
>
> >  a zero-length BIO_RW_BARRIER
>
> (i.e. containing no data to read or write - or emulated, possibly
> device-specific)
>
> before we can provide full barrier support.
>   (Consider multiple active paths - each must see barrier.)
>

Couldn't the same be ac hived by doing a sort of suspend, issuing the
barrier request, calling flush to all mapped devices and then wait for
in-flight I/O to go to zero? This certainly has the aspect of
performance degradation (but that seem to be a generic problem with
barriers not being specific enough).

> Until every device supports barriers -EOPNOTSUP support is required.
>   (Consider reconfiguration of stacks of devices - barrier support is a
>    dynamic block device property that can switch between available and
>    unavailable at any time.)
>
Is only an issue if not doing barrier handling in dm. In that case the
support in the devices is helpful but not required.

For something else: Alasdair, I am not a hundred percent sure about
that but I think that just passing the barrier flag on to mapped
devices might in some (maybe they are rare) cases cause a layer above
to think all data is on-disk while this isn't necessarily true (see my
previous post). What do you think?

Stefan
