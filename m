Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZDGOk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZDGOk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZDGOkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:40:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbZDGOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:40:07 -0400
Date: Tue, 7 Apr 2009 07:33:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Lord <lkml@rtr.ca>
cc: Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <49DB56B8.1060805@rtr.ca>
Message-ID: <alpine.LFD.2.00.0904070727260.4010@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>  <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu>
 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
 <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain> <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain> <49DB56B8.1060805@rtr.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Apr 2009, Mark Lord wrote:
> 
> What happens with ext3 "writeback", and ext4 "whatever",
> when one does the quickie reboot method:
> 
>   ALT-SYSRQ-S ALT-SYSRQ-U ALT-SYSRQ-S ALT-SYSRQ-B
> 
> ???

Since 's' syncs (I think 'u' does too, as part of making things 
read-only), the data blocks will be on disk after the boot regardless of 
any other ordering.

Of course, it will leave all your lock-files files alone, and I can almost 
guarantee that some daemons (read: "NetworkManager") will then fail on the 
next boot because they think they are already running.

			Linus
