Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0BDDqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:46:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:38922 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751965Ab0BDDqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:46:13 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19VElgjSQBVuqeJedpMFZLBJYeI+JYhj7DexWbNzx
	wR0VTEV4DuJ0ty
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: patch idr-fix-a-critical-misallocation-bug.patch added to 2.6.32-stable tree
Date: Thu, 4 Feb 2010 04:46:02 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-sidux-686; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
References: <12651725962428@site> <1265203299.2919.1.camel@localhost> <20100203233720.GA28271@suse.de>
In-Reply-To: <20100203233720.GA28271@suse.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9LkaLO/BfJHFIrt"
Message-Id: <201002040446.05068.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9LkaLO/BfJHFIrt
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi

[ Sorry for not reporting this earlier today, while 
  idr-fix-a-critical-misallocation-bug was still part of queue-2.6.32, but 
  bisecting this (and previously net-restore-ip-source-validation.patch) 
  took its time. ]

On Thursday 04 February 2010, Greg KH wrote:
> On Wed, Feb 03, 2010 at 08:21:39AM -0500, Eric Paris wrote:
> > On Wed, 2010-02-03 at 14:21 +0900, Tejun Heo wrote:
> > 
> > > > Eric Paris located a bug in idr.  With IDR_BITS of 6, it grows to three
> > > > layers when id 4096 is first allocated.  When that happens, idr wraps
> > > > incorrectly and searches the idr array ignoring the high bits.  The
> > > > following test code from Eric demonstrates the bug nicely.
> > > ...
> > > > Based-on-patch-from: Eric Paris <eparis@redhat.com>
> > > > Reported-by: Eric Paris <eparis@redhat.com>
> > > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > Greg, can this wait a bit more, maybe until the next -stable release?
> > > The code there is very fragile and this has been broken forever so I
> > > think it would be better if we wait a bit more while it gets testing
> > > mainline.

Just as a side note, this patch as part of the 2.6.32 stable queue (before 
this patch was removed again) seems to break logging into KDE 4.3.4 through
kdm on several different systems with Intel chipsets/ graphics (kvm 
active). X and kdm start normally, logging in shows the ksplash, which 
quickly terminates the xsession and dumps back to kdm. Removing just this 
patch from 2.6.32 + (previous) stable queue fixes the problem for me; 
however 2.6.33-rc6-git3 seems to be affected as well, but freezes X, 
instead of "just" terminating the current X session and reverting to kdm.

While I have reports from several different intel chipsets, I can 
personally reproduce it on an Intel D945GCLF2 mainboard:

00:00.0 Host bridge [0600]: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub [8086:2770] (rev 02)                                                                                           
00:02.0 VGA compatible controller [0300]: Intel Corporation 82945G/GZ Integrated Graphics Controller [8086:2772] (rev 02)                                                                         
00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller [8086:27d8] (rev 01)                                                                         
00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 [8086:27d0] (rev 01)                                                                                         
00:1c.2 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 [8086:27d4] (rev 01)                                                                                         
00:1c.3 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 [8086:27d6] (rev 01)                                                                                         
00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 [8086:27c8] (rev 01)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 [8086:27c9] (rev 01)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 [8086:27ca] (rev 01)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 [8086:27cb] (rev 01)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller [8086:27cc] (rev 01)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev e1)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge [8086:27b8] (rev 01)
00:1f.1 IDE interface [0101]: Intel Corporation 82801G (ICH7 Family) IDE Controller [8086:27df] (rev 01)
00:1f.2 IDE interface [0101]: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA IDE Controller [8086:27c0] (rev 01)
00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus Controller [8086:27da] (rev 01)
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 02)

===
[ the following might of course be unrelated ]
Oops captured with 2.6.33-rc6-git3 (X and kdm start up without problems, 
but freezes during ksplash - the system remains operationable through ssh):

[drm:i915_gem_do_execbuffer] *ERROR* Invalid object handle 1073741824 at index 23                
BUG: unable to handle kernel paging request at ffffffff00000080                                  
IP: [<ffffffffa00951af>] i915_gem_do_execbuffer+0x79f/0x1370 [i915]                              
PGD 14c0067 PUD 0                                                                                
Oops: 0000 [#1] PREEMPT SMP                                                                      
last sysfs file: /sys/devices/virtual/sound/timer/uevent                                         
CPU 0                                                                                            
Pid: 1846, comm: Xorg Tainted: G        W  2.6.33-rc6-sidux-amd64 #1 D945GCLF2/                  
RIP: 0010:[<ffffffffa00951af>]  [<ffffffffa00951af>] i915_gem_do_execbuffer+0x79f/0x1370 [i915]  
RSP: 0018:ffff88007c49fbf8  EFLAGS: 00010286                                                     
RAX: ffff88007e80aac0 RBX: 00000000fffffff7 RCX: 000000000000001e                                
RDX: ffffffff00000000 RSI: ffffffffa0042710 RDI: ffff88007e162a80                                
RBP: 0000000000000018 R08: 0000000000000001 R09: 0000000000000020                                
R10: 0000000000000000 R11: 000000000000006e R12: ffff88007e80aa00                                
R13: ffff88007c49fd18 R14: ffff88007e80aa00 R15: ffff88007c49fd18                                
FS:  00007f5bf591d790(0000) GS:ffff880001800000(0000) knlGS:0000000000000000                     
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                
CR2: ffffffff00000080 CR3: 000000007c480000 CR4: 00000000000006f0                                
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                
Process Xorg (pid: 1846, threadinfo ffff88007c49e000, task ffff88007c4fd280)                     
Stack:                                                                                           
 ffff88007bebdb80 0000000000000000 ffff88007bebde18 ffffffff8135139b                             
<0> ffff88007f002dc0 ffff880000000040 fffffff57f35a800 ffff88007e2f7800                          
<0> 0000000000001000 ffff88007c49fd48 ffff88007e80aa00 ffff88007e2f6000                          
Call Trace:                                                                                      
 [<ffffffff8135139b>] ? unix_stream_recvmsg+0x28b/0x620
 [<ffffffffa0095fa0>] ? i915_gem_execbuffer+0x0/0x410 [i915]
 [<ffffffffa00961b0>] ? i915_gem_execbuffer+0x210/0x410 [i915]
 [<ffffffffa00904d5>] ? i915_gem_sw_finish_ioctl+0x95/0xd0 [i915]
 [<ffffffffa0040958>] ? drm_ioctl+0x308/0x440 [drm]
 [<ffffffffa0095fa0>] ? i915_gem_execbuffer+0x0/0x410 [i915]
 [<ffffffff8111ef2f>] ? do_sync_read+0xbf/0x100
 [<ffffffff81071924>] ? bit_waitqueue+0x14/0xc0
 [<ffffffff8112eed5>] ? vfs_ioctl+0x35/0xd0
 [<ffffffff8112f098>] ? do_vfs_ioctl+0x88/0x570
 [<ffffffff810566b3>] ? do_setitimer+0x1c3/0x240
 [<ffffffff8112f600>] ? sys_ioctl+0x80/0xa0
 [<ffffffff8100a002>] ? system_call_fastpath+0x16/0x1b
Code: eb 48 8b 74 24 68 44 8b 4e 08 45 85 c9 74 4a 4c 8b 64 24 50 31 ed 49 89 f5 0f 1f 00 48 63 c5 49 8d 04 c4 48 8b 10 48 85 d2 74 25 <48> 8b 92 80 00 00 00 c7 82 a0 00 00 00 00 00 00 00 48 8b 38 48
RIP  [<ffffffffa00951af>] i915_gem_do_execbuffer+0x79f/0x1370 [i915]
 RSP <ffff88007c49fbf8>
CR2: ffffffff00000080
---[ end trace 88853e816bdbf457 ]---

I will test 2.6.33 HEAD with idr-fix-a-critical-misallocation-bug.patch
reverted when I get home tonight (UTC+1), I'm likely not able to respond 
before that either.

> > I'm ok with that as well.  inotify should not be able to trip up on this
> > condition any more thanks to other changes to inotify.
> 
> Ok, I've now dropped it.
> 
> thanks,
> 
> greg k-h

Regards
	Stefan Lippers-Hollmann

Post scriptum: 
Xorg.0.log.gz, kdm.log.gz and xsession errors.gz are taken from 
2.6.32.7+queue-2.6.32, including idr-fix-a-critical-misallocation-bug.patch

system:	up to date Debian sid/ unstable
		ii  hal                                                 0.5.14-2                   Hardware Abstraction Layer
		ii  libdrm-intel1                                       2.4.17-1                   Userspace interface to intel-specific kernel DRM serv
		ii  libdrm2                                             2.4.17-1                   Userspace interface to kernel DRM services -- runtime
		ii  libhal-storage1                                     0.5.14-2                   Hardware Abstraction Layer - shared library for stora
		ii  libhal1                                             0.5.14-2                   Hardware Abstraction Layer - shared library
		ii  xserver-xorg-core                                   2:1.7.4-2                  Xorg X server - core server
		ii  xserver-xorg-video-intel                            2:2.9.1-2                  X.Org X server -- Intel i8xx, i9xx display driver

--Boundary-00=_9LkaLO/BfJHFIrt
Content-Type: application/x-gzip;
  name="dmesg-2.6.32.7+queue-2.6.32-EXcluding-idr-working.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg-2.6.32.7+queue-2.6.32-EXcluding-idr-working.gz"

H4sICOs/aksCA2RtZXNnLTIuNi4zMi43K3F1ZXVlLTIuNi4zMi1FWGNsdWRpbmctaWRyLXdvcmtp
bmcA7dvvTxs3GAfw181f8ewVICVwd0n4cdKmAmUlqsYYMGnSVEXO2ZdY3Nmp7SSkf/0eJ0DC1Bba
vRi032pSycXPcx/7a1/JpCRJQu9OP241abPNP9ZHuklZsvip3mq82sw6e51kOYZalHUO7l+9Xoz7
cnU33UtW1d2sm6yqO49X77W7a9X7q1ePV+v9JO37ejDxFEfm/F9abrdzOj/uUe/sio6o9Qu9vexR
ekCblZqqqkmVnW3Fy72LP/hy4/D4vJdTb+d3csrbiSvUg170d3ITb9iKf6XleyqsKStdBE8zHUYU
y7lyqK2hy9+O0ofjd9/f9S9JmOVg6fRUOdKexFToSgwqRaV1FEZ8SaqpLlST5nZCfmQnlaSJV6QD
aeODEpJsySMVGRG4zW2zhjZBVX1nhjn9ql09E06RHwueC/esbHGtJCOFbFlTzbejJt6gEGYjkH1Q
Lm28NhMmULAktV/4FjZtqLxvrsJk3OQ5SdLlen3sGwcUygXBFWEkQrzoyM95AjWNBE+cyokpAq+Z
qNaLL87eNim4Oc9Zm+FinhvG9svZqC9VUEXYIDuOZdsNIlHxxEi7D/yeLxZLmGXEMRgrFbXS+yHX
PojQ54F+/d3TN4fUi7dexT3YTlZb5/Bu63DTT22dLPtsC16cEP2VCMoUcwq65sB5OXc7jZEUrcWM
edh44rTlvcsbb2wNx5zccJebhG8kfKCilj/zq8Wfp9Sl31iXfWMdnHDC+eM4sS5wwgnnc3NiXeCE
E048X/D753OY3/d+vwznHbkjB5w/5I4ckANyR+7IAecPuSMH5IDckfsP9v+zkAPOH3JHDjh/yB25
IwecP+SO84cccP6QO3LA+UPuOH/IAecPuSOH7/78TfyA0laWx8Eq0EgPR9xAKUl/Xh7dfr319uud
alTo/qiQi2+RCim5wlMbOwdPbuSOJzdywPlD7sgdOSAH5I7c8XsPcsD5Q+7IAecPueP84Rv7cMIJ
J5xwwgknnHDCCSeccMIJJ5xwwgknnHDCCSeccMIJJ5xwwgknnHDCCSeccMIJJ5xwwgknnHDCCSec
cMIJJ5xwwgknnHDCCSeccMIJJ5xwwgknnHDCCSeccMIJJ5xwwgknnHDCCSeccMIJJ5xwwgknnHDC
CSeccMIJJ5xwwgknnHDCCSeccMIJJ5xwwgknnHDCCSeccMIJJ5xwwgknnHDCCSeccML5vJz/77pk
SVJC+l+k7eWwF+Pd3c2wC3CSIX3OJzH90demnaRfeqpmOP+fWZnOeqWxVFipCk/a6KBFpT8q+cL+
Ae08N2+apC/G+nJWtZ1kL2sXYA9ACimkkEIKKaQvSXr65pB6sZKWv3MleTrYTnI6P+5R7+yKDklq
LwYVf1iY+AGlrSynUrt6JpzK+R4fJsoHbYakfdXe39/jQauBm+Nuh19sUSGMsYEqK+R99VoFbbay
rZ+efIP+gN9rLHvnNHZ2oMiWi9J0O6FSaObSTIcRKeeso1YWexd22XGofVCORxg1o7hqrhSFIun0
VDlatm2MR/M0p0tVqSLwUCeC4g9QJjhbkaiG1nH3mjZqbXxwqtpoXKz6xrtLNdVFvF3IuknCHVuL
jrkTUtunDv4w4c9pYf50/H2DrynZa8eCohzuJ1nKkz4WVRUX/PiC90bJy1fYCU98ntObk7VhPIdJ
JYJ1c5K2FtpQMRJmyPcJ9kHJq00fhAv9ksOkFikjlz++poEwcqZlGG01abMWN33BOmNEf8jtmhSv
KO3GW9wi6yx2Or07/cg9ss5+u3v76jV17t6Jbc52DpsUP0BQfVTHym7aXavstlevHq3s7K1X7sW1
/ULl7sH+svLkr6tOq/S0KetWupXzNJ3TyvnVUfr3iDoul4pno1J+znHVy+1rnVwkJ0UQPEiqB5Xt
R3u3v6r3oZQx90560MkOdq/Jz8SYrKEd3p87tRiPldvhx0sw+roV39smOudnDR+Fed5KSd1weMHn
KYnCWe/z+0YNt5/uHuSkwogfLby5rmky/vTFs5Orxda627N8uoMt+NCVotbVnNK9x4ckjcryzrtd
kGicimJOJ9HnNT8TG8t7Gku98+kuOTsJcQnH/MjkGTT+AYfQ86v48gAA

--Boundary-00=_9LkaLO/BfJHFIrt
Content-Type: application/x-gzip;
  name="Xorg.0.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="Xorg.0.log.gz"

H4sICEw7aksCA1hvcmcuMC5sb2cA3TzbduJIks/2V8TQD2t3g9Bdgt2aLowpim1ju43L7Zo5c3yE
lBiNhcRKAuM6+/EbkSlxEcLGtS737lQ3IGVGRmTGPaVIH95KF/E93MKAxXMWgyJZkn54xQLmJAxO
nZQ1QZUVuSYrNdk+vIXLOEojNwrghsWJH4WgKFW4YnOf38iHJzM/8OBiymIn9cN7GDwlKZs04cwP
ZwtQJVPSVEmveYlTcyaeqcPCNu/w55QNfSc8bM/imIXpTgTJdJaG/kOGqGZJSTCWdMmqJb43W2Qo
f1Jg0L+Ey6tOp395DdfjGXxiQ9BBVpuG1ZQN+HLd5svKqB/+xuKQBeBGk4kTehD4Ia775OLi+q7X
b3U7H+rDKErr8wl2zL7VniUeI+SHusfm9YkzxVXUsynXPL5CDgFz32PRB7+hGPBfM5+lGdtyfsN/
OuHMiZ/EHJHFTc1sytZl/3ARxfe1RMhKbXJp1VQ4GtJw7+MwdsaTRBKUJAQ9hiVH55m8ohFM/QUu
swmypJgo7YMTNopiBjGbRjHn+TSOhgGbJFVwx8x9gHGaTpv1+qP/4EsLwnt4kEYwcR4YJDMcmY6d
FJ6iGYydOd0xCHAlyZKodNh34ge8bsJRrXbM8TOvCkc//3wMoziaIOfDkX8PIz9g2PzhwzF4bOTM
ghQSltKcqocHR7/8soReyQnB//KXYwij1Hfpptc7Bj/EBU1Qf6LQCWjkH38cw6MTh4QIjjqdY2Bx
HMV4fd7jY8GfTHHFyCg+r19/PYZZ+BBGjzh3Pp2zSMyuCZX63InrQXRfv0VOSLKEl5UqXPsT7Mx1
jZRNb+L/SoMLUSD5khB319ZK2Fjq1m8VpU6ilaivIoCFRZ45yNcUKkQL2nwkctzLYM4jSNyYsRDZ
5NJywZk7fuCg9KSMWsbHBNdB3P7vWu2vAzGkcpqxOLsfCBQVOJKPM2AAPqAfhX4axVD5j1wqE9Hy
19U8UONRAGigzPVHPvMARZBPbhcl6fBATJJUZuTHqDE5mmw5gY/W70mb0zkVMJXsV15NIpvWd87C
gcLyMlHNYq5KmSa0ZmlEuuU6QfAEjucJLtNUkjIIFqI4NmBIG69xxZ4f4xQitPNKfZagpxg7MauP
ojBNuEa4T7EfBL5bAS9iCVdTtkCG4IQ7YYrDPPTTKS2SjILGwdRJx9L+FBRZ9qZ+/ccRsIwfi//6
acqUH82fH8yet0HPnZI/xMgzQuWrL2pp6voejaqRFkteHaGT+nU8Y8S01xMlzf6E95d4S14Z0qh5
eFC6rImfuOh2KSqlNT/MzKIfebOArQ3PmEKzJudXn3CABM2ZnHjbCWl2QeRiLEHbdClGTSMfXXSc
2ZL0DOQDexpGTuxtghLXsvAZs8BHDqCTmSEITQfDEgVmEcCQJxQr/RDDd266yKTeCHmW38OQYShi
K6dbRay5z2ACL3oRz0+ok/uFlued5sj4jM4ix8PZTJx738WQvLBcxZRl0Sc4Bq2TXh5JE2S5SNla
54MetKEzmQXcO1E41/POG8ov4DT2cVgTTEnOO257Yj28B5pgrbqyDLCzSFnIMwXMRLCXR90Z9483
1xDOJkMEsg4PeSC/bPeaPx/JTbmpNuVjsGXbbKqWpTb5lW7qLvRQXgFGrhiTCz5RsNWGbnTr3b/x
vntsRXXrxs507LsJxbg0joKAS2gOahX6bAIfkTO2rcr0r26oumrbVWqSxb+6oumqgoRFq63aWasi
W4ihV7/gGKhRlZlctwV/McsModW+7GEa46JIktEsgCNuSvEsrDvu1PekJHIfWHq8kpaQCoZutkhR
ZSurHmJSqUrXWc7VhPrEQMS8IWbR2kRRh14Uf6gIsXyKZqHHGVc5PEBtm2LaIMIaz/6qIEgs87sP
2C6TVDOsbuAkmHeVy/jwgHTrWZDqEjPXhvWlLhcFgw5Pz3d193vXtUEb0/Hz2qB107naBXf7CQOz
bdZQfXH2bDXNF+BPu61dIKeX/cHO4dxMnu+t9SPifRsZj+1cDjsH1K5YEs1il5Xoijdk36EoOKqo
Jdj0/1JFTi++nJx1aidfPn1aV4Alg+6DxXcwCEcVGYRNb8ag1y6dZ3+97tmtyPqYt4sbCFLCAwoe
8fc4FDGwyAnR+hbMULT3VperTvvi6rTMkGL/ewwp9rcMKfb/ND15wZ1d9coXrn7fytWSpatvohZv
t3Zcs1qyaMr2gr1WLVKapM5H3HnxvLho3vG6VWtSQ1ZLVq5KDUkpt4f1zKuEN+vdK76YOV+yOYp+
Pg2RPpUmSmN/ink0ovZtRcZ0m35qnot7lipvYvzHoG9N7lfBxqwLvw2126/bhtGlJpOaGgp+Y/5v
qaoCR/RU6lg0IkSDD6Lv7KbfqcKlH2IOyx6BGlc3iKPBEXY1pIqXv9MQs/s3fsMR0E+n3j3rEJBW
hd8J8ne66vZ1AxHopD6Yl2ODbtS7OsHgxe900dWVKpzQVTtw4gfPoYS7FcdOSJeCg5exP6EnZ9mz
AR/Zg0kqyPJHGdNUzFIPvXhCeZ8AaGI2jxl/6EwIFvhzO9Skuos7hy3QiNLFmCX0hACBG1U4uvjt
OIc6eTrBNBnd7YA5sTsmTSUBYmPvFKau36Tss8lnIb3DLLL7vh9GlEmnszhE4DKwLkv5TfYAMNme
7Eo3j+TjJrRjJp7N5o9LTv1kGjhPmEUP8wc3fpg/ZslaDg92Pm8iNnlsmo7ro+FwOgVVr2uqCKYr
oqcEgF1V8QhxFCOzhrPRCO2ExmwPuOqewCPz78cp2La9jU7MZe4nMycgRtLOuB0FUVxc7jPGJzqD
o6tjbhtiU7TGqByqQr2VIuKLWUqbsZtuS4GxQ5vx1QOsjGnlI65v9h3QOUXlI/5GK1pFmL4TzkaO
ixpCm8VBqw/kMskPKY4H3B6d4Ce8UxTVRFdimEUMX1Hj6bm1bAD8wdhDEzSzdCbZSwPEJWlFgFbo
BNH9Upf4RrUK4hduoiB17hmcsTlNTJYs3N7JkibLcFNENHgKcSeN8546JDUASt6jxKdL6rsIu6R/
22xYQG9CRAb+NwZ/dyf/aMI4iv1vUhN0Bchbp3ipbTGw60wmDu2W1S1Toe0HuM7UGfqBn6JfQxmO
Rv9OylnnypavtzjwU/Y0NHV4REr9CRkcquk0ZqjzMbZhWGLFYdh+S+wxdZmuv9K1pskAcE9r5n3E
NH7He5cPG1ZIhsGMcUjFkPkNB5RNQvM4Rj4KNIom7gQRtbElh9mU/AnOlCUpPQNNxsuVJM0itKXK
Cx3dtCV//lbsw9UsdFv+aD7XZ+3us9Rn+oztPluWF8iXj4a5u69sLnlfGb1lXxk9TV2Yql7ap8iq
vrBMu5TgstN6trMMrWrLC4Io71UMdWGb5Z3r/uLfEpg4CRq8vFv6KHwM0PFu0f8ko6ElaHRIGFmE
lkY3OEW6RnXHYDdGgVEHhSzFNIwt7/GTssKBS1viwBWW4dBUu2Ft4VBLcTTMXdNQtqehrVAgD3MU
yMo1FJaRoVBlTbN2M65g/Vt8c4PIfaCJYIyG/udvaJ4rB4YeUJdtWIAmmzCZFMeO71CCmGXmLB/f
JdxtKiZNVdzdYaoMim2YeD8MnPCBN6g4gBpwa0nxYkvw8xVmLsB5jlmVlfxOYFZlHe85ZloeNqC/
me/GfOWE9+RBbwDZ0QScF145C87Qz9+q8Fm0o7v7LNptBR6o49JftIlX1AqKxZm1pdVZIKUkTMSQ
vpOkbCsbEOEQzqMmfB60v+IGwVKU0mB3hDnQmC2Ot+R2IMujtX+yrLuq53iyosmaSg83twaoujyS
FVmTmdpQRpatOow1DEczdN1tNFRzm8LIkA19OGIjW3YaqAiKjR9dthSdECnbA5TVf7qtjXQkZqpD
nJAu67K7JYsDnKzcQMelKJQqKkw8iB15sqzZ+lDZikwHhsJBHVVe/ZcNcjFz2DKlA6thMlPTPVOx
NEs3DYwQztqgUQlbddvQdM1oaA1ipWZp9AQ4G2R7pVIS+0GoYN5TqdIrAA8wFda3w5l4R8jHxKSI
/C0zz614khCFKaoFKff+AymjoLeEuWsojsTNTMgT7dPTNtw76ZhR3OfJGW66th1p3gMVMuoF2V9l
gZEbhI/gv/jNbZzbNbdlYafcPLlJcjP8ZUxLgV/m/OfIMhAL2tLxbpJZgMsIovPhBLEVN54yOlEb
nTGSBJqBibRMzBZN1S5S0iyp8TpKmrmihN7ebpiZ219R0pCSsUXJkNQXKGVJwpKSIiFrKHUAE5eC
CsnXBgiCHwU/OhhItCYI1VZLMr6fEMrKQqmgqeWEGqA3VDDUMkKNVxKSJc4pJEREMFsQsUoQ0vBj
IiFji9DL6lAgpBqSYq+xDmMjCUwQasjZirYJKS+yLkscl4RsiThFsrE0XI1uQoMTwi9dUfGjg643
ckK/7E9omTLlNkVc4OZjk/mQ2uk6WZeNC+UaiF8GfZHqm2ZR/2z5RSbmKVy+OMuWKHnIkBMxRUOy
mkIrRtlZZgMsS7C2QM38DmrZ+jJquAoFFVzB3CmjZin4sZCaWZSbYb7MzgI1cwc1XX+Rmm5L+ks+
Q6TYOTHDkmgVZFSk7w0SEc/XEIb7CvJMpmltUWpI1iv9YIObMvdOipl5p00/qJd5J918rR801jwu
EmhYptARQUmz0PjQD27rIXJPeUlW2X4g13zZFrIilikYRISYRCZJ/LRNAz82t7yiHlqvN7ScHDc0
Ur/XGZqpv6z6RBIT/XKKxEkdiSncZdF+oGEq+CHCr7C0ZTgX9W98A5+8+HSmLKab7xXU10TBod/F
6a1omu8vf/MHKkCZQWVs/cEWtfS1SE4RgcSWvzuQKPuTkwW5d4ok5ruGEkuXzHeKJZaKueoPdfEr
Usa7xS0Ul/ZOWwVUI/Wd9gooK3uvHF753+bwmajeYVtimqir77JdMJf7BVX+sfuFzDe99Yah+Mrl
+kZ57sWPG4Uhc1PmPfOux/OTnWDi6QJbOG4K9KxRJBR+6Kf0mIqnGM+RF5V96+CwzDPKSeUv/e7p
rQeVSB4pklyF/IsK5wOWJBDR44pHP2H0AFgUcW++guOHICCas5je9zywp7wslKK/MmKi6HvtXUr2
ZsjzJ1l9QxPdjYJkNQXJ0jPOwgAq7BMojxqNKjTs481KgmQ2zF/uV0bDSkn9wUbr7uIDbBgNiwUH
o+GPqy8pVn+uagmoCpQzOn9hKo57TEEciaBXSKjuw+m0KN2/UwnGP2DA0tmUTlhMqQ64yNJPa69d
CSZGSRPVrMTVK8Jf+7z0fVkNtdk7eHSmJxxZAo+On67gNjWFV01cOZMmiIpO+O1k6+1hmrLJlGfX
Ezahkmgn4AXBNLtHHzmRcmaLuefFtxsTxd61MauK0Az2y21LaJUozojZPZ1NoAdyiXhizwXJTzJE
iOaRphKJY0y8bpcjyf8lUeB7m01uNH0qtuTvLY+uOuennStwcE5BhvK4yKUTx33gWp1S/fNKIptQ
Az94YCFq2gwtc6NKbf2NN3cH/jdC9/kPaM/iZPu9OJ23KLI6KXlm712hGqs5rSr492EUswKnBFw+
aUScJM492/IZ/H3qDi0RpTK3834bfZQbUVX1ignFh/gpoJanbEFvsTzhiopAoroeBR0iKv6CgiwE
Ojl1ete/OW2BYYN7eQ38eu0fCxGfC505ncsqFLm+NHjwuXXZ2Q+UV91+7u8HLArDXzmZ2+vO4Ho/
0JNet3bV+f0LDhjsudKv5+09p/Fb5+vJRSsvF3wRvF3r9wb74u6dd65a/dae0J96t5091ydMek/Y
1vnpnqDti/7lxaB3vaeSnLbogONhVsDNg6ywQHKB/OhlVRwSyU8x4ejb7AjFYV5gKoo117BmFgoY
b1bHIVKM29JyzPUYI9FqBN7w43YUrIcMhnGEXqqaWdZmqSCCSSs82dnE4ew+kUYxY5jvPKTRlE4p
1pNx9HiHPZJ77//qex9U2cizGl6l21xOFG/u+p1B64688B3mBXciUOwEHnR7d3QA8s4V5yvvYuZ4
z0InGOwQPT/dAHR6cUlzvWcDBUF0bq/vMj91R2dy7rJwPkRvT/HsKQtpEA3/ie4q2UDAD5d4nJqf
KwLeL5MYKjKjer+79fpYPrK3Bs7dXvcsPx8Trx+qk0tcK4/CWf90/JTwV1z8PTgKV1c1eimtZO+9
hXrU6agMBnFxmG79zA1ULqNHRmV0acrPJvLiOA5RZ+RAtdKTGXOE2itzyzEhfFnRKO94q6JRTVLL
i0azUzk7q0Y3Tu2sUj06vMMzqk0eNTEePzpPybKej5+H4sxKyuHz0sLKFnMzHhYHcA5Qyp6U9+cH
VfmpymR5FksAo0u9/HK9lDY3bNLSTbFvokTBp09TnGLu6rMTqhdTnqxVFg/Du5gfHlsJv9hPm5sA
+6euIhsl/QE/aosAHivpjfg14Q/mWjN2ghTt1k/dcWVfRR4EjE13K7KaLWkTbg9hFuB3CjOvHi8O
2BJmof8thLmB8l9BmGfRPSbm7hi+DE7QWWAyXSJSPRdpCfQegi0dtVO8ei7e0mFCyFqW9w+5IJKX
B6AXxxQdHscM3Xty/PKAmNGGdM7AWbA98C94bHraf1hBGflynmPX19bCT/rOdMoT+GzdoHOyxnMD
xdaa/UErF3rbBNyhrzf3QqrfcKjSbrOD/hYAah8viX2VmZTMZGks/Ysvg86zCnXEt4fHaKFsyvmz
tltESY7ZhIGyD4KNgRj16U8V5JG+fOR6djHiBedr8pTeyqi4tJV3MipBDI2K/lyEH7lpAJ2b3kW7
e97qd2DEK/MoT0LdiqNp7FOpsQAT9eyEMXtyEAZlyQnhvYwZZVpZgT4y7/zL2RlHUK4M+3KydQ3X
sRMmAS9bp+2uunTcJY5qydNnx+3B3RfG73ReSu68XkCwFategH+L2PUsiX+FWNZ3XMzfo2S8ER2A
5Q8XSxQm/wshL4/dQ2n2wLFTceRccfZA8lwM3Ht4WaTae/Bz4W4PJM8Evz1G7xMK90DzpwTGF+dV
Hib3WM5rguYr0D0bQvfA8zYB9XWWzWH+L1i2mMifGHpfVrfD/wE8wf2COk0AAA==

--Boundary-00=_9LkaLO/BfJHFIrt
Content-Type: application/x-gzip;
  name="dmesg-2.6.32.7+queue-2.6.32-including-idr.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg-2.6.32.7+queue-2.6.32-including-idr.gz"

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

--Boundary-00=_9LkaLO/BfJHFIrt
Content-Type: application/x-gzip;
  name="dmesg-2.6.33-rc6-git3.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg-2.6.33-rc6-git3.gz"

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
sv6tXKU/k6jCk4kq/g3nUhS4d5UAAA==

--Boundary-00=_9LkaLO/BfJHFIrt
Content-Type: application/x-gzip;
  name="kdm.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="kdm.log.gz"

H4sICFA7aksCA2tkbS5sb2cA7VZLc9s2ED6bv2KjHiIpFkjJr4Stk8i2nFEjWRpbTtyTC5IrESOS
YAFQlvvruwBpOTNpe0pu5mjGeCz2+X277nZ/7OddSYNgUm7gUVYK9KM2mEOlUdt1JlcMhlkGcgnr
JH+tQRQGVcGz7BFWWKDiBhPIUWu+Qu21BUO2D4U0sFQyh0xEiitByniRAG7rt1AquVI8176OlSgN
aTXOZAdWEgz9UvQSjrksWLdxA5Y8Fpkwj79CnGK83rlr72JZLMWqImeELKyCpSBzsjJ2/ZCKOPWW
IsM2GSBLQgM9WmHCYD6c2rXeRQAKMxcSPeQV+VEYEe/U2pNSiQ3rMq/7oyvheXdsplZwBzeoNqig
z07YoXeNGXKNcEFuhTAI+kEv6PeCt94dzJU0MpYZfEGlrYv9/j5c40a4TeCdVSJLYFbaKoliBTeu
uCFMRFFtYcCO2cGAHfYSzXs8T44PYfv2+J7+XGAkeOGdV0pR/P+pQJeVKcS6UdQ7YTpL2SE76WmR
VNtG5S99uJnOYX49Gk3nC1ikFVxiBIcQDMKjkzA4gtvFuQurse59JoxgRjXNcwuaTBQU99lstrgf
T4efRqd+JKXxNzldVH/3/te4IslTP8GNn/OSovAbl3uJi9BJwEYkKE/Fu/4R/FUJNE3anvINv/Oi
4uqx9pFSHB4ch8HJfOptpVr1dF2rQeiq1RtAO7LPk48E/DTXrLbESLQDu4xumnoRq0qxpTBDCFj/
mKq9d4ZLqZBgWErlck5ciTLM9X6D+9SYMvT9B7EWbGv1enuEzJyvEXSlnrkMKd/YHYIFtN4ZZd6U
qzWtQ2j3eh2nH5N9aHe7nZq0NZvAMoaOT087kOCSV5kBjcb6tO/ttd+82Uk/14nEX73qWPqL2G7G
YyJcQQHljkI8sy+/fu3AA1eFVQTt0agDqJRUtL4au7cg8pIipkQ5vz586EBVrAv5QL47dyay9i6E
lr/hyicG+3eUCRYwWrb2YSFyunzCmgXbYRgchEcDV8Raya222f0mVqsNTezf9fu+LS2zdy3vcrgY
TkKYyqTKEJYRndb9TVZFwrybkSNDCBdCcyoUtZ2i6aJ1H8SCjq0pURC1a7h4CmOpkhCuR+ez6wvX
GAuHCCdNSqiGT02NikjhsN2bRUoN7PkFbVxubH+KECIl11jsQ+LcsXafRUmMPetpgBRVK82WCjFB
vTaytJDydSof7umGxSvxQSSng+AoCLwFgenu8+iPs9mQnF7jI7HK1r+k7Clob9eR3XQa8OrQew9f
60KHsPsWjyVCa3Y1up+MvowmLcKphj5kuMGMQB5R0/7tejhZvHcXA8plHslMk67vv/GqkKqJUfGd
6MjiSdfwbJwCTnl0ZeOGBlA9Y57r4WAoZGwyGH0Zz84/XQ2nI5KlwChT44K6h5LU+YlJjRiBmmix
IZzXj+cKxwUNF4Wmov6VwNXtZOKkWi3CqzAYp3B7c0ZAoknXav1kk1OaloWROoXc2rNpNRZeeZU5
KpID3qVLRdPAHAdDOrP2bX50FeWkPOImTqNquURFXZgnjirkRj25paKxNa8HFOFV2yZhE+uQ4qbZ
paVJPUB1VVpcgLdn4f19H3Oup5iVDJ508kzLpu+5TtYQ377/V+o7FTxJRN1uvm0+jOZrCIz59NMq
9sXbg+D+m+hYGp68C93/N1l9fo+UgPvkwbFlqClRLow/yzE97b2vZUqj4NUptNsbKRLodoLO66aI
7GWgvwz0l4H+8wb6Ydh/9zLQXwb6y0CvB/o/eenXPhwQAAA=

--Boundary-00=_9LkaLO/BfJHFIrt
Content-Type: application/x-gzip;
  name="xsession-errors.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="xsession-errors.gz"

H4sICEU7aksCA3hzZXNzaW9uLWVycm9ycwDFVU1rGzEQvftXDL64Oex6bZw2kUsPdRIwoS3UKeRm
5NXYFtaOhD4S5993tHYal0JaDHVgdxEzmnlvNNo39wFD0JYE3MN+CSFKH1HB0noIZg0ywpWFUQk3
uIBqJPIzhMn1HQyrQdVpt28UCpjllaYVJFeWZYdtmnQcCXAenfTZEy0YmaheQz8F3zd6kd/nnfPN
zom+DPaoeIVqdGzsImmjwlNta7nLcWgAn4g4y7GF1ZaW8+SUjJhzT+lBGq3gqvj8YwYNNgv0QLJB
6GllsFhrij3uQCIFmviJ6JeyZrf1q3LpERWGTbSunFgK1uCtjuVs18AePK61QWBmIVPjYG+Dwzqy
81XkUBiu1ZwceDsYFEoHZ+RTofBB1/iWFE6O/cale2xs5CtnQyyy5eQE9sJTxCd3evBEelukgP7/
IB+lFU1ezFthZSnNUvS7SUAtiWwEVhVioJwx67d/4LJEdRRoaHbxGe5jog3ZR+Jwu/KyaY/q07th
dVGd9eF2tmMxpaUVovbImvYVH5+titllG4MKgG5wKZLejAfD9+fDc/5cjD8MLi+q0Tinm99Nv1xX
XRDQZX1lFAXSue4rDC7P+gImf5Qf1/hyBJ1f1fztpA6G1zrFdngphm1V/nkWCbje6taVh6NekTQw
OIj8vpsMEDhDDoZQe+1iyEm2zJ/bBYnkgu8Io1uHBPs/Hnqi6v3Tnhe0K0vYjiDF7b2RkclMvwF6
b3OxRiNF2GhjUHV+AmfKsMbdBwAA

--Boundary-00=_9LkaLO/BfJHFIrt--
