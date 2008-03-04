Return-Path: <linux-kernel-owner+w=401wt.eu-S1764328AbYCDMlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764328AbYCDMlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYCDMlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:41:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:58730 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbYCDMlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:41:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=S51KVMqsVzjMMVCPkh3mR5faf8A/nFR1p/bI6OGRrv7HBLQO8r9LVTdYG0DVcCiNdrba/cnt6j2PqsWerk59LQjVuvLUBUSj4GIdYvl504tv3dgP7CgXZgYatqwB+bD/Yt8IFdmeIO80XCYHC02aOcK0GIX6ylvtmGXfsqsfd2o=
Message-ID: <47CD4355.4050401@gmail.com>
Date: Tue, 04 Mar 2008 21:40:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>	 <20080304085944.GG6704@kernel.dk>	 <20080304180648W.fujita.tomonori@lab.ntt.co.jp>	 <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>	 <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net>
In-Reply-To: <1204634238.5997.5.camel@homer.simson.net>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
> 
>> Looks excellent to me, has a variant of this been tested as OK by the
>> users reporting the regression?
> 
> K3b burning seems to be a nogo here.  This is git pulled this morning
> though, so it's a somewhat different tree than previously tested fwtw.
> 
> [  136.440021] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> [  136.440043] ata1.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
> [  136.440045]          cdb 51 00 00 00 00 00 00 00  02 00 00 00 00 00 00 00
> [  136.440047]          res 58/00:02:00:02:00/00:00:00:00:00/b0 Emask 0x2 (HSM violation)
> [  136.440053] ata1.01: status: { DRDY DRQ }
> [  136.440086] ata1: soft resetting link
> [  165.327627] ata1.01: qc timeout (cmd 0xa1)
> [  165.327627] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  165.327627] ata1.01: revalidation failed (errno=-5)
> [  165.327627] ata1: failed to recover some devices, retrying in 5 secs
> [  177.272373] ata1: port is slow to respond, please be patient (Status 0x80)
> [  180.388879] ata1: device not ready (errno=-16), forcing hardreset
> [  180.388879] ata1: soft resetting link
> [  210.832471] ata1.01: qc timeout (cmd 0xa1)
> [  210.832471] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  210.832471] ata1.01: revalidation failed (errno=-5)
> [  210.832471] ata1: failed to recover some devices, retrying in 5 secs
> [  223.392899] ata1: port is slow to respond, please be patient (Status 0x80)
> [  225.920376] ata1: device not ready (errno=-16), forcing hardreset
> [  225.920376] ata1: soft resetting link
> [  256.542565] ata1.01: qc timeout (cmd 0xa1)
> [  256.542565] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  256.542565] ata1.01: revalidation failed (errno=-5)
> [  256.542565] ata1.01: disabled

Aiee... device going down after timing out on READ_DISC_INFO.  That's
gruesome.  Can you please try the other patches?

Thanks.

-- 
tejun
