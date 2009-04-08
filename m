Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbZDHTyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbZDHTyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759352AbZDHTyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:54:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbZDHTyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:54:08 -0400
Date: Wed, 8 Apr 2009 21:56:10 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Jan Knutar <jk-lkml@sci.fi>
Subject: Re: SSD and IO schedulers
Message-ID: <20090408195610.GA5447@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Corrado Zoccolo <czoccolo@gmail.com>,
	=?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
	Jan Knutar <jk-lkml@sci.fi>
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com> <20090204004003.26068f72@werewolf.home> <200902071858.40146.jk-lkml@sci.fi> <4e5e476b0904081218i29871702qc8bacb680c51ec2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0904081218i29871702qc8bacb680c51ec2c@mail.gmail.com>
Organization: private site
User-Agent: Mutt/1.5.19+20090405 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX19Y/l5ANLhTUk4/0ZtyCqRJ81g3JyZXGtp3x6W
 HM5ToSJynGA68JTCDPDQhZUYLM+KdXZts0H1KYn6cZfOYY5TDG
 TWc7KCIv5E2rlUSET+1BQuWyhC1bgePqM81ZURUhfk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.04.2009, Corrado Zoccolo wrote: 

> I found that elevator=deadline performs much better than noop for
> writes, and almost as well for reads
[....]

The DL elevator has slightly more throughput than cfq and anticipatory,
but is almost unusuable under load.

Running Theodore Ts'os "fsync-tester" while doing Linus' torture test 
"while : ; do time sh -c "dd if=/dev/zero of=bigfile bs=8M count=256 ; sync; rm bigfile"; done"
shows it clearly:

mount: /dev/sda4 on /home type xfs (rw,noatime,logbsize=256k,logbufs=2,nobarrier)
Kernel 2.6.29.1 (vanilla)

with cfq:

htd@liesel:~/!> ./fsync-tester
fsync time: 0.7640
fsync time: 0.6166
fsync time: 1.2830
fsync time: 0.4273
fsync time: 1.1693
fsync time: 1.7466
fsync time: 1.2477
fsync time: 1.9411
fsync time: 1.9636
fsync time: 1.9065
fsync time: 1.1561
fsync time: 1.8267
fsync time: 0.2431
fsync time: 0.2898
fsync time: 0.2394
fsync time: 0.4309
fsync time: 1.5699
fsync time: 0.3742
fsync time: 1.3194
fsync time: 1.9442
fsync time: 1.0899
fsync time: 1.9443
fsync time: 1.0062

with dl:

fsync time: 10.5853
fsync time: 10.3339
fsync time: 5.3374
fsync time: 6.5707
fsync time: 10.6095
fsync time: 4.1154
fsync time: 4.9604
fsync time: 10.5325
fsync time: 10.4543
fsync time: 10.4970
fsync time: 10.5570
fsync time: 5.2717
fsync time: 10.5619
fsync time: 5.3058
fsync time: 3.1019
fsync time: 5.1504
fsync time: 5.7564
fsync time: 10.5998
fsync time: 4.0895


Regards, Heinz.

