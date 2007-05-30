Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbXE3Ize@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbXE3Ize (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXE3IzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:55:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:31616 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbXE3IzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GYiCEHQH1H6zxvawzvmFnZy/E1WQUks0gLoy58FKTnf/x/ABhYSNeDwPd+7xHHCCBqWHIk1lRce1yZ/SysQ/e6k0XMzd3cCouJiybaCm5wBYDtx60ejMRV/Wnnbj860fg/sRFv6FV68GGOh7fMuhxkKhDNI1OGbImpxZ11vq9kA=
Message-ID: <5201e28f0705300155ue7ce985m3f318ff7ff1a1396@mail.gmail.com>
Date: Wed, 30 May 2007 10:55:13 +0200
From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Cc: david@lang.hm, "Phillip Susi" <psusi@cfl.rr.com>,
       "Neil Brown" <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Andreas Dilger" <adilger@clusterfs.com>,
       "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <20070530061723.GY85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18006.38689.818186.221707@notabene.brown>
	 <18010.12472.209452.148229@notabene.brown>
	 <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com>
	 <20070529234832.GT85884050@sgi.com>
	 <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
	 <20070530061723.GY85884050@sgi.com>
X-Google-Sender-Auth: 940b2ce0dd5d7d96
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The order that these are expected by the filesystem to hit stable
> storage are:
>
> 1. block 4 and 10 on stable storage in any order
> 2. barrier block X on stable storage
> 3. block 5 and 20 on stable storage in any order
>
> The point I'm trying to make is that in XFS,  block 5 and 20 cannot
> be allowed to hit the disk before the barrier block because they
> have strict order dependency on block X being stable before them,
> just like block X has strict order dependency that block 4 and 10
> must be stable before we start the barrier block write.
>

That would be the exactly how I understand Documentation/block/barrier.txt:

"In other words, I/O barrier requests have the following two properties.
1. Request ordering
...
2. Forced flushing to physical medium"

"So, I/O barriers need to guarantee that requests actually get written
to non-volatile medium in order."

Stefan
