Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbYA2Xqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbYA2Xqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760516AbYA2XqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:46:12 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:37727 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758375AbYA2XqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:46:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=uWwJ8EpkZGpUYVBnk4bcNcy33eywRT/RbrTNR+7+Wt5yulKL3dWR5AJnkYBV+VkiKvbcMWRSWpfVQYMHswlxCLt5g2VxFqXEZkbwB1nN/OQPGr6AE2XRbkszDR/V2nxVWP6jKZdlpcR62DvOnPQw0n9SLsrW8bf5Ka4rkTcmVh4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
Date: Wed, 30 Jan 2008 00:58:33 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: rdreier@cisco.com, nai.xia@gmail.com, flo@rfc822.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       j-nomura@ce.jp.nec.com, Borislav Petkov <bbpetkov@yahoo.de>
References: <200801292201.45718.nai.xia@gmail.com> <adar6g0e0g2.fsf@cisco.com> <20080129.182356.70224412.k-ueda@ct.jp.nec.com>
In-Reply-To: <20080129.182356.70224412.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801300058.33284.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 30 January 2008, Kiyoshi Ueda wrote:
> Hi Bart, 
> 
> On Tue, 29 Jan 2008 14:22:53 -0800, Roland Dreier wrote:
> > Hi, I saw the same BUG from ide-cd on one of my systems.  I applied
> > the debugging patch to replace the BUG with blk_dump_rq_flags(), and I
> > got the output below (full boot log and .config attached to this
> > email).
> > 
> > Please let me know if there's anything else that would help debug the
> > problem.
> 
> Thank you for the information, Roland.
> 
>  
> > [    4.072271] Uniform CD-ROM driver Revision: 3.20
> > [    4.098236] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > [    4.100269]
> > [    4.100269] sector 1949759, nr/cnr 0/0
> > [    4.100269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
> > [    4.100269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > [    4.101005] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > [    4.104269]
> > [    4.104269] sector 1949759, nr/cnr 0/0
> > [    4.104269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
> > [    4.104269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > [    4.109203] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > [    4.112270]
> > [    4.112270] sector 1949759, nr/cnr 0/0
> > [    4.112270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
> > [    4.112270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > [    4.112945] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > [    4.116270]
> > [    4.116270] sector 1949759, nr/cnr 0/0
> > [    4.116270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
> > [    4.116270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> 
> Bart,
> This means that the rq still has a bio even after DRQ_STAT is cleared.
> The original ide-cd code was calling only end_that_request_last() there.
> So I thought that the rq should have no bio when DRQ_STAT is cleared,
> otherwise the bio leaks.
> 
> Was my understanding wrong and is that correct behavior in ide-cd?

Added Borislav to cc:.

PS I'm extremely busy with "real-life" (unfortunately IDE hacking is not
my paid job) and the friday is the earliest date on which I would be able
to look in detail into this problem and other outstanding IDE stuff, sorry.

Thanks,
Bart
