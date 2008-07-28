Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYG1GBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYG1GBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 02:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYG1GB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 02:01:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:57584 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYG1GBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 02:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:user-agent:from;
        b=GVpCC33KGyilc886pQ+B9pCSOqb5f6RskEFuBrlcP9vA5cEB07kD2KPAb67NEFuCOf
         jVAIXRCt5W9EYXDSb5pCQqrF9RFwKSzERqo9cDylYsuiHfZP1lGyA+c1Q/jUfSz13w9t
         iTSwcWWVApV9MKIS9jw55NEMxyW8DRV5gUgpk=
Date: Mon, 28 Jul 2008 08:01:33 +0200
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: IDE S.M.A.R.T. ioctl errors
Message-ID: <20080728060133.GA14007@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

i'm getting the following when the S.M.A.R.T. daemon starts during boot (verbose
printk added by me):

...
[   29.974243] ide_cmd_ioctl: args[0]: 0xec, args[1]: 0x0, args[2]: 0x0 args[3]: 0x1
[   30.052422] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd8 args[3]: 0x0
[   30.361782] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x0, args[2]: 0xd0 args[3]: 0x1
[   30.499581] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd1 args[3]: 0x1
[   30.516111] hda: task_no_data_intr: status=0x58 { DriveReady SeekComplete DataRequest }
[   30.516387] ide: failed opcode was: 0xb0
[   30.516510] hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   30.517423] ide: failed opcode was: unknown
[   30.517730] hda: drive not ready for command
[   30.517793] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x6, args[2]: 0xd5 args[3]: 0x1
[   30.551903] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd5 args[3]: 0x1
[   30.585392] ide_cmd_ioctl: args[0]: 0xec, args[1]: 0x0, args[2]: 0x0 args[3]: 0x1
[   30.605220] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd8 args[3]: 0x0
[   30.850747] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x0, args[2]: 0xd0 args[3]: 0x1
[   31.000050] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd1 args[3]: 0x1
[   31.087848] hdb: task_no_data_intr: status=0x58 { DriveReady SeekComplete DataRequest }
[   31.088124] ide: failed opcode was: 0xb0
[   31.088409] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x6, args[2]: 0xd5 args[3]: 0x1
[   31.101375] hdb: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   31.101681] ide: failed opcode was: 0xb0
[   31.101775] hdb: drive not ready for command
[   31.101964] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd5 args[3]: 0x1
[   31.128299] hdb: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   31.128571] ide: failed opcode was: 0xb0
[   31.128669] hdb: drive not ready for command
[   31.144786] hdb: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   31.145060] ide: failed opcode was: 0xea
[   31.145166] hdb: drive not ready for command
[   31.599369] hdc: No disk in drive
[   32.105234] ide_cmd_ioctl: args[0]: 0xa1, args[1]: 0x0, args[2]: 0x0 args[3]: 0x1
[   32.162295] ide_cmd_ioctl: args[0]: 0xec, args[1]: 0x0, args[2]: 0x0 args[3]: 0x1
[   32.168927] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd8 args[3]: 0x0
[   32.339912] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x0, args[2]: 0xd0 args[3]: 0x1
[   32.439278] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd1 args[3]: 0x1
[   32.491542] hdd: task_no_data_intr: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.491820] ide: failed opcode was: 0xb0
[   32.492105] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x6, args[2]: 0xd5 args[3]: 0x1
[   32.492247] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.492531] ide: failed opcode was: 0xb0
[   32.492629] hdd: drive not ready for command
[   32.493059] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd5 args[3]: 0x1
[   32.493175] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.493454] ide: failed opcode was: 0xb0
[   32.493551] hdd: drive not ready for command
[   32.494440] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.494733] ide: failed opcode was: 0xea
[   32.494850] hdd: drive not ready for command
[   32.614821] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x0, args[2]: 0xd0 args[3]: 0x1
[   32.752564] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x6, args[2]: 0xd5 args[3]: 0x1
[   32.815267] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd5 args[3]: 0x1
[   32.875133] hdb: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.875443] ide: failed opcode was: 0xb0
[   32.875559] hdb: drive not ready for command
[   32.875991] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x0, args[2]: 0xd0 args[3]: 0x1
[   32.889735] hdb: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.890006] ide: failed opcode was: 0xb0
[   32.890100] hdb: drive not ready for command
[   32.890453] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x6, args[2]: 0xd5 args[3]: 0x1
[   32.891249] hdb: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.891260] ide: failed opcode was: 0xb0
[   32.891278] hdb: drive not ready for command
[   32.891625] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd5 args[3]: 0x1
[   32.904268] hdb: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.904579] ide: failed opcode was: 0xb0
[   32.904704] hdb: drive not ready for command
[   32.916044] hdb: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.916317] ide: failed opcode was: 0xea
[   32.916417] hdb: drive not ready for command
[   32.916519] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.916762] ide: failed opcode was: 0xb0
[   32.916875] hdd: drive not ready for command
[   32.916959] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x0, args[2]: 0xd0 args[3]: 0x1
[   32.917071] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.917313] ide: failed opcode was: 0xb0
[   32.917419] hdd: drive not ready for command
[   32.917507] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x6, args[2]: 0xd5 args[3]: 0x1
[   32.917618] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.917864] ide: failed opcode was: 0xb0
[   32.917971] hdd: drive not ready for command
[   32.918048] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd5 args[3]: 0x1
[   32.918164] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.918392] ide: failed opcode was: 0xb0
[   32.918491] hdd: drive not ready for command
[   32.918618] hdd: status error: status=0x58 { DriveReady SeekComplete DataRequest }
[   32.918844] ide: failed opcode was: 0xea
[   32.918949] hdd: drive not ready for command
...

and this is "caused" by
ide-use-correct-data-phase-for-smart-read-data-log-in-ide_cmd_ioctl.patch. This
happens, IMHO, because when you do ATA_CMD_SMART from userspace ioctl, one of
the cases is that the tf->feature flags have values which are inconsistent with
the ATA/ATAPI v.7 spec (6.54.5 SMART READ DATA):

"If the device does not support this command, if SMART is disabled, or if the
values in the Features, LBA Mid, or LBA High registers are invalid, the device
shall return command aborted."

For example this one:

[   30.499581] ide_cmd_ioctl: args[0]: 0xb0, args[1]: 0x1, args[2]: 0xd1 args[3]: 0x1
[   30.516111] hda: task_no_data_intr: status=0x58 { DriveReady SeekComplete DataRequest }
[   30.516387] ide: failed opcode was: 0xb0

However, the case with the SMART_READ_LOG looks correct above: args[2] = 0xd5
which is the tf->feature flag, cmd = 0xb0 (ATA_CMD_SMART). This one fails too, though.

-- 
Regards/Gruﬂ,
    Boris.
