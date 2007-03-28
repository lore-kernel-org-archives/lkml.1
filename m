Return-Path: <linux-kernel-owner+w=401wt.eu-S965584AbXC1B0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584AbXC1B0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 21:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965587AbXC1B0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 21:26:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40415 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965584AbXC1B0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 21:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=DeNlg/clFC1LVfYbFdGU/ZLs3LvZPfz9po2DhsPd3SqLcDEfVVsBrLzjYIvduzo+jq/zCGpYjBIYFaaTGmiSRehUTTcOxH+8Lf0C6NWUcTmUeXm5PHg7nDpyZWMYyHRbdh67K8v53TqIyOeUZERova9ma7SgFfaSKHD4nSodJDU=
Date: Wed, 28 Mar 2007 03:26:35 +0200
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Larry Finger <larry.finger@lwfinger.net>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070328012635.GC18799@zenigma>
References: <4602752A.5050109@lwfinger.net> <20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com> <4602D137.4060402@lwfinger.net> <20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com> <20070323210618.6a41f5da.akpm@linux-foundation.org> <20070326110949.5301a571@gondolin.boeblingen.de.ibm.com> <20070326012232.0f0b9e09.akpm@linux-foundation.org> <20070326103432.GB18799@zenigma> <3ae72650703270225k1db9c4a8w6e31b95e007336d7@mail.gmail.com> <20070327191749.28298069@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327191749.28298069@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.2i
From: Eric Rannaud <eric.rannaud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 07:17:49PM +0200, Cornelia Huck wrote:
> On Tue, 27 Mar 2007 11:25:57 +0200,
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> > Checking the uevent return value, will not prevent any malfunction,
> > usually this kind of "error handling" just prevents bringing up a
> > whole subsystem, or booting-up a box, because the needed device does
> > not exist at all.
> 
> OK, if we consider uevents to be non-vital to a functioning device.

The reason for that original patch was that it is actually possible for the
uevent functions to return -ENOMEM, the uevent buffer being statically
allocated to BUFFER_SIZE (2048). It used to be 1024 but that was not
always enough and it was doubled a while ago [1]. Using add_uevent_var()
makes this less of a problem as such an overflow should be catched
cleanly [2].

> OTOH, I think using something like uevent_suppress (maybe via
> dev_uevent_filter?) is a saner way to suppress a uevent than to return
> an error code in the uevent function.

That makes sense, I guess. I will try that.

Thanks.


[1] http://marc.info/?t=113797361200002&r=1&w=2
[2] uevent-use-add_uevent_var-instead-of-open-coding-it.patch in rc4-mm1
