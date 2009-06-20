Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZFTSgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZFTSgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZFTSgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:36:41 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:56739 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbZFTSgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <20090620182617.GM19977@parisc-linux.org>
References: <488605.71443.qm@web32605.mail.mud.yahoo.com> <20090527133125.c36381b5.akpm@linux-foundation.org> 
	<ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> 
	<170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45> 
	<971371.70253.qm@web32604.mail.mud.yahoo.com> <4A3D104E.9060105@hp.com> 
	<20090620165853.GL19977@parisc-linux.org> <ac3eb2510906201119r5c528a3s67cd04bdbfdd1d9c@mail.gmail.com> 
	<20090620182617.GM19977@parisc-linux.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 20 Jun 2009 20:36:25 +0200
Message-ID: <ac3eb2510906201136v4c6eac1bwffd2aed3e38c6ae1@mail.gmail.com>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: Matthew Wilcox <matthew@wil.cx>
Cc: jim owens <jowens@hp.com>, Martin Knoblauch <knobi@knobisoft.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, mike.miller@hp.com, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 20:26, Matthew Wilcox<matthew@wil.cx> wrote:
> On Sat, Jun 20, 2009 at 08:19:43PM +0200, Kay Sievers wrote:
>> On Sat, Jun 20, 2009 at 18:58, Matthew Wilcox<matthew@wil.cx> wrote:
>>
>> > but I don't know what udev is doing. ??The udev source doesn't seem to
>> > read PCI vpd itself:
>> >
>> > udev-0.141$ find -type f |xargs grep -il vpd
>> > ./extras/volume_id/lib/adaptec_raid.c
>> > ./extras/scsi_id/scsi_id.8
>> > ./extras/scsi_id/scsi.h
>> > ./extras/scsi_id/scsi_id.config
>> > ./extras/scsi_id/scsi_serial.c
>> >
>> > so there must be some script that it's invoking which is doing that.
>> > Anyone familiar with udev?
>>
>> scsi_id is usually also called for cciss devices:
>>   KERNEL=="cciss*", ..., IMPORT{program}="scsi_id ...
>
> yes, but it's getting SCSI VPD (by asking for mode pages from the SCSI
> device).  This problem is with PCI VPD which is totally different.

Ah, I see. There is no tool around udev, I know of, which does this.

Maybe someone is still using the broken-by-design libsysfs, which
opens _every_ file it can find in /sys, even when not asked for
anything specific.

Thanks,
Kay
