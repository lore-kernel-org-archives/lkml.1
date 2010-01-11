Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970Ab0AKGoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0AKGoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859Ab0AKGoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:44:54 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:47792 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0AKGox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:44:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DtGA+GwgcUtgZocokg2BJf96q0NoyfOUbIMQgGIOrhRj1y7jwIEbA49BYNssMlDaJq
         HBvOTh/sdvtfRVJM9JyYIMzl5k+W50zE9nb9LL16d6mSskL/HnDkexEx6HpJfn5XwjSc
         zG03E/bDnxYFPysFTV4m5vj44epwur2/A5OkI=
MIME-Version: 1.0
In-Reply-To: <4B4A7BC7.6060106@kernel.org>
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
	 <4B484829.6060405@kernel.org>
	 <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>
	 <4B4A7BC7.6060106@kernel.org>
Date: Mon, 11 Jan 2010 07:44:51 +0100
Message-ID: <64bb37e1001102244mbb77e9bg2257aec34d653dc3@mail.gmail.com>
Subject: Re: MSI broken in libata?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 2:15 AM, Tejun Heo <tj@kernel.org> wrote:
> On 01/10/2010 01:33 PM, Torsten Kaiser wrote:
>> I did try the patch from Robert Hancock in
>> http://lkml.org/lkml/2010/1/6/417 ,but without success.
>>
>> if you need any more information, or have something for me to try,
>> please just ask. I did look at the code and the documentation about
>> enabling MSI, but did not see anything (obvious) wrong, so I don't
>> know what to try next.
>
> Can you please try the attached patch?

Yes, but as expected it does not change the result.

After applying the patch and doing a test write, I got the following
error messages:
[   89.950055] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   89.960910] ata2.00: failed command: WRITE FPDMA QUEUED
[   89.969853] ata2.00: cmd 61/00:00:fd:27:3e/04:00:01:00:00/40 tag 0
ncq 524288 out
[   89.969855]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   89.992210] ata2.00: status: { DRDY }
[   89.999569] ata2: hard resetting link
[   92.190069] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   97.190041] ata2.00: qc timeout (cmd 0xec)
[   97.197898] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   97.207622] ata2.00: revalidation failed (errno=-5)
[   97.216094] ata2: hard resetting link
[   99.410049] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  109.410027] ata2.00: qc timeout (cmd 0xec)
[  109.417694] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  109.427351] ata2.00: revalidation failed (errno=-5)
[  109.435733] ata2: limiting SATA link speed to 1.5 Gbps
[  109.444384] ata2: hard resetting link
[  111.640049] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  141.640029] ata2.00: qc timeout (cmd 0xec)
[  141.647650] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  141.657255] ata2.00: revalidation failed (errno=-5)
[  141.665577] ata2.00: disabled
[  141.671956] ata2.00: device reported invalid CHS sector 0
[  141.680792] ata2: hard resetting link
[  143.880049] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  143.880065] ata2: EH complete
[  143.880096] sd 1:0:0:0: [sdb] Unhandled error code
[  143.880099] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  143.880106] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 3e 27 fd 00 04 00 00
[  143.880121] end_request: I/O error, dev sdb, sector 20850685

The last error gets repeated for different sectors, then the xfs
filesystem shuts itself down.

Torsten
