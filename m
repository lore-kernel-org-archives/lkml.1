Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbYFXHOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbYFXHOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYFXHOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:14:30 -0400
Received: from nebensachen.de ([195.34.83.29]:53322 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYFXHO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:14:29 -0400
X-Hashcash: 1:20:080624:bzolnier@gmail.com::GZztgoKQInciD57E:00000000000000000000000000000000000000000003dRH
X-Hashcash: 1:20:080624:linux-ide@vger.kernel.org::nkKTTzZ1XaVX+Pcr:0000000000000000000000000000000000005XTo
X-Hashcash: 1:20:080624:linux-kernel@vger.kernel.org::9yJnepYOtpevmQFv:0000000000000000000000000000000003/LP
X-Hashcash: 1:20:080624:randy.dunlap@oracle.com::xKaGWU+p5TvplY6v:0000000000000000000000000000000000000001oZ
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
References: <87k5gmz596.fsf@denkblock.local> <87wskhuk98.fsf@denkblock.local>
	<87r6apuk16.fsf@denkblock.local>
	<200806240041.46109.bzolnier@gmail.com>
Date: Tue, 24 Jun 2008 09:12:04 +0200
In-Reply-To: <200806240041.46109.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Tue, 24 Jun 2008 00:41:45 +0200")
Message-ID: <87wskfs3wb.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Monday 23 June 2008, Elias Oltmanns wrote:
> [...]
>
>> +static inline void ide_complete_drive_reset(ide_drive_t *drive)
>> +{
>> +	struct request *rq = HWGROUP(drive)->rq;
>> +
>> +	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
>
> Shouldn't we be also checking for !rq->rq_disk here?

Well, it would probably feel more consistent. However, as far as I can
tell, opcodes 0x20 and above aren't used by any of the ULDs right now
and it would probably make sense to reserve that range (or part of it)
for the generic ide_special_rq() handler. Consequently, it is sufficient
to check for REQ_TYPE and op code, as I did.

Regards,

Elias
