Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbZEGOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbZEGOrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZEGOrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:47:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZEGOrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:47:06 -0400
Date: Thu, 7 May 2009 10:45:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com,
       m-ikeda@ds.jp.nec.com, peterz@infradead.org
Subject: Re: IO scheduler based IO Controller V2
Message-ID: <20090507144501.GB9463@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org> <20090506023332.GA1212@redhat.com> <20090506203228.GH8180@redhat.com> <20090506213453.GC4282@linux> <20090506215235.GJ8180@redhat.com> <20090507090450.GA4613@linux> <20090507141126.GA9463@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507141126.GA9463@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 10:11:26AM -0400, Vivek Goyal wrote:

[..]
> [root@chilli io-throttle-tests]# ./andrea-test-script.sh 
> RT: 223+1 records in
> RT: 223+1 records out
> RT: 234179072 bytes (234 MB) copied, 0.988448 s, 237 MB/s
> BE: 223+1 records in
> BE: 223+1 records out
> BE: 234179072 bytes (234 MB) copied, 1.93885 s, 121 MB/s
> 
> So I am still seeing the issue with differnt kind of disks also. At this point
> of time I am really not sure why I am seeing such results.

Hold on. I think I found the culprit here. I was thinking that what is
the difference between two setups and realized that with vanilla kernels
I had done "make defconfig" and with io-throttle kernels I had used an
old config of my and did "make oldconfig". So basically config files
were differnt.

I now used the same config file and issues seems to have gone away. I
will look into why an old config file can force such kind of issues.

So now we are left with the issue of loosing the notion of priority and
class with-in cgroup. In fact on bigger systems we will probably run into
issues of kiothrottled scalability as single thread is trying to cater to
all the disks.

If we do max bw control at IO scheduler level, then I think we should be able
to control max bw while maintaining the notion of priority and class with-in
cgroup. Also there are multiple pdflush threads and jens seems to be pushing
flusher threads per bdi which will help us achieve greater scalability and
don't have to replicate that infrastructure for kiothrottled also.

Thanks
Vivek
