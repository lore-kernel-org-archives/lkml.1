Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYA2XYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYA2XYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYA2XYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:24:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbYA2XYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:24:09 -0500
Date: Tue, 29 Jan 2008 18:23:56 -0500 (EST)
Message-Id: <20080129.182356.70224412.k-ueda@ct.jp.nec.com>
To: bzolnier@gmail.com, rdreier@cisco.com
Cc: nai.xia@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 &&
 -g8561b089
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <adar6g0e0g2.fsf@cisco.com>
References: <200801292201.45718.nai.xia@gmail.com>
	<20080129.151353.48534987.k-ueda@ct.jp.nec.com>
	<adar6g0e0g2.fsf@cisco.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart, 

On Tue, 29 Jan 2008 14:22:53 -0800, Roland Dreier wrote:
> Hi, I saw the same BUG from ide-cd on one of my systems.  I applied
> the debugging patch to replace the BUG with blk_dump_rq_flags(), and I
> got the output below (full boot log and .config attached to this
> email).
> 
> Please let me know if there's anything else that would help debug the
> problem.

Thank you for the information, Roland.

 
> [    4.072271] Uniform CD-ROM driver Revision: 3.20
> [    4.098236] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> [    4.100269]
> [    4.100269] sector 1949759, nr/cnr 0/0
> [    4.100269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
> [    4.100269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> [    4.101005] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> [    4.104269]
> [    4.104269] sector 1949759, nr/cnr 0/0
> [    4.104269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
> [    4.104269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> [    4.109203] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> [    4.112270]
> [    4.112270] sector 1949759, nr/cnr 0/0
> [    4.112270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
> [    4.112270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> [    4.112945] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> [    4.116270]
> [    4.116270] sector 1949759, nr/cnr 0/0
> [    4.116270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
> [    4.116270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00

Bart,
This means that the rq still has a bio even after DRQ_STAT is cleared.
The original ide-cd code was calling only end_that_request_last() there.
So I thought that the rq should have no bio when DRQ_STAT is cleared,
otherwise the bio leaks.

Was my understanding wrong and is that correct behavior in ide-cd?

Thanks,
Kiyoshi Ueda
