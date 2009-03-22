Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZCVAuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZCVAuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 20:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZCVAuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 20:50:22 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39742 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZCVAuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 20:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=OVABpz03afxEQR7DYROQ8WgYzeZEpiFNFFX+PtKFcg1Y/wGQyfnYbKZZ3FbRO+szO3
         fQwIkjOZfXocZJXI4+qfvexy2uLain01gpCbS9d6viKaA9hZ7nHGfN50JQOmrpDwNBf5
         +YErW1LXfyzvWcKfXtAZJQSFFeAcOHWTQoXqU=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: df -h shows ~10 times bigger size when umounting pendrive
Date: Sun, 22 Mar 2009 01:50:15 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903220150.16004.a.miskiewicz@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have 1GiB pendrive:

[ 1494.641661] scsi 4:0:0:0: Direct-Access              GOODDRIVE        1100 
PQ: 0 ANSI: 0 CCS
[ 1494.643482] sd 4:0:0:0: [sdb] 1957888 512-byte hardware sectors: (1.00 
GB/956 MiB)
[ 1494.644599] sd 4:0:0:0: [sdb] Write Protect is off
[ 1494.644604] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[ 1494.644609] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[ 1494.647107] sd 4:0:0:0: [sdb] 1957888 512-byte hardware sectors: (1.00 
GB/956 MiB)
[ 1494.648224] sd 4:0:0:0: [sdb] Write Protect is off
[ 1494.648230] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[ 1494.648234] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[ 1494.648241]  sdb: sdb1
[ 1494.657345] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[ 1494.657564] sd 4:0:0:0: Attached scsi generic sg2 type 0
[ 1494.658212] usb-storage: device scan complete

pendrive was mounted on /media/floppy

[arekm@t400 ~]$ df -h
System plik�w         rozm. u�yte dost. %u�. zamont. na
/dev/sda3             9,6G  4,2G  5,5G  44% /          
/dev/mapper/home      127G   52G   75G  42% /home      
tmpfs                 1,0G   28K  1,0G   1% /tmp       
none                  2,0G   12K  2,0G   1% /dev/shm   
/dev/sdb1             956M  657M  299M  69% /media/floppy

then I copied 650MB file and run umount /media/floppy

While umount was running and data were synced on the
pendrive df -h showed:

[arekm@t400 ~]$ df -h
System plik�w         rozm. u�yte dost. %u�. zamont. na
/dev/sda3             9,6G  4,2G  5,5G  44% /
/dev/mapper/home      127G   52G   75G  42% /home
tmpfs                 1,0G   28K  1,0G   1% /tmp
none                  2,0G   12K  2,0G   1% /dev/shm
/dev/sdb1             9,6G  4,2G  5,5G  44% /media/floppy


So it started to show 9.6G size when in process of umount.

Doesn't sound "normal" and correct.

[arekm@t400 ~]$ uname -a
Linux t400 2.6.29-rc8 #105 SMP Sun Mar 22 00:47:52 CET 2009 x86_64 
Intel(R)_Core(TM)2_Duo_CPU_____T9400__@_2.53GHz PLD Linux

(actually from git from about 1 hour ago)
-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/


