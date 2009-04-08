Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbZDHUSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbZDHUSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZDHUSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:18:22 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39616 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZDHUSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=CdQ1JpsAVvs56jJKhmShDzC+tVo51nAAV5bJSQMC9p8MbpXyrvwG4+eX96UlsjRjgn
         u44hqF+PDIx1B4m5WLH+jlN71fFxUgZV/U9Q8+VyNdYkMER+y+2gWS/bBxmvla2INnO0
         2af3vs/CVt8YxkOCzCBA7OKzcfDoxvypUcCnI=
MIME-Version: 1.0
In-Reply-To: <20090408195610.GA5447@fancy-poultry.org>
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com>
	 <20090204004003.26068f72@werewolf.home>
	 <200902071858.40146.jk-lkml@sci.fi>
	 <4e5e476b0904081218i29871702qc8bacb680c51ec2c@mail.gmail.com>
	 <20090408195610.GA5447@fancy-poultry.org>
Date: Wed, 8 Apr 2009 22:18:18 +0200
Message-ID: <4e5e476b0904081318h4445556am1a6b0a49c6175719@mail.gmail.com>
Subject: Re: SSD and IO schedulers
From: Corrado Zoccolo <czoccolo@gmail.com>
To: linux-kernel@vger.kernel.org, Corrado Zoccolo <czoccolo@gmail.com>,
       =?UTF-8?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>,
       Jan Knutar <jk-lkml@sci.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, that's not an usual workload for netbooks, where most SSDs are
currently deployed.
For usual workloads, that are mostly read, cfq has lower performance
both in throughput and in latency than deadline.

Corrado

2009/4/8 Heinz Diehl <htd@fancy-poultry.org>:
> On 08.04.2009, Corrado Zoccolo wrote:
>
>> I found that elevator=deadline performs much better than noop for
>> writes, and almost as well for reads
> [....]
>
> The DL elevator has slightly more throughput than cfq and anticipatory,
> but is almost unusuable under load.
>
> Running Theodore Ts'os "fsync-tester" while doing Linus' torture test
> "while : ; do time sh -c "dd if=/dev/zero of=bigfile bs=8M count=256 ; sync; rm bigfile"; done"
> shows it clearly:
>
> mount: /dev/sda4 on /home type xfs (rw,noatime,logbsize=256k,logbufs=2,nobarrier)
> Kernel 2.6.29.1 (vanilla)
>
> with cfq:
>
> htd@liesel:~/!> ./fsync-tester
> fsync time: 0.7640
> fsync time: 0.6166
> fsync time: 1.2830
> fsync time: 0.4273
> fsync time: 1.1693
> fsync time: 1.7466
> fsync time: 1.2477
> fsync time: 1.9411
> fsync time: 1.9636
> fsync time: 1.9065
> fsync time: 1.1561
> fsync time: 1.8267
> fsync time: 0.2431
> fsync time: 0.2898
> fsync time: 0.2394
> fsync time: 0.4309
> fsync time: 1.5699
> fsync time: 0.3742
> fsync time: 1.3194
> fsync time: 1.9442
> fsync time: 1.0899
> fsync time: 1.9443
> fsync time: 1.0062
>
> with dl:
>
> fsync time: 10.5853
> fsync time: 10.3339
> fsync time: 5.3374
> fsync time: 6.5707
> fsync time: 10.6095
> fsync time: 4.1154
> fsync time: 4.9604
> fsync time: 10.5325
> fsync time: 10.4543
> fsync time: 10.4970
> fsync time: 10.5570
> fsync time: 5.2717
> fsync time: 10.5619
> fsync time: 5.3058
> fsync time: 3.1019
> fsync time: 5.1504
> fsync time: 5.7564
> fsync time: 10.5998
> fsync time: 4.0895
>
>
> Regards, Heinz.
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
