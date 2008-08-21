Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYHUOfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYHUOfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYHUOfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:35:22 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:34670 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbYHUOfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:35:21 -0400
In-Reply-To: <1219245321.3389.82.camel@localhost.localdomain>
To: Eric Paris <eparis@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>, davecb@sun.com, david@lang.hm,
       Jan Harkes <jaharkes@cs.cmu.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net
Subject: Re: [malware-list] scanner interface proposal was: [TALPA]	Intro	linux
 interface for access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: douglas.leeder@sophos.com
Date: Thu, 21 Aug 2008 15:35:27 +0100
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 21/08/2008 15:35:19,
	Serialize complete at 21/08/2008 15:35:19
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080821143525.27F9F37655B@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote on 2008-08-20 16:15:21:

> At the moment I'm leaning towards a separate async notification system
> for open/mtime change/close which will be a fire and forget notification
> system with no access control mechanism.
> 
> A second, although very similar, mechanism will block on read/mmap
> (although I'm not so sure how to handle O_NONBLOCK without a kernel
> fastpath/inode marking that actually gets used, this is really a serious
> design issue with putting this at read/mmap.  I don't think we are ready
> to give up on O_NONBLOCK for S_ISREG altogether just yet are we?) and
> provide access control.  I also plan to include open() in the
> blocking/access control based on a /proc tunable.  If applications can't
> handle EPERM at read/mmap they can get it at open and suffer the
> perf/blocking hit needlessly on open/stat sequences.

I think these are excellent ideas. 

The kernel really does have to keep some record if it's going to do any 
scanning from read() calls, it can't go to userspace each time to check
if a file is cached.
(It might be the single open file descriptor that's marked though)

O_NONBLOCK is then handled nicely, and we can avoid ever blocking that 
client process (which given they're trying non-blocking IO is probably 
a good thing).

-- 
Douglas Leeder



Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

