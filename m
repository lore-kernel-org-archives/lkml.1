Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZIPOwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZIPOwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZIPOwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:52:08 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:55016 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZIPOwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:52:07 -0400
X-Greylist: delayed 1818 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 10:52:07 EDT
Date: Wed, 16 Sep 2009 16:21:37 +0200
From: Henning Fehrmann <henning.fehrmann@aei.mpg.de>
To: linux-kernel@vger.kernel.org
Subject: gzip sleeps until 'strace'ing the process
Message-ID: <20090916142137.GA25033@gretchen.aei.mpg.de>
MIME-Version: 1.0
User-Agent: Mutt/1.5.18 (2008-05-17)
X-MIMETrack: Itemize by SMTP Server on intranet/aei-hannover(Release 8.5HF224 | March 30, 2009) at
 09/16/2009 16:21:38,
	Serialize by Router on intranet/aei-hannover(Release 8.5HF224 | March 30, 2009) at
 09/16/2009 16:21:48,
	Serialize complete at 09/16/2009 16:21:48
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.9.16.140618
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __C230066_P5 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __FRAUD_419_CONTACT_NAME 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __RUS_OBFU_PHONE 0, __SANE_MSGID 0, __STOCK_PHRASE_24 0, __TO_MALFORMED_2 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

If you have some hints, please put me in the CC.

We launched a job which forks a 
gzip -cd 
which is basically zcat.
This process is accessing a file within a NFS mounted directory: 

# ps aux|grep gzip
user   32078  0.0  0.0   4140   552 pts/0    S+   15:06   0:00 gzip -cd -f file_in_NFS_mounted_directory

The file is properly ziped.

The process is in the sleep state - also the file can be accessed.

If I 'strace' it the process finishes successfully. 

# strace -p 32078
Process 32078 attached - interrupt to quit
write(1, "e-010 5.5565\n121.951418712 2.2249"..., 24578) = 24578
write(1, "3 -0.3036801 -3.1699e-011 5.30998"..., 32768) = 32768
write(1, "2015e-010 5.5565\n121.9529017461 2"..., 32768) = 32768
write(1, "\n121.9543512274 0.166872 -0.13840"..., 32768) = 32768
write(1, "-011 5.5565\n121.9558745249 5.2519"..., 32768) = 32768
write(1, "08331213 -4.2015e-010 5.80302\n121"..., 32768) = 32768
write(1, "1.9587130924 4.603975 -0.2485881 "..., 32768) = 32768
read(8, "\361\234a\325\305\3161\373x\307\324\312\240+\307\354\211Y\357cH\234\360\362\315\235NV\310O\\\212\236"..., 32768) = 14630
read(8, ""..., 18138)                   = 0
write(1, "600686259 5.408658 -0.5240481 -1."..., 32768) = 32768
write(1, "5.707316 -0.3587721 -4.2015e-010 "..., 32768) = 32768
write(1, "1.9627260083 5.766155 -0.3587721 "..., 30733) = 30733
close(8)                                = 0
exit_group(0)                           = ?
Process 32078 detached

I found it puzzling since strace should not have an influence on the state of a process.

In the /proc directory I found the follwing:

/proc/32078# cat status
Name:   gzip
State:  S (sleeping)
Tgid:   32078
Pid:    32078
PPid:   31592
TracerPid:      0
Uid:    5059    5059    5059    5059
Gid:    5000    5000    5000    5000
FDSize: 256
Groups: 5000 5001 5002
VmPeak:     4140 kB
VmSize:     4140 kB
VmLck:         0 kB
VmHWM:       552 kB
VmRSS:       552 kB
VmData:      492 kB
VmStk:        84 kB
VmExe:        52 kB
VmLib:      1432 kB
VmPTE:        32 kB
Threads:        1
SigQ:   0/68608
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: 0000000001300001
SigCgt: 0000000000805002
CapInh: 0000000000000000
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: fffffffffffffeff
voluntary_ctxt_switches:        55
nonvoluntary_ctxt_switches:     1

Do you have any idea?

Cheers,
Henning Fehrmann
