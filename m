Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZJEOue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZJEOue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZJEOud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:50:33 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:49664 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZJEOuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aAnjk5rgTpaH90grccXZV50TNXdG+Uqk66RFfHV9jQH9FypuDcEME2x28Kre9kE6e9
         0TAMn4H45WH3lwhxchOvfEmpibODwFGEBrvBaUz09Y6GdoJ/RcdF81koMFwQksrFmLNp
         8bP1psE5Mm7HsRqO4kZAD8hGI79HCF5RznAHE=
MIME-Version: 1.0
In-Reply-To: <804dabb00910031908k68f91fdetfab8b34aa5e7a9a4@mail.gmail.com>
References: <804dabb00910020707r9820d8bpe371baf1efb67c1@mail.gmail.com>
	 <4AC7F411.1090305@gmail.com>
	 <804dabb00910031908k68f91fdetfab8b34aa5e7a9a4@mail.gmail.com>
Date: Mon, 5 Oct 2009 10:49:54 -0400
Message-ID: <804dabb00910050749o10fa97cawbe4422efb030e4ac@mail.gmail.com>
Subject: Re: /dev/sdb not detected anymore?
From: Peter Teoh <htmldeveloper@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

problem resolved:   the cause is due to the rootfs being 100% full,
and that (*i think*) result in udev not behaving properly when loading
all the devices.   just by toggling between 100% full vs not full for
the rootfs, the /dev/sdb will become not detected vs detected.

On Sat, Oct 3, 2009 at 10:08 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> thank you for the response.   the bug report i just raised is this:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=14319
>
> and attachment is:
>
> http://bugzilla.kernel.org/attachment.cgi?id=23255
>
> Thanks.
>
> On Sat, Oct 3, 2009 at 9:02 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> On 10/02/2009 08:07 AM, Peter Teoh wrote:
>>>
>>> I just built my 2.6.32-rc2 (from linus-git) yesterday, and repeated
>>> today again, starting from "make mrproper", and consistently both
>>> version cannot detect my /dev/sdb, which is the second SATA harddisk.
>>>  The first SATA is detected as follows in dmesg:
>>>
>>>     742 [    4.595949] scsi 2:0:0:0: Direct-Access     ATA
>>> ST3500630AS      3.AA PQ: 0 ANSI: 5
>>>     743 [    4.596116] sd 2:0:0:0: [sda] 976773168 512-byte logical
>>> blocks: (500 GB/465 GiB)
>>>     744 [    4.596213] sd 2:0:0:0: [sda] Write Protect is off
>>>     745 [    4.596216] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
>>>     746 [    4.596258] sd 2:0:0:0: [sda] Write cache: enabled, read
>>> cache: enabled, doesn't support DPO or FUA
>>>     747 [    4.596467]  sda: sda1 sda2 sda3 sda4<  sda5 sda6 sda7 sda8
>>> sda9>
>>>     748 [    4.674607] sd 2:0:0:0: [sda] Attached SCSI disk
>>>
>>> And from sg_inq:
>>>
>>> standard INQUIRY:
>>>   PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>>>   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>>>   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>>>   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>>>   [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
>>>   [SPI: Clocking=0x0  QAS=0  IUS=0]
>>>     length=96 (0x60)   Peripheral device type: disk
>>>  Vendor identification: ATA
>>>  Product identification: ST3500630AS
>>>  Product revision level: 3.AA
>>>  Unit serial number:             9QG14T5Z
>>>
>>> But the second SATA (identical in type/model) is not detectable.
>>> Upon rebooting to my previous 2.6.31 kernel version, it became
>>> detected and usable - absolutely nothing else is touch.   So what is
>>> it in the latest kernel which is giving the problem?
>>
>> We need more details, can you post the full boot log including the actual
>> libata messages from the working and non-working kernels?
>>
>
> and the full bootlog is here (not in bugzilla submission) (timestamp
> removed for your easy comparison).
>
> --
> Regards,
> Peter Teoh
>



-- 
Regards,
Peter Teoh
