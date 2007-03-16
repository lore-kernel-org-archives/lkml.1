Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbXCPM7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbXCPM7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 08:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933643AbXCPM7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 08:59:08 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:36277 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673AbXCPM7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 08:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Lhm7WturTLUpA/b6KXFuBmMPWxEB5rdGb/77eQW4wHW9KFiF5ePbOMcVhLbddRf6vfHG7hhgTjgC7uvVQx6S2XuugcDkMVDHz8sI62yFLuP5QPte1Y3jp/dWmgyDVmkvRcoBzZ4ZiXLIE0LhkbHxM82XZk5okzU5HCLlTLxrPd8=
Message-ID: <1b270aae0703160559r794cc36ake0248d71569cb5b8@mail.gmail.com>
Date: Fri, 16 Mar 2007 13:59:05 +0100
From: "Metathronius Galabant" <m.galabant@googlemail.com>
To: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: NFS: double dentries in directory with 2.6.20
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

today I experienced double directory entries from a NFS mounted dir,
e.g. the file "file1.ext" is listed *twice* in the output.

The following under a 2.6.20 NFS client; Server was 2.6.18.8, NFS over UDP.
Mountpoint was not superblock-shared because it was a unique mount.

ls output:

drwxr-xr-x  3 user grp  296 Mar 15 17:28 ./
drwxr-xr-x  3 user grp  296 Mar 15 17:28 ./
drwxr-xr-x  3 user grp   72 Mar 15 17:28 ../
drwxr-xr-x  3 user grp   72 Mar 15 17:28 ../
drwxr-xr-x  2 user grp   80 Mar 15 17:28 00001/
drwxr-xr-x  2 user grp   80 Mar 15 17:28 00001/
-rw-r--r--  1 user grp  357 Mar 15 17:28 00001.patterns.pvset
-rw-r--r--  1 user grp 2057 Mar 15 17:28 00001.proc.pbs
-rw-r--r--  1 user grp   66 Mar 15 17:28 00001.proc.pbs.dep
-rw-r--r--  1 user grp   23 Mar 15 17:28 00001.proc.pbs.id
-rw-r--r--  1 user grp    0 Mar 15 17:28 00001.proc.pbs.queued
-rw-r--r--  1 user grp    0 Mar 15 17:28 00001.proc.pbs.queued
-rw-r--r--  1 user grp  784 Mar 15 17:28 00001.proc.pvset

strace for getdents():

getdents64(3, {{d_ino=14652528, d_off=1, d_type=DT_DIR, d_reclen=24,
d_name="."} {d_ino=14652526, d_off=2, d_type=DT_DIR, d_reclen=24,
d_name=".."} {d_ino=14654778, d_off=3, d_type=DT_DIR, d_reclen=32,
d_name="00001"} {d_ino=14656129, d_off=4, d_type=DT_REG, d_reclen=48,
d_name="00001.proc.pbs.queued"} {d_ino=14652528, d_off=5,
d_type=DT_DIR, d_reclen=24, d_name="."} {d_ino=14652526, d_off=6,
d_type=DT_DIR, d_reclen=24, d_name=".."} {d_ino=14654778, d_off=7,
d_type=DT_DIR, d_reclen=32, d_name="00001"} {d_ino=14656129, d_off=8,
d_type=DT_REG, d_reclen=48, d_name="00001.proc.pbs.queued"}
{d_ino=14656022, d_off=9, d_type=DT_REG, d_reclen=40,
d_name="00001.proc.pbs.id"} {d_ino=14654835, d_off=10, d_type=DT_REG,
d_reclen=40, d_name="00001.proc.pbs.dep"} {d_ino=14654838, d_off=11,
d_type=DT_REG, d_reclen=40, d_name="00001.proc.pvset"}
{d_ino=14654841, d_off=12, d_type=DT_REG, d_reclen=40,
d_name="00001.patterns.pvset"} {d_ino=14654832, d_off=13,
d_type=DT_REG, d_reclen=40, d_name="00001.proc.pbs"}}, 32768) = 456

Only umounting and remounting did cure the problem which hasn't
reappeared as of now. The problem seemed to be localized into one
directory.

ATM I don't know how to track that down or supply any more information.
Please include me on CC.

Cheers,
M
