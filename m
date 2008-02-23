Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYBWPsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYBWPsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYBWPr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:47:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYBWPr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:47:57 -0500
From: Andreas Schwab <schwab@suse.de>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       petkovbb@gmail.com, j-nomura@ce.jp.nec.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <jelk5k62uy.fsf@sykes.suse.de>
	<58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com>
	<20080218.135827.74754725.k-ueda@ct.jp.nec.com>
X-Yow: This is a NO-FRILLS flight -- hold th' CANADIAN BACON!!
Date: Sat, 23 Feb 2008 16:47:50 +0100
In-Reply-To: <20080218.135827.74754725.k-ueda@ct.jp.nec.com> (Kiyoshi Ueda's
	message of "Mon\, 18 Feb 2008 13\:58\:27 -0500 \(EST\)")
Message-ID: <jek5kvisih.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kiyoshi Ueda <k-ueda@ct.jp.nec.com> writes:

> Could you try this patch?
> I've only done a compile test, so this patch may not work.

Unfortunately, that is not enough to get DVD burning working again.
This is the error that growisofs is getting:

ioctl(6, SG_IO, {'S', SG_DXFER_TO_DEV, cmd[10]=[2a, 00, 00, 00, 03, 10, 00, 00, 10, 00], mx_sb_len=64, iovec_count=0, dxfer_len=32768, timeout=60000, flags=0x3, data[32768]=["\360R\360\314Wt\277\241\36.\347\356L$\201]\210\372_~]I\213\366\253SV\2\372\356\312\257"...], status=02, masked_status=01, sb[0]=[], host_status=0, driver_status=0, resid=32768, duration=0, info=0x1}) = 0
write(2, ":-( unable to WRITE@LBA=310h: ", 30) = 30

It looks like the sense buffer is not filled in.  In a successfully run
of growisfs under 2.6.24.2 the sense code is "LONG WRITE IN PROGRESS".

I also see that resid always equals dxfer_len even when the transfer was
successful, although growisofs does not seem to care.  With 2.6.24.2
resid is only non-zero when a sense error occurred.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
