Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbYBYCus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbYBYCus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYBYCuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:50:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbYBYCuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:50:39 -0500
Message-ID: <002101c87759$0fb4f010$58f80d0a@brian>
From: "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>
To: "Andreas Schwab" <schwab@suse.de>, <petkovbb@gmail.com>
Cc: <bzolnier@gmail.com>, <linux-kernel@vger.kernel.org>,
       <jens.axboe@oracle.com>, <j-nomura@ce.jp.nec.com>,
       "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>
References: <jelk5k62uy.fsf@sykes.suse.de><58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com><20080218.135827.74754725.k-ueda@ct.jp.nec.com><jek5kvisih.fsf@sykes.suse.de> <20080224163244.GA11998@gollum.tnic> <jehcfyffyp.fsf@sykes.suse.de>
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
Date: Sun, 24 Feb 2008 21:49:31 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Sat, 23 Feb 2008 16:47:50 +0100, Andreas Schwab wrote:
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> writes:
>
> > Could you try this patch?
> > I've only done a compile test, so this patch may not work.
>
> Unfortunately, that is not enough to get DVD burning working again.
> This is the error that growisofs is getting:
>
> ioctl(6, SG_IO, {'S', SG_DXFER_TO_DEV, cmd[10]=[2a, 00, 00, 00, 03, 10, 
> 00, 00, 10, 00], mx_sb_len=64, iovec_count=0, dxfer_len=32768, 
> timeout=60000, flags=0x3, 
> data[32768]=["\360R\360\314Wt\277\241\36.\347\356L$\201]\210\372_~]I\213\366\253SV\2\372\356\312\257"...], 
> status=02, masked_status=01, sb[0]=[], host_status=0, driver_status=0, 
> resid=32768, duration=0, info=0x1}) = 0
> write(2, ":-( unable to WRITE@LBA=310h: ", 30) = 30
>
> It looks like the sense buffer is not filled in.  In a successfully run
> of growisfs under 2.6.24.2 the sense code is "LONG WRITE IN PROGRESS".
>
> I also see that resid always equals dxfer_len even when the transfer was
> successful, although growisofs does not seem to care.  With 2.6.24.2
> resid is only non-zero when a sense error occurred.

I'm looking at this problem, but currently no idea why the conversion
to blk_end_request causes it.

growisofs (in dvd+rw-tools-7.0) seems to care only the sense buffer
of the sg_io_hdr, as you said.
(growisofs_mmc.cpp:poor_mans_pwrite64() and transport.hxx:transport())
So if the driver sets the sense code correctly, growisofs should work
correctly I think.
However, I can't find why the blk_end_request patch affects the sense
code setting.

Could you give me some more information below to help investigation?
  o Have you tried bisecting the kernel changes to find suspicious
    commit?  If so, that information will be much appreciated.
  o Is this problem 100% reproducible on your Pioneer drive?
  o What is your dvd+rw-tools version?
  o Do you get some messages from kernel like "DMA error" when
    the problem happens?

And I'm sorry but I can't make enough time for this problem
until late this week.

Thanks,
Kiyoshi Ueda

