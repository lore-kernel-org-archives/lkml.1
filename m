Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbZKDTai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbZKDTai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbZKDTah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:30:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbZKDTah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:30:37 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 15/20] blkio: Take care of preemptions across groups
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-16-git-send-email-vgoyal@redhat.com>
	<x49d43yt8ry.fsf@segfault.boston.devel.redhat.com>
	<20091104192725.GM2870@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 14:30:13 -0500
In-Reply-To: <20091104192725.GM2870@redhat.com> (Vivek Goyal's message of
	"Wed, 4 Nov 2009 14:27:25 -0500")
Message-ID: <x49fx8ursu2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> It will not as we traverse up the hierarchy and look for the ioprio class
> of the group entity.
>
> So if you got following configuration where G1 and G2 are two groups. G1
> is prio class RT and G2 is prio class BE, then any queue in G1 will
> preempt any queue in G2 as at highest level, G1 and G2 are different class
> altogether.
>
> 			root
> 			/  \
> 		       G1  G2
>
> Normal cfqq preemption checks will not catch this. So if G2 has some BE
> cfqq running, and some BE queue gets backlogged in G1, this new queue wil
> not preempt the queue in G2 and it should have.
>
> That's why preemption checks at group level.
>
> Secondly if G1 and G2 are of ioprioclass BE and all the jobs in G1 are of
> RT nature, they will not preempt the queues in G2, hence providing
> isolation.

Thanks for the explanation, Vivek.  I somehow missed that we were
checking the class of the group entity and not the cfqq's entity.

Cheers,
Jeff
