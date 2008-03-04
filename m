Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYCDNf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYCDNf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYCDNfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:35:13 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:57215 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbYCDNfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:35:12 -0500
Date: Tue, 4 Mar 2008 22:30:13 +0900
To: htejun@gmail.com
Cc: efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       tomof@acm.org, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <47CD4355.4050401@gmail.com>
References: <20080304093536.GH6704@kernel.dk>
	<1204634238.5997.5.camel@homer.simson.net>
	<47CD4355.4050401@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080304223006A.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 21:40:53 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Mike Galbraith wrote:
> > On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
> > 
> >> Looks excellent to me, has a variant of this been tested as OK by the
> >> users reporting the regression?
> > 
> > K3b burning seems to be a nogo here.  This is git pulled this morning
> > though, so it's a somewhat different tree than previously tested fwtw.
> > 
> > [  136.440021] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > [  136.440043] ata1.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
> > [  136.440045]          cdb 51 00 00 00 00 00 00 00  02 00 00 00 00 00 00 00
> > [  136.440047]          res 58/00:02:00:02:00/00:00:00:00:00/b0 Emask 0x2 (HSM violation)
> > [  136.440053] ata1.01: status: { DRDY DRQ }
> > [  136.440086] ata1: soft resetting link
> > [  165.327627] ata1.01: qc timeout (cmd 0xa1)
> > [  165.327627] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> > [  165.327627] ata1.01: revalidation failed (errno=-5)
> > [  165.327627] ata1: failed to recover some devices, retrying in 5 secs
> > [  177.272373] ata1: port is slow to respond, please be patient (Status 0x80)
> > [  180.388879] ata1: device not ready (errno=-16), forcing hardreset
> > [  180.388879] ata1: soft resetting link
> > [  210.832471] ata1.01: qc timeout (cmd 0xa1)
> > [  210.832471] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> > [  210.832471] ata1.01: revalidation failed (errno=-5)
> > [  210.832471] ata1: failed to recover some devices, retrying in 5 secs
> > [  223.392899] ata1: port is slow to respond, please be patient (Status 0x80)
> > [  225.920376] ata1: device not ready (errno=-16), forcing hardreset
> > [  225.920376] ata1: soft resetting link
> > [  256.542565] ata1.01: qc timeout (cmd 0xa1)
> > [  256.542565] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> > [  256.542565] ata1.01: revalidation failed (errno=-5)
> > [  256.542565] ata1.01: disabled
> 
> Aiee... device going down after timing out on READ_DISC_INFO.  That's
> gruesome.  Can you please try the other patches?

Tejun, I thought that libata needs a fix for sum(sg) != rq->data_len. No?

Now Jens' git tree should work with all the non libata stuff, ide,
firewire, bsg, etc. But I'm not sure about libata.
