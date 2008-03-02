Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbYCBVpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbYCBVpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbYCBVpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:45:04 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:39361 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbYCBVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:45:01 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 2 Mar 2008 13:44:53 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Sam Varshavchik <mrsam@courier-mta.com>
cc: linux-man@vger.kernel.org, Michael Kerrisk <mtk.manpages@googlemail.com>,
       =?X-UNKNOWN?Q?Chris_=C2=A5=C2=AF_Heath?= <chris@heathens.co.nz>,
       David Schwartz <davids@webmaster.com>, dada1@cosmosbay.com,
       =?UTF-8?B?TGludXgtS2VybmVsQFZnZXIuIEtlcm5lbC4=?= Org 
	<linux-kernel@vger.kernel.org>
Subject: Re: epoll design problems with common fork/exec patterns
In-Reply-To: <cone.1204470717.369031.30230.500@commodore.email-scan.com>
Message-ID: <Pine.LNX.4.64.0803021342070.16600@alien.or.mcafeemobile.com>
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com>
 <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com>
 <47C42CA7.4030607@gmail.com> <Pine.LNX.4.64.0802261049040.27243@alien.or.mcafeemobile.com>
 <1204075804.5238.7.camel@linux.heathens.co.nz>
 <Pine.LNX.4.64.0802271131180.377@alien.or.mcafeemobile.com>
 <cfd18e0f0802280512q43a457d0sc9a8dc83c51e8e1c@mail.gmail.com>
 <Pine.LNX.4.64.0802281106050.7660@alien.or.mcafeemobile.com>
 <cfd18e0f0802290746p3cb7efc9j72394cd77ff37829@mail.gmail.com>
 <Pine.LNX.4.64.0802291111320.31028@alien.or.mcafeemobile.com>
 <cfd18e0f0802291154j612b4238i66cb8323b72814ca@mail.gmail.com>
 <cone.1204470717.369031.30230.500@commodore.email-scan.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008, Sam Varshavchik wrote:

> Hijacking this epoll thread, the following related question occurs to me:
> 
> #Q8
> #    Does an operation on a file descriptor affect the already collected but
> #not yet reported events?
> #
> #A8
> #    You can do two operations on an existing file descriptor. Remove would
> #be meaningless for this case. Modify will re-read available I/O.
> 
> Why is EPOLL_CTL_DEL considered meaningless? A process is wrapping up its
> business and is preparing to remove the fd from the epoll set, and then close
> the file descriptor itself. In the meantime, the fd became readable, and a
> POLLIN event gets collected. So, what happens to the collected event, when the
> EPOLL_CTL_DEL operation is made?

Any epoll_wait() done after the POLLIN and before the EPOLL_CTL_DEL, will 
show up. After the EPOLL_CTL_DEL, of course, no events will be reported.



- Davide


