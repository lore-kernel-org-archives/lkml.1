Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXKJTyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXKJTyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 14:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbXKJTyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 14:54:47 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:2376 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbXKJTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 14:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dA928IgdO/zTQHT9BqzUuHaAJjj90XJVtBQIdHVrRrSVjbbHW4iVZdbpgMGYh5Oqylfcs5yXkoUFnrwllPvoiAvpXqS7J4PzmUGZ51eHIBTWs1pb1TCCOm2YUVXqsnT0bR6SAfYMA7hpgfu6ChTBu+O9cIpucsjw9qOPXHdYFdc=
Message-ID: <524f69650711101154s67e19fe6wa1803b8ded2ff632@mail.gmail.com>
Date: Sat, 10 Nov 2007 13:54:44 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Przemyslaw Wegrzyn" <czajnik@czajsoft.pl>
Subject: Re: Fw: Buffer overflow in CIFS VFS.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joern@logfs.org,
       linux-cifs-client@lists.samba.org
In-Reply-To: <4735AC13.9030206@czajsoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OFA6B04F1D.DE8E7DD9-ON8725738E.00065BC2-8625738E.00066CD4@us.ibm.com>
	 <524f69650711081812j20580247kce68334b778c73c7@mail.gmail.com>
	 <47343DA2.90306@czajsoft.pl>
	 <524f69650711091444t4d02e6d8g7dd15dbe2637d714@mail.gmail.com>
	 <4735AC13.9030206@czajsoft.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 10, 2007 7:03 AM, Przemyslaw Wegrzyn <czajnik@czajsoft.pl> wrote:
> Steve French wrote:
> > That might be better, although without memory pools, this would perform
> > much worse
> >
> Why ? I don't get your point here.
>
> Przemyslaw
>

What I meant is that two fixed size memory pools rather variable size
kmallocs helps performance.  By using two fixed size buffers (small -
which fits the typical smb request and response, and large which fits
the maximum size request other than write which is handled via an
iovec) and taking advantage of memory pools, cifs can always make
progress even in low memory situations (reducing the likelihood of
deadlock) and it reduces the number of times that cifs has to do the
very expensive allocation of 16.5K.  If cifs only used variable size
request and response buffers, since they are frequently more than one
page in size we would be forcing the memory manager to find contiguous
pages which can be very slow.



-- 
Thanks,

Steve
