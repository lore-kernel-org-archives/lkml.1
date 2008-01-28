Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbYA1Jqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbYA1Jqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbYA1JqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:46:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:52792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbYA1JqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:46:16 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
To: Trond Myklebust <Trond.Myklebust@netapp.com>, Andi Kleen <ak@suse.de>,
       Steve French <smfrench@gmail.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Reply-To: 7eggert@gmx.de
Date: Mon, 28 Jan 2008 10:44:41 +0100
References: <9Q5hR-3MI-9@gated-at.bofh.it> <9Qsob-7is-1@gated-at.bofh.it> <9QtDz-121-11@gated-at.bofh.it> <9QtWX-1qg-15@gated-at.bofh.it> <9Qugj-1PK-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1JJQXh-0000kW-VW@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/IAGn9EaUvNsQkENcWgoL1f2OmoSRpi25NJ7J
 RuhexaUzjO+BMsoN7JXi12p2I19NTvijNU7R8AFLA+8vMjLdrx
 xEmhvie3lxtsWO1u+XSJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> On Mon, 2008-01-28 at 05:38 +0100, Andi Kleen wrote:
>> On Monday 28 January 2008 05:13:09 Trond Myklebust wrote:
>> > On Mon, 2008-01-28 at 03:58 +0100, Andi Kleen wrote:

>> > > The problem is that it's not a race in who gets to do its thing first,
>> > > but a parallel reader can actually see a corrupted value from the two
>> > > independent words on 32bit (e.g. during a 4GB). And this could actually
>> > > completely corrupt f_pos when it happens with two racing relative seeks
>> > > or read/write()s
>> > > 
>> > > I would consider that a bug.
>> > 
>> > I disagree. The corruption occurs because this isn't a situation that is
>> > allowed by either POSIX or SUSv2/v3. Exactly what spec are you referring
>> > to here?
>> 
>> No specific spec, just general quality of implementation. We normally don't
>> have non thread safe system calls even if it was in theory allowed by some
>> specification.
> 
> We've had the existing implementation for quite some time. The arguments
> against changing it have been the same all along: if your application
> wants to share files between threads, the portability argument implies
> that you should either use pread/pwrite or use a mutex or some other
> form of synchronisation primitive in order to ensure that
> lseek()/read()/write() do not overlap.

Does anything in the kernel depend on f_pos being valid?
E.g. is it possible to read beyond the EOF using this race, or to have files
larger than the ulimit?

If not, update the manpage and be done. ¢¢

