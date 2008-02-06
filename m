Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYBFTBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYBFTBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYBFTAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:00:55 -0500
Received: from 210.161.159.67.colorbroadband.com ([67.159.161.210]:38078 "EHLO
	sc-software.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYBFTAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:00:53 -0500
X-Greylist: delayed 2868 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 14:00:52 EST
Date: Wed, 6 Feb 2008 10:13:39 -0800 (PST)
From: kerndev@sc-software.com
To: linux-kernel@vger.kernel.org
cc: John Heil <kerndev@sc-software.com>
Subject: Bug: 2.6.24-smp: Eeek! page_mapcount(page) went negative! (-1)
Message-ID: <Pine.LNX.4.64.0802061003370.4601@sc-software.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1622945119-1723704518-1202321619=:4601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1622945119-1723704518-1202321619=:4601
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


Hi,

I have recently had a couple of seemingly hard hangs requiring reboot by 
reset button. I could not ping the box.

Until now, the console log (log level 7) was empty/normal...

This morning I finally seem to have found out what the failures are...
an rmap bug for real mem > 4G...


First, some info on my system...

Kernel 2.6.24 SMP on AMD Athlon 64 X2 4000

top - 09:44:55 up 24 min, 42 users,  load average: 0.05, 0.11, 0.16
Tasks: 206 total,   3 running, 203 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.3%us,  1.3%sy,  0.0%ni, 96.2%id,  0.0%wa,  0.0%hi,  2.2%si,
0.0%st
Mem:   8248340k total,  3769556k used,  4478784k free,    82732k buffers
Swap:  7828572k total,        0k used,  7828572k free,  3254360k cached

***  top used was about 6.2G  w 0k Swap usage.

I was working on local X (there were also 2 remote xdm KDE sessions as
well)  when my openoffice edit acted strangely. A couple minutes
later, X completely locked up.

A remote ssh session allowed me to do a normal shutdown.

On reboot, I found the bug log in the console log, included below


Before digging into this myself (don't really have enought time),
I thought I'd submit it here...

my .config is tar gz'd as an attachment

Any input would be appreciated...


Thnx much,

johnh


.
===========================================================
John Heil
South Coast Software
Custom firmware, device drivers and board bring up services
Ph: 1-714-774-6952
Fx: 1-714-774-7053
www.sc-software.com
email: johnhscs@sc-software.com
===========================================================


Feb  6 09:09:47 sc-software kernel: Eeek! page_mapcount(page) went 
negative! (-1)
Feb  6 09:09:47 sc-software kernel:   page pfn = 12b1b1
Feb  6 09:09:47 sc-software kernel:   page->flags = 80080014
Feb  6 09:09:47 sc-software kernel:   page->count = 0
Feb  6 09:09:47 sc-software kernel:   page->mapping = 00000000
Feb  6 09:09:47 sc-software kernel:   vma->vm_ops = 0x0
Feb  6 09:09:47 sc-software kernel: ------------[ cut here ]------------
Feb  6 09:09:47 sc-software kernel: kernel BUG at mm/rmap.c:631!
Feb  6 09:09:47 sc-software kernel: invalid opcode: 0000 [#2] PREEMPT SMP
Feb  6 09:09:47 sc-software kernel: Modules linked in: shpchp pci_hotplug 
ohci1394 ieee1394
Feb  6 09:09:47 sc-software kernel:
Feb  6 09:09:47 sc-software kernel: Pid: 3710, comm: X Tainted: G      D 
(2.6.24 #1)
Feb  6 09:09:47 sc-software kernel: EIP: 0060:[<c016fc36>] EFLAGS: 
00213246 CPU: 0
Feb  6 09:09:47 sc-software kernel: EIP is at page_remove_rmap+0xe6/0x110
Feb  6 09:09:47 sc-software kernel: EAX: 00000000 EBX: c516deb8 ECX: 
c01280a8 EDX: 00000001
Feb  6 09:09:47 sc-software kernel: ESI: f7120ee4 EDI: 11605000 EBP: 
f1b31d70 ESP: f1b31d60
Feb  6 09:09:47 sc-software kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 
SS: 0068
Feb  6 09:09:47 sc-software kernel: Process X (pid: 3710, ti=f1b30000 
task=f0586aa0 task.ti=f1b30000)
Feb  6 09:09:47 sc-software kernel: Stack: c074dda2 00000000 c516deb8 
f0662028 f1b31db4 c01683ce 2b1b1065 00000001
Feb  6 09:09:47 sc-software kernel:        00000000 00000000 2b1b1065 
00000001 c1a9657c fffffffb ffffffff f71cb300
Feb  6 09:09:47 sc-software kernel:        f7120ee4 c8e36180 1a004000 
11800000 f07fe460 f1b31df8 c016858d 11600000
Feb  6 09:09:47 sc-software kernel: Call Trace:
Feb  6 09:09:47 sc-software kernel:  [<c0103e5a>] 
show_trace_log_lvl+0x1a/0x30
Feb  6 09:09:47 sc-software kernel:  [<c0103f2a>] 
show_stack_log_lvl+0x9a/0xc0
Feb  6 09:09:47 sc-software kernel:  [<c01040d7>] 
show_registers+0xc7/0x250
Feb  6 09:09:47 sc-software kernel:  [<c010441f>] die+0x11f/0x220
Feb  6 09:09:47 sc-software kernel:  [<c01045b1>] do_trap+0x91/0xd0
Feb  6 09:09:47 sc-software kernel:  [<c0104859>] do_invalid_op+0x89/0xa0
Feb  6 09:09:47 sc-software kernel:  [<c0657c22>] error_code+0x72/0x78
Feb  6 09:09:47 sc-software kernel:  [<c01683ce>] 
zap_pte_range+0x22e/0x320
Feb  6 09:09:47 sc-software kernel:  [<c016858d>] 
unmap_page_range+0xcd/0x180
Feb  6 09:09:47 sc-software kernel:  [<c016870d>] unmap_vmas+0xcd/0x210
Feb  6 09:09:47 sc-software kernel:  [<c016dd36>] exit_mmap+0x76/0x120
Feb  6 09:09:47 sc-software kernel:  [<c0124c39>] mmput+0x39/0xa0
Feb  6 09:09:47 sc-software kernel:  [<c0129b3e>] exit_mm+0x8e/0xf0
Feb  6 09:09:47 sc-software kernel:  [<c012a393>] do_exit+0x153/0x350
Feb  6 09:09:47 sc-software kernel:  [<c012a5e9>] do_group_exit+0x29/0x70
Feb  6 09:09:47 sc-software kernel:  [<c0134452>] 
get_signal_to_deliver+0x242/0x2e0
Feb  6 09:09:47 sc-software kernel:  [<c0102e4c>] do_signal+0x5c/0x170
Feb  6 09:09:47 sc-software kernel:  [<c0102f9c>] 
do_notify_resume+0x3c/0x40
Feb  6 09:09:47 sc-software kernel:  [<c01031b5>] work_notifysig+0x13/0x1a
Feb  6 09:09:47 sc-software kernel:  =======================
Feb  6 09:09:47 sc-software kernel: Code: bb dd 74 c0 e8 dc 2f fe ff 8b 46 
44 85 c0 75 1f 8b 46 4c 85
c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 14 ec 74 c0 e8 ba 2f fe ff <0f> 
0b eb fe 8b 50 0c b8 38
ec 74 c0 e8 a9 2f fe ff 8b 46 44 8b
Feb  6 09:09:47 sc-software kernel: EIP: [<c016fc36>] 
page_remove_rmap+0xe6/0x110 SS:ESP 0068:f1b31d60
Feb  6 09:09:47 sc-software kernel: ---[ end trace 791c1b0a2eb87d50 ]---
Feb  6 09:09:47 sc-software kernel: Fixing recursive fault but reboot is 
needed!
Feb  6 09:09:47 sc-software kernel: BUG: scheduling while atomic: 
X/3710/0x00000003
Feb  6 09:09:47 sc-software kernel: INFO: lockdep is turned off.
Feb  6 09:09:47 sc-software kernel: Pid: 3710, comm: X Tainted: G      D 
2.6.24 #1
Feb  6 09:09:47 sc-software kernel:  [<c0103e5a>] 
show_trace_log_lvl+0x1a/0x30
Feb  6 09:09:47 sc-software kernel:  [<c0103e82>] show_trace+0x12/0x20
Feb  6 09:09:47 sc-software kernel:  [<c0103ffd>] dump_stack+0x6d/0x80
Feb  6 09:09:47 sc-software kernel:  [<c0120f56>] __schedule_bug+0x66/0x70
Feb  6 09:09:47 sc-software kernel:  [<c0655655>] 
__sched_text_start+0x295/0x490
Feb  6 09:09:47 sc-software kernel:  [<c012a4ab>] do_exit+0x26b/0x350
Feb  6 09:09:47 sc-software kernel:  [<c0104513>] die+0x213/0x220
Feb  6 09:09:47 sc-software kernel:  [<c01045b1>] do_trap+0x91/0xd0
Feb  6 09:09:47 sc-software kernel:  [<c0104859>] do_invalid_op+0x89/0xa0
Feb  6 09:09:47 sc-software kernel:  [<c0657c22>] error_code+0x72/0x78
Feb  6 09:09:47 sc-software kernel:  [<c01683ce>] 
zap_pte_range+0x22e/0x320
Feb  6 09:09:47 sc-software kernel:  [<c016858d>] 
unmap_page_range+0xcd/0x180
Feb  6 09:09:47 sc-software kernel:  [<c016870d>] unmap_vmas+0xcd/0x210
Feb  6 09:09:47 sc-software kernel:  [<c016dd36>] exit_mmap+0x76/0x120
Feb  6 09:09:47 sc-software kernel:  [<c0124c39>] mmput+0x39/0xa0
Feb  6 09:09:47 sc-software kernel:  [<c0129b3e>] exit_mm+0x8e/0xf0
Feb  6 09:09:47 sc-software kernel:  [<c012a393>] do_exit+0x153/0x350
Feb  6 09:09:47 sc-software kernel:  [<c012a5e9>] do_group_exit+0x29/0x70
Feb  6 09:09:47 sc-software kernel:  [<c0134452>] 
get_signal_to_deliver+0x242/0x2e0
Feb  6 09:09:47 sc-software kernel:  [<c0102e4c>] do_signal+0x5c/0x170
Feb  6 09:09:47 sc-software kernel:  [<c0102f9c>] 
do_notify_resume+0x3c/0x40
Feb  6 09:09:47 sc-software kernel:  [<c01031b5>] work_notifysig+0x13/0x1a
Feb  6 09:09:47 sc-software kernel:  =======================

---1622945119-1723704518-1202321619=:4601
Content-Type: APPLICATION/octet-stream; name=config-2624smp-rmap.tar.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0802061013390.4601@sc-software.com>
Content-Description: .config - rmap bug
Content-Disposition: attachment; filename=config-2624smp-rmap.tar.gz

H4sIAIL4qUcAA9Q8XXPbOJLzPL+Clb2qm6naiy1Zlu1U+QECQQkrfsAAqY+8
sBSHyehiW15Jns38+2uApASQTXpf9uFciW11N4AG0N8A/PHi4+Pu5dv2+y//
ua9L+BqPRuYnfLk/B+Or8dXlL4PLm+vLm6H+9svlYDC8HP7iXf4HeTp9vR2O
m73n/bLf7Y59dO/h/59+/e3Xv3nk7bh73hy3j5unp7+878VLsd8ci6/e8+ZH
4ZXS8cn7unv576NXfN0eoUW4fXn76f0o9i/Fk/dnsT9sdy+fvOHH8cfhCNDB
fusFxRfPG3iD60+j8afBtTe8vLz9VY9Gkzjg03w8mvDU2x68l93ROxTHXyv4
6nacXw3v/zpTash4hJMCXfVhymImOc1THrE2lEaJyjPhk9RC0jChc5VkkrJ8
SVI685Mp0lRTsQWLU9WLzCcyIT4lKj2TaazPRK4yIRJpIVRK6DyVBEZu41hE
xCyRgAoZE0xa40ZRdv7wOYlZ7kfkDHnIOJ2H3Gah5pQr4tKeEAkM1wZPMmQt
ZkvGpzOrdyLpLI/IOp+RBcsFzQOfnrF+xO2NlEuY2qkvJXis1wfZ2JJwRWdT
4vs5CaeJ5OkssvsyA8+IynmYTId5djW0++kkQ+XotJkk5BMJIpL7LCRrezhb
uvKFWiugDZGuzHjVjqo8ETIJeMjsnupNcxm2m4tEZCFwofI48Vle7s55RpnP
U0PYM5MZkT6XD4jAAjQHriaIjggW+zyeapIzUiufioQLsCVAf55w0C7JJknS
QICERyIJeWwNNzdrqBeQSEtUWFDrjBbfDxdP2y8Xz7uvb0/F4eK/sphAG8lC
RhSrPdaHX409mRp79aSX4e0VIFU3bAWaAyPFKQldhcznTMbMAvIYVpTFC1hV
PXzE0/urodWChAtQQp7E9x8+YGDYkzSx9Hdp6xPIyoIL2gLonzQN7a0VieKr
PHrIWMaQzZ0oX28dZUrlhNLUbtrE5YsrVB9SouZge1KFYjPFZB7jOMH9LpQR
SYRhPi9/sVZ6XvcGvNq7AjPIglzNeJDeD27OXdOpTDKhkM4DwmVusCBLM+af
ezMYM5UacerOoKjVCukY9iVQII9CMgpaaHUsK6tQr3k4B7KFER/pu+IEcg+d
lL5FS815QhSsAmgA/8zyIAEW4ReciYZwsGjCfB/lOOP+YOwIGLTNKyNlKR58
UutItSF5SXca6wRnK5hJLojCdmCWpCK0vYSQPE7n1gLZSBYGOQWnZqFBl/Mg
s1kMspStLO8Sg3JxbQUtphkYFKuJ4tOYhIG1/sYd2wA1i1h0/riIShJgJ4tT
x72qkEzshVBhNkFFXoXJBNs2aM/jwDIGMs0jPSkzg7Ma8nhdsoXpuV4XFek9
uTz5/cTPQnsVSkCegQslfgsMkkUt5GlcQFc2C9fkqrmS9GTaUDc3B0I7mEkE
uCk6c+z8RNtaS8cnPqI6SW6CIItMBY5dqwgnamqzYQw/Tzz1+EehXcT+cDb8
4Iu0ZoPzTCwzXEOJasN8RnzXR9UYGliuEFwUycK07OLEYQ2tO0HXtSaC/nrx
mmdkuWt0xdb9h80LROvb181xt/+rcoNiv3ssDofd3jv+9Vp4m5ev3rdic3zb
F9bapBAe5hCAqFniuI84yWefMRWHaA/MnjJxj3wv/s14aEtFM2owTtCJ6sGe
xuh6aOQiWZMpk534OIsIvpomZsmiyHVKDnrCp8Bf99hcLXEN0dhq8s0YzJ2a
uoHktnuAxuj1mlWSq/8lwH8eSB34iIRrQ+XECkSSBQfrMs2YwucZXd2OccSo
C3Hdg0gV7cRF0QrHjbs6hGAz5VnE+TvofnzUix3h2HkHS/MbZEei+a1jQKnM
VIIrecSCgFOW4CIdLXkMFlLQjtErNJ7G1NgrH0dPGfjI6WrQg83Dji2ia8lX
nQu94IRe5R1caeRNxxZ0SYuOAfDuTjZFZB11gYrCNSs0EjpTdIHhALI5UKYq
pLyxcStIKl3qpciXiZxDwjZ3ETxehKLR9cSN741lSwTxW42nSQL+RjT51aoc
mviUJmLt4gCaC4iNc2CdzsGGNdIp1egrglgzyiK9ZBDbRjxc349OtluwtLTb
5zYGxiKTXkJoYvUWS92Jur+1YhxjjFSEhfYlLnIsOgTMLBLaiXV4wZpgkYQQ
eBG5RjquaOygsmw0mYeNLdYZGLa+CQKM7BijAmhGA1Kmh45x1jgxSmdMQhCG
8LiITOHpHM0lIGUTgs6Z385RuB6nzJgDvmpkOGdl4RTyJFDeDn2IlGzogoBc
wHXs2oU34swTtsKNpkj/FW48sgN8cMh5EgSKpfeXP2lVx220aKgGsRbelDcC
ED4gg4SbTMImUoFfU6wbzUIGyS3gE7nW0aqdxvci61EjEmfujvtcwW8pn57R
eMh/Yq1N5A7ijlpVcUw7uy5w6k7n49zRpDNuAd+gWbUamCKKEMIEkZrChtHg
kwGAuM3kn6qstbbrhpq96f3gFJRDOmSrCZgEU088U5iAI00g0nNCYL3xIu1w
iiSdVRaHu56xJkilJcRcPkwIRIU2H4pRmkROEWz2OR90RFeAGl53oq7cVk53
l5ad/HyvAVZGDBkc7tCoJGqW+xkaz4nZWnFtpmCPpdaZQakx55Io02Ys7djc
U3MSQpZ7bl5zWSbgetutojYsFQjdwldJQ3lKGar145y9l+nD7l/F3nvevGy+
F8/Fy9HbvR63uxcrdxCWXIsoD9mUUKdGCkCfQc6PTSQqa9luUlBDra3OlK5C
ajJdDVPcMQEV1tomPmEyNpLVbGIJ54kGL15RwRGOCUz32aICXmELdFG+rCyV
rOA96oVIEJV1KLTL5n4PAdglEZI1pMAkxn2IpoL8PFnqmKKjNAckkoEEaXMI
67ME3sGAt3JpHXMF++Kfb8XL41/e4XHztH35bh/XmAhDMjzhwuZiGk/eDrUg
eb8Jyr3i+Pjxd0umqHNAAB8hatLVZDx+MOgoKj/2kPhcgifA5NCgSWyFXRqk
R3QhZQ8NWBIRHqsGw0yX+sEgvnsYEKnWXAHUwSSiXZqDDvWapW7Rvjrr0XGQ
A7RqZK1P+SKc6AoehJTTBkYPjTUAbwB+MJdO2d+gdLneWaiIEsx50Z9DMLuW
npWQmSwD144thswbK4PW5lALldWlBYYYeY7ZWZvE2M+Hrg5KbB4vIC/HfYxF
zCfv01CtFf0cqZmgwI9RKPazeHw7br48Fd63rf622z9vjgfvwmPPb0+bhsnW
tcgo1aVXq/RWwkiSpdCpC4wgFKpHiovjv3b7H6UZqCMCltb+4oxGPAWhc2Yr
j/mcR078k8XcqvSuAhm5n4yddSJzDVQZCGkScrpGV9bQRHyqD/GQVQX+wZM7
alWBehrx2J4LFzkEMxCvOee8ACX+QoctPqhDlto5F1FzjQ/4RB9EzuzBK3Aq
OTqw06gxvgBPbsIG5eDM4BUFRF4IbsHkJFHMwYhYNNgCSO7PKF4hq/A6eekl
kERiQZFeci64OItfCZlKhoCwY3W9CGY27ix4pCBiHmBA50IBsIUf/MSg38mc
O2uqGSGzBoAp0YBwUcWoNtCIY5rFjdNGnZdjwFJ6taNOJYmVeyugSdHfwYQx
p8Br0KFMOuQb/B2ZNlmkogafM12Awa/Tk7Qj/Z1oaDax0/C6iF3j7z88vn3Z
Pn5we4/8a9Xh22E3F5ib5WIxdsV3MdaebEEoVmEw6FJJdXEhaDUt9UQf43Sw
ATTlGZ4CO5D7BFsFvYTjluCM25IzPouOO0TExbiz407JGndA35Wt8TvCNX5H
umy8WcHqmLMr7zNzVNzR6oXFfWMxXJuHbgwwoat4Ol+MiMTulQBFwEPHOp9A
ZXBVuze62xfax4GTPUJeRM2Fg7e9cbCOP6waw28hj+dYvxUqN8f6fQShffso
1qelcaxPx+ZVKuHjWBea1lcDsH70snQN0bjgVPYlZALp/tQ+tbURiqaO3Nq4
zNeVCdQL2+OSiMQ+6WAqSEUHZnY1vOpAcUk7MLDQ5qZKrDoIhOgcUJGYdaF4
V6O0NYG0T1JWTYduo0Dy5RTMMg0JJLnB+h0q4KGx2wiVr6jop3i/jzjoFGyb
qBRuW1fbRIlZtS7dbtGbk+M+LbdpqYhU18pG+u6fDu31baF3aOJ4sk7d3KaD
zlwkeo+9M3nPSp+JmgrfpvJp55ZWBN17XhI4HgrBz1gocAt6IglZPLWDT4zE
XLPqo4gIfQf/zoKVeUJ/H8atOL4Q62iepmvRJeIlzUOWpKSXQpdhol6Kypz2
EKTO/dUOChOWvEMlnSwfITkpTJ+Y6yT9fXUtaTP0wiMmX5Dv1NJR3vMQn/4N
V+y4ALEYdZl4mdCqRurkCUDUsGMlkAskywJ4ySsXEExNW42q1Uk6WklGHUNj
4xiNcQSZdYyShjgiWca2mjp9+b50JbrENoOjElqZUMn+4ZTEHKQTuziYrBnW
xCRtfgYxYL4d3zg9RETB1kjit/g9cdYs1zlokDGn8uAgFYlYix0VR0Jfw+K0
hcIjIo1p+noNa8YiGtYKCjQQCYPMaM2ARANbsY9hmbdmCF1Ow641Q4SzwiAS
WLdpi9opKMkUSE6bB0mWTRBk37hKAQIXQECcJ1OZhD/HnUbB+82++/u7XcVu
Wgn8LgYkXid70EdQ24aubFX74i6ctvUoDvwRftBEUryaOJHcn2Jx0CIkcX57
ORw82Gbch/1lWFwShs4ZJHzEDDYXKzc5W5kLDbLjcAU2oOP8e3iNwkMi8BuX
DH4y/KLTEuZZJvQd1ab6HrARhYe34q3Yvny/qC4PNiucmjqnkwe3FqWBs3SC
AANTM21AheSJXUOu4bKHRW3H2j2pAOEkZQ8hAp0EbeAU7dVXJnxqweEni9pg
iBYkg3Cgqg3Tp83hsP22fWznw2AKmlGDBpXWtGPuGp9SHvts5Q6tEWZjRx1w
J4Qx4GDZJoXQw96LCpSDjQhQeaoJuqsIJQdqIRC+ADpubj0zfrenL0LdEFQD
ygCWNVdTY6aE4qpQE0RcSoYfT9YkYL168eBVevGC+R0XLGsKxdFD8XrO+PQ0
hsdYSa0WxoCbC9b2MYR3LA7HliJD3D5lljObkQiiCH5qLDaPP4qjJzdftzvv
db877h53T9Y5BgEjdd5g/Sn3wVHrW94LV/RkYimN1OX1SlPI6iMYupeKy6/F
n9vHwvu63/7pXFmO5twoV/VxrA9MrMMZ8cD0ZaQzRFHqfDi9V7JAqVwxOrPu
AEzIGuLeXJ9eB76laBZ8ZsPXxDkB59LHbzhNMGdCwPWvpHvjt4a1jzHP1yFW
c7Saqs9BZHUB3qzrcrsvnorDwTmiDqba2w2Q9kuu3w4p86DBZglyzFaT84wZ
Y91YGcx5iN8U0rJ350i+YdMvd98/7f75+dL2sQJ7SfMwLSvfKpRZd24OdT5c
HL5sXy7+2B1fn96+n54kQe4HMWSY2IUqIcvmAZfRkujTFPeSdrDM9RsBI1xW
iAD7k/uSLzqOYCsCtpAdwY9aq3wGCYZccJXgfeg4DGL2DmyU4sZLQCwI6TqO
izFrU70gsPSgelIQIO8RVpar1DAqHkDl2zAK+uogDEBRxSEiFqzdsU/o3fjS
7UjDs4g5WlbDabI0BSm0dF4TheULh3ZjuRZpEuJvCWqieOK32VGrW4ybDHvr
UiMlidrzBWD5vOZ+MMZw+tnT/Q18YUjzcsRQjC7vxpbI+GBntVWn/qLj6k1K
8gSkNgeDid0140pbnwW4HSdI4ZMoJwoPr8WMxGmC4xgTmqO7K7rCMwk15TlP
KH4RPeVBZJ5EYWG2jwhRCSxd11OxORTQAuzJ7vFN39gysdjF9mvx8fjzqC8G
eH8UT68X25dvOw+SImhcOh7HZlpdQyqcdlj4imjma7oeUQCsz5VVlasAZZ3N
nA2hs6I+JsaA0MrUyxLQBGEiBH4dwKLSuomvs3kTqXfJyW71bSldKgpOLkdP
/fGP7Su09g5vr6+7/fHiy9v3b9uf9gsb3fB8Tb3FiQhJGiQSffZVa2/kj0eX
qF4bTM7iWevstRQKym0uDzWb1oWQ84KUV6/OXJc3TbSLcK8SlRj4P8lUnkjf
vZRRd5gEwSTBr+XUJD2roo8Kx0PMcZ/Mwmf3gqYtcRHJncnUOMLoeLhaIYiQ
D65XVzYnS5/W4B4uSOTfjNAeU85Xog03O4bQp5IHIVuhm7y+HdLxHf5890Sk
rq+H2E1Wm+AKFyKNue5pOhPp1chhrYSYV86w2O80HY+xUf9hrrL3OTNFB0Ns
hwXn6Drx9HY46F8lQ4K/ejl5QXV7Mxr0LYfw6fASxChPQsdKneCTTCosBG51
ELNle3pqsZwrBMx5RKaItVQc9m9whSBCenfJ8NVPZTS86xOXBScgdasVutIp
vR3Ty8uOIBnsHXHtmbFFyfEPiGY7rFGZuu2OxSfveXc4ertvHpCDP9s8HXae
voYK4b13eC0et5un+s+MfNlB/6+b/ea5ODrZU83nyESsyGJqxUbV1k/pcHhz
20bM0vH1+HLSRjz442uspyyCRboZdhko17GYe6HJRCUhMxdNeIot+6xt4I0T
q5LI82qeUxLCfTBFqcRuyei2doYIoWrJmHX3UoevUzy4Nsjq7Lqj96bDNNxW
bJaPUn/7uj38+Lt33LwWf/eo/z8QPP3e3kdlBeZ0JkuYs0Q1NFEdTx9PXWHl
tlOfU6xP5dZpypnsngt78Q/eb8XH7x9hCt7/vv0ovux+/n6a6PPb03H7+lR4
YRZbQmoWqAyDANHYCPhdJ2/2/QsDD5PptDyoc/dBURJDwLqOsYqaoVgSnhqy
uhBhuE/3m5eD5rLJmBK8FJzWUAFtS5RLwc33d4gUUXnIJ/Cjh0aKXumF5ViG
kM66t4NKqe0otNdycLXMwbitjIZ0MwBUd0DVTaCf9AakS+jKdei4nFwiZ2Rw
PVw1dtlAR0MEeuPGgSWc0OYsHDSnNyvbQlUAHYooXfKs8p/72yYB5PL6Soiu
JOWRuh9cOw9Vaqoy9e98juSSRRBZn/+GwXkgU5dI03X5FyOaE6/IEucxeY25
a87tDpnb+a+31BTvT+7u35vcXXNyrU6a0+uRFU7vRn3y5os050P8GmLZg76G
qdZ92hkPu96hlz1IGqmOGgybEuNSIHCB4L2fpnyw0E/Tq/0QO3K0YGGwkHyA
MWy8ktOI8pV8SNTMPJLvWctodTW4G/SoP0QDV8PbnrViXQlyaSmzNIPsqXwl
0k029VP8rwaU2OoNdEzl9VUfLw3CPIp4j5zwjgemlYjwtLdxzEnXa7syLNA8
0NHluGd1VMp6BF2tI+jhFrQHfxpeTQKX0zL2IGrQUYMxaMWHo0v8jbsheDDi
lQd9IlrRDP6PsSvpblzX0X8ly+7FO23Jk7y4C1qibd5oiih5yMYnN5X7Kqer
kjqpqu7cf98AqYEUCbkXNRgfOIoDCALg5CB5SBlsmtO4GGsjbJa0nMpAcrZn
hLelZhDZOpiooe7sxVR3JfF8s/ycxmcTk62GPqLRJlhc5wv/3ZtmSOuKSUo3
rMecLImQb7qC5BVDJ2r41vfakodRmZhrySwZbepDbsjEDjHxNRGFEx6pq8TD
LZ0yO/qWQ1Wt4+goCjtBRsw+5H+gO1NVAwRxIYkhpdpw9qswNSgIh+kWDCfT
EvMNwSad6FY4sk6BNZdTDYI1LQ5Wob/zS/VRicI1mFHXEwhWdeEXRzWsdEU0
3mr5SmJMDTwTlXf1Qy4+v4X7DTQG3L9+aPxSor0AzcB3zD8eEWz3Njq11jNN
4+uJ7kH8HPo36YHBr1xS+IRmacAn0nvUYTbDhDil8FaBSDNkrIKTkn9iagZy
7VEwSN/TDDmv48kCtGptYpB5dG+jOoBIOI1Si55iwGURmkEzPCQT2aOlACVZ
awalkqZxrdCcwDl8oUrFnZlsQzgLp8YyLLArQh4pp1bYcmoRVeBJ5NuC8HE3
GdBz2LNRZZ77VZOWwaFB5NwMAgokPCjMHEpgXdq3NH+jW3Sx9DlPATj4Rn63
EinntOlrpMR/C7hr5MjFSd8Xcc7vgvlmcfcfu9ePF7RY+E+f1m4nKo72CZ7q
YhaYQ6/E+f3Xz39+/nr5bpgJDJqQlrnz8HREoNax6e3Xx/u3Uci8LilsOukl
N4xAeqQAGcesSumaywwVEAkvWuYxJrelZYxlASrgxdV/x9Az8vqg/sWbV57X
lWH3MubxlJ8cCaBiJ9tkjzp4ZyyGg2aBQT+UhYRPXQWLo+eaeaDqUThhYLrz
zaikybKLcWlfqHi91jhm8XEUU69F+EMDEs2jaUVUN7mZ9ui/M2cV2osaZlDq
NxyCZoFLnC1dIpoAm5E0NDVmXgm8BYtsM/v8dLJq6eo7jQoR2VX4+GEJDmck
oIIikKAOJNCteIdLKrbd8MfAdUChLbr09ouphiwSBh8fLRhM4oPkmbBJ6bm2
CbGIWcJa2vDBtJCLZL+gm8mYBLVXta6MfwjGZdpIEt6JM09INEtEcd2Kesty
X7wKZRKJJm256VoPfWrdOrKyvGScisbU5HsiqlWMDnK577Yfyz3yPCmq6xza
PhTNU2Pc8jQ0f2A3mL+DlflrPvyYx8vAsBc8FlVtGrTWl/JQFLnxmVWYo++e
ysnMcBs4JdHs0yhGHY7NcaAIXu8ayGcTbBbeMioWm4Gxc7E0Wp2L1dJOVcNh
zLjgTngYzBZm62xc/cSwhQ4pU/aXfeU1NWfeIDwJX5yXRk+08ka0MGZ0km2C
WWh2D7RkZdSM1cF6ZibgZWxM+kMZmKjy5bdCnYQWzk/VvfExOD+XrWX0iIKH
arMUNMa3h5KiGcOhXEQrYzzgHrYSZs1Qk2t++EfKIF5y/hDNZn7RGo2dcn5C
m+T4+khF4LS4qv3/i61mfs2mxYR/+YLwK4Nd04yjxMXYttxuSdRwgVN5FAQB
9py142gyJ5MlrKx5rGJ0oTBmpR1hZB7xPDSHCSvhAFuYEVYWhkca/FCRXdCi
QketczC0C5vCDRNOjPWc8NqKLNITqQrHMtp8muMaTdnskR7Yoy3N+dxrRLCD
NdqUGXNW455mjdz7cVQeyCwkJHgux1ALRCComc6r+LsurOWkJV1L4Qt10aEg
+fBrfRLScjbq0CgIN+M88SB5rdp7JN9KK+TG6rxSxFZvwn6VtOu9uYcpmqO8
79ZGa32As9q1UiG2XZKzrA7I+PsbitBNOJv7jK60nDoKicdinovYmhuKom9g
arHHUO2+NTwN7+1BZY0qRaArqWE4iavQdW0gIRXzkGanfLbGx/WutTKaR6aM
eGAqlrlhCc8xyNpOGNf2VRSsrEGiCNRk0yBK5saNppDBxhwg93t7cMBvMuCX
vL+ENvMlnGDeRHDStofNEQMPitoQMtUnNLa2bX62ynhI2Zy6HWd1emMgWRfZ
8YGnEmO/+22KetivQRPn/Zb4xoD4x3pIXHBll0oEsz3pxXzmOQhDflVkLhp/
nul54dj1DgIPPzSEWqu2VKKWn8MdjB3zsH9S4kQ14Z9w6rz/AifTRm57xxn2
5emHbU4FKIjQteFhgpR7dtLbqkEr+Z5JU6JBYlWnUbCc2UT4Yx0ikaa8hM5R
FKzPLhAncefzMsi5LQYS34qwRutY9ukqnPm0CB0D/Alm0cyXPQpp/lHUcWSx
XEeE+rzjqeBsLq+HgrAVMdqJMc38m0rH9MiaSnXz8HGJuPm7hFBpHkTpXZnK
0nBhgx9aMWEHKEHy2DEXacoAyU6NlGttripIRRttDFxgEbcyUWGP7NLL0mYr
rDURCWlIOM5KOEj4Vr/0YO1a2KHU9SocOQmPF9R2Fzla7FEwvkpCYejqlqKV
V13Bf4gihEyIC4HDKKC2Vi++/fj9yzUG7DLLy2YUogkI190Ow7+m1NWMZsLK
wrLtLhs/Xz6+4bsSr2+wYvz99GzZvaukWdGg4tHwtrHp11Ky5kyiMq44LLjn
P+BEt5jmufyxXkU2y5/FBYv+blP5URNHjeRHn3ZUd6rjqGWlvOcXZeo+tKKj
wDZ4v7WMhHsERD2AvJ3e86T3N1nO9U0WOGjVxM3SUJu6OLET80ZHG3rb0MwU
KjC9DD2kK0tL6aOjsQT8W5Y+EBYKOFiJ2J9S7DAy+r0PU677ytTHuhIY8KKJ
D/eEeKjZJK8EoVXSDKwsU64ymmCCjqIc0TQDtp8IANpWNw6CWcmIJx0Uy1GC
xMWIyPLdoMdwL34ne82ighT4a9oyYFP1vJrgQucpZ8Icnj6+/O/Tx8ud+K/i
bmxZyithPouGP68imlmmjooIf7dBeAwVBgJxHYUxacyiWOBcCd/dt/ArOBVb
PW5HySrmt8rYs4yPP6wWvL4+fTw9Y7CJ1gZ4aOjROJ4fVewt3CgG2uFk0IYj
Wm0AGIEVlflkQ1lK2aLom6GXDzSVd/TQbdIoNCWynThfOavSC/y+WvHqDXZb
+20CeXVtWFXLP0IfWjW5euCvYxm3QjHxc83zxOPClL+//Qs5gKIapEyqnd2t
zUo9J/bdKeFP6XOvwnizm+ha1hdjzdHX7CSxdWEMl70PoygzAQfEPElt2VTR
S4bnYeVw61tZkUXf/+iQGTtmqwMUg99LDZH+hVKnWIzqPQrqPYy8Ciprqrp7
kn6IxAewzNrEBkA9JOOXL3ue0ZVyJwRhwORhOFlPjyR1amgIqvlmZWiscS3G
SxNjKBb5pTSGZnZCb3zDHR4jSF/3pXlLVMbRer76HFFzGXeU4eypLF8U2dtQ
WDemPKNhaOzV2y0TAazrGP6U/p0BvkhMPIoKQ2cUtTOMrR9Xtbnbz88hOcbX
QJUMpGWcML5j3/79/vH66+t3U7oJY/XUqvVUREcs4519N9qRmTOFMf9+W8AA
8J47b51eBJSRUY+vCBVA6HXXs/EsWS+JAD8aRq0wicNGNQUSexKCaDfjN3lD
NFeqWW9oHUALXNPkuKtbr3fYzPYHYiNHrqqQ7MgIZQZyaJiumxRZzf0+JWpS
4YgbTzSVLk7/CEIfkLA/gvkIYPF23EDl1bahxwLgK+LA3cKblV8zhXDNCgnL
sn/GqfQ18cyjSo1vNVIqAWSgjGharKyIOMIIF0VSFPQYhvmFt1HOHMtefz6/
fIPD2Ms7TDCccfHX1x++mSY5yBeVvCYymM/9b3WZLGv/4ABoFRHmtm1q7Qs/
yQKLSLQkShh42GY539zOZ+OfnR1Pxs6raO0fUR1PLdNwSbwVg72v/TxITd7A
gkvhDZbRCxG+cg62/kLLdaXwflVKp18K9EupiZ3n5O8z/SwIPlSR+o6Eh1NW
mFF08Cfa+Niil+5SBrtHs28qv2bU4fKP/J4tWS8Cwo68Z8mCWTg9FDTP9FDQ
PIRFvMUzPTQVz/xmfTbhgjrTdDz1erGe5rmPak68YdlnI7ek50bHUp/L6fri
5L/RxWKJkZwJ3XvLs1sH0WxJWP0bPFG4o45BHdNyvl4SduMdD4Z8IyzeB5aS
eGjGzIWw9O5Y9ukyiIjQIQZPOLvBg6vMzc8ptllJudF0LHU0vcqnGSFTDQw3
lk1guFXEenrWphnlQTMw3KpkdKuSN/thc6sOm+kdDximKwl7ULAKphcM3KdW
xB407Hd4ernNswinmzwlZfWTPePB+oaggIZli3U2vSR0TDc6UbNt55vpIutD
Ft/oJRC1VhHlgtbx1AF1XzawROGNBfwUzddR4HXBNTg2gXeHVFA4vagonumx
BSzpOloSz34ZXKtwfZhedDUTv8F1SBjlRNjtJKg2lZn/bkVLDX5Jp5NOOgWH
GZelpV3z4sQuRePq5U5Pv56/fnn/N6m1l8WuNpUnnWIhfmjQoOeUmMat6E8L
R6DDiJyKDM+qLnUdzAKbKmNY7G0Sb6rCzVRs17OOcRAHtyC++YIWnNgOZLQx
NxyKZlxuke6XLuu4mACjdRDuxnjfDnRfGLftM3TrrJaeYE7ks5qdz+MUchvD
mJuRNQN8DRISicdls6QTw4oyX2/X0Zpk6abFJMPGwzDA0Xq9GzcLyJuW7EmE
RiWPnp648vJ8jef9EHUVKpL966+nny9fhrEeP318MR/cit3xnYlzXGQnI8ib
9Snhx3U5C7pYHWUsqDKM7yyGgny9ktQjI6+2kLEvW2eEcLNE4PGX2EbleHt9
/nknX7+9Pr+/3W2fnv/7Bx6JjamPRgruM5Jya/3A6uFFvZ+1Q60rBCCT1jaI
KQVhb8bnz9dm6j5EhuFD/v799qwiWTvm5X0Vsh2+krmcudYdKofvL19enzw3
FeiZcbVuSTXpuEiNd7MGmhMqv4fCMS1mpXaA114RtjUaMsDiSvaa5miDXOL+
IJXx47iM+siaxFThtuSErRfz0EPeROvlmJzJcr4wbfM0+QQSo8u8raNg4yEu
V2OiZGwdBE62mhyMyfE5XFp2zD15vgjO3kwip3LQo+tA1XnU1Udx9N0j9LVf
RG4aKGO1jCIyWZlJp7alYD4aTly3AET8wmBfgWW4WPmuD0wG42ugHWd1nc/m
7seolf/emPxYVCy/Plaw+aycvlegP8W2efQDSRzM3JZ22Nxnb2iypFk6n1Pp
FVgRimaTkR3lil+IUKzGAJr7VW/trDj7j+/tkkEEpe/m7Vk02bWoqEd2LbY9
z0buGeOBco7850cNi2N9nEoNktI1hlXV1/eLVFlVDWuUPcSPFaCh+0Fa4BqO
4wP5uRZWBB4blBe5owrWy6PYxe7iybMwIowvNQOkP4qxI6LLAf+xre2OIjZv
5pAEQqhDuy9yYDyNrALV++DAe83QEynfuwZ7vF4FsNT5rEN1rYojpMcV3875
tNmsonhnE4vj0lxJkST5QjmiWYXKfAPz0nfHotD6uHJN/x7j2Xzmq6aydBw3
HAj9g3F2NrC2LLxjRIUebx0KzKGn6TFLTANJTaz0e09eajgms0c8Y4ypMNlq
7mShqfYVv0YydhY6SLoDcFhUHbLcBatd5mSjyZVTSWg6PrMaO3QY/07zHY8p
i2yEm7PgxyKtKzGyKU3k1g5xfdxSoXdb2QG3Fnch0DtODJUtMvHoS645sjqE
c894pwKBJApNo++WzNlyvQr85PWYjFH1U8sJACq2bXYYNsFDxfCocj8CQAaI
HSFDVPYFX0d1xKqjvusZ6AkzJGrV3WyrRQAd4vzj6cdXFNUdQw62N6zD4Aee
qY0DNhLqMSGz1CotaeVzKUJMGzlYOeTQDMHscqUpKyiCcsy3aUfBxkXz3U7E
3LvoJuaLxgk+15nsjD5HShWE0YgCy4A54pGGl83W2FU04jpUgRtvRFOEsj2z
K6UbbiWn7jMVu3PB3A2NPRu9TtYu702NxmNAQ9tXwwbJGDF9cHqeCDM2PYyj
JLZ+x/BnJ9LUfu2pBeKivEAuzAFUKNVtaofZbLFKhZg9c/XqxBXf9vO2HTgx
pn1X9hRPV40pnr5Gk4UVpc+3HLuF7zi+73G1nX4wHXyHVPglOYAzFmMQbiLb
LWwrysTA6kH1oqs+mUkLqEWq2lDrEJVqqu8wPOvdX7///vvl4+5rZwXiOb9i
94uqIm5FAS0z/1kBE162vCLD2gEDq/zSKkJSpILlZMeLTNY+7Q1A0LXByuqB
I5ds9AH4zi/ZAnTgcbP1nW4Q248zAgo+5cr9hqr4qYMkGDvkDOh4ketJrdmQ
mVMLUGfzgcM/QPCl5VGOSMKCqLorfKI8hZulWZ+IMr4BLOXRbEncPmFS3A38
RWYMFqizPfIV6ZrBpOc5nFxG9ehgNMB9aHyL4sC092VsGXAZGbKj+WqNAaBv
xoEze40cbxk9ycm/JVP92sITn4XVF2vH6knEyGCmJ4j+fY0dlj6WYRonLnZ2
SFT9pf/GBBFq10LM3Pn17+vcdHzsaMHSnk28gEXc9ogE8v3F+8g6IHO9/ZvM
SHInubG+KPOgYJTqWEerkGwrLI4psciAWJzgw5N2di11erEZvYRlL9RkXWh7
UWyGqOqG+Vref2AcEcouxbJ7RKJ6BbkL9/qPm3CE9+UaHEW19y/VAw9IuXvO
XK+85PXnj29P/0yE4k6ELDHWbFt5J4f4/e3n+zfYGbuc9Os/joAMe47XdnzP
4H/6akvG6FS0ZV6j0Vb70/mQD+rjpM/XJylioBnXjn1XsQwWhx3eRHkq5YHh
C8BhDzsSJJ7KZ1zkS1QVtXo13vRx18Gxh7KAcI0+fdrKFgpWDv/qk7j7Vej6
M/DrxxRaosH8uESbBT5JlU9VCtVe18WnWzHZ5FhhOmtgCMLPkJCIkCOYfQa+
gtNib8mI+BvjbjWwnRS532rN4FEyD5FtyxKnTR2Gi04ClO+/376Yt69N3j+9
yL78z9Pb88uXu/T17fenZr1jH89fX3+9PP/6/WFe3eRm9Oc80fbUNqmMM5tQ
sVMGgopxYQlEyWFzzmP73ZIW0CPdd4sDeCElhy3XLiKDs0KFkFMVkogepXuR
j8C+Wm66qo49rcXqdgieADBe2bhJySVnGeykMNIKfxz1vF9QVUgDVgq7lDZ4
mFKu7CSFgRx1b2OdMmxMalcAt2POVZP3qayX0JxbK9XvZbOYBcqrxP68LN6s
YeVIeOx0xvjbWihsPzhWSDyrS+aNv6o+hXI0aYLV0vSrGerZ29pLZjTHyp8l
1DlNo0G0IIyoAI4zEc0JDYDC5YI0Yulgwi6ngwlbSIA5GgPTdQOY0lSrvotX
ZEBygPeNVHu3IFx0NQs/1xUn3h5vWTJG16Eo07kk7qI0XotNeL71FTq2G72t
2OZ0bTJBWIir7trS5cstFcNZgexEd5Dcs5Sd6dkhZUw9vYUwutzsqiJ3BRu8
6idHfBBFhDUcwqmcTwwMgBdTA4elYrlY0l9hIuzuACtlB2GoiUxNRJ09O5iI
utvBE3OWPdbzORU2G/BtHRFxQNWcZbNgRo8GWDCogMLdjI8m14vVxJSeiCbc
w0t1cU/yJCBdsYm+g/1zCgZRezK5zp7wPOiyp2GdPY2DJEXYHarpTWP4Quuc
sHYGGH1CCc+CAZ7oVc2Q/EmXnzXB7J7+8C1Of3qeo9MI3fEanyhABpv55F6y
WdHwLqOctBA9JMxV+Iw4JL0iIEgvBXCuDNYBvYUoPPTdSugPA9WKzjNbLOqo
2ViSuYezahBOlNZezhEmo1psZYS3OsJ5FhKuclpcOx8IW3qUVgUGYqb3iirj
E7IGoBu6ZIUu6dQSb6WPYks9Q4vnBq3emJADWRROLG4tfmNnOJ5D4nSG6CXb
Ta2+SoRtnXBgY3X2VHQ+I/ZUvGybXll1+J1zSO/1OuCPYA9OwVIHG35/0+5l
T7/xoWyfO5L6FG50APke3zEzkXqWVP7+8fJx6J6BK368vLUnQV2clTGeHpX2
wPseD/bbtjFOKQfh0RcdhO3OLJKJ5yEAHYUG6D+BGRxkFC9pVERL6sKpnPDc
VPgVaFgbr+t2m4cVTEVZL4ybp4YAvih3YPJ6MFWoFoIBnAmIj6FxW/yhpG0n
ROyhd+fxapUYlXDmWXKgaj2dUxx5irXYZCNLTsQn1+GpKikm4i8VtdsmbMUB
nyQc4mS7FuXKrgX6rO1tK1NFVwHqrkL6Z2XPVhVFfT0026v3xqlnqzFc1Qkd
mpzShCyDYHXGitDNbGtKFNEQDZFpFASTGVcRW62WMAVHTH1Hthb58bennz/d
0BRqCMYjMyOlWlCGFzocRFHz/2vvWJrb5nH7UzK9fJftNH7G2T1REmUz1isS
FTu9aNLW2818TdpJ00P//QKkJJMSYPeyt/iSCABJkKJIEMTjXxfWaCcvUYd/
eH749O3w0+Sz++cFRiP6yybme/z5d7fK/NWtLU8Pv21KyU+Hi+fD4cvhy78v
MGWyW+Hm8O2HWZaevr8cLjBb8suTSaXsc9qSjyyNLJi9NPFohBbx0FKiQ8al
lF5IYhepqsjLjerVarVgJFfwv+CmVkdTRVF5eU3XjbjFgsbd1GlRbXJNY+F0
WUeC42srSiZxA1IlmGp4cDNwXISfHr4+Pn8dK4mwZBqFq8tB6DmTacMzgTJQ
o13uazV703GG9vA2rAosBoB5pRT01gYN1UFDuzSjIiKSHjtYocpwmGuOoRvt
gSRduZ1NSH2tQxTIZKuy0URuQ6psZnPOCK4l2W2UlhspNNlhOHAoe5Vkwuhw
zRTTyYkQfh2VzSLTpJRi26GTaSHXJDexjjCkSs6wEdcZXqGcrv0O1vGSrF0V
4pZG0PQyWneDwiMbrRhu1/DVMJnlPKZ2p/uzlfdVgdEjI0Ey0uJP4Zq0KAff
vY+vKzFdnafY/wGJ+AOa4Zo6opkMF7gxxXlmJte78yS3f0KjztHMzzcFJElI
EyWVot9eHqikqUJ6AqahbuqpH3DbRefV1RWjYhmQrRjndocsE3cpmafCoSmS
6exyxrCTa7VcLWjVgEO2KZg0WQ5NJWLqdOFSKDRbxSQtiY31TlWjKY8LbzUL
ZHnj2fM62D1sBXlKolB/nNPfY55mygZWpTg6JZTIj1bO77c6X5onLLZMqVQt
ObNqwE2XQ05EVOuaMlGyB1eQ0Hciify+lSpfXI7ssxO5zjUepZjK0HhkUATG
u7w34Y+YmDi2Xl7C7Tag8P4qZLzmLRmGqqWVA0aohXPcmonAZ6T4yET7Y/Fm
F5MJE/PVjCS63rY2B/x0V3BiCu7WJyQvfih0iZHK71RQCi6VoOlKvhMlvECe
QstqfGtgTgtVAjL4l8PTMFE8ItcPX74eXlF1MNQ9YJ1rwY5vyvgjYz4CGDIu
DmqsMhUI5nApI0E5l5Q6RNnVsUcHQHfAdUCbUOfVPQ3sTFbevbx+vnx3bBJJ
6FM4YMiArFgCzlLx0OGkh+MNLwH2FA4utKmVbNoLcZ+v8o5+q2gAiOwRi0lX
DmMOXdKu/y4JEzTIIVle0eq3jgTjLFwz10cdTVktwtmZelSVTKaX9L7T0eyB
go6y0FGYCEbMiuLRMGEw+l7NJ9oPpdFHDfIH3t7NfXt4xePtuZcSpkxcFGe8
F4vTnFV6O7nS4vRAQT1X8zPvbb7SK1pB7JIs6HvFjuRudjkdD9P35/dhUXOj
EaWizdZFfOut8Zr62Bkq9cW2fpyxPnLyzx/wfWKYVG/x8hW31oT68eXJWE1H
Y55kRK9IEeaaKgM66lIURoGgOhGlSvW2OfHjt8OFzS7nrCJyr6fWx+bIgwU1
e6E1vcz3FGSYB8DOPLedFmArHLRkEEVeKbSTpC9yOqpKhnWpmBR+QDTHNSym
xuHGD9oMj7wRLJxGg1CEG8/yrZQKRK64Yqo3CK+Fs526OdchJOCYNIXRhK7y
Iyy7rR6h+4495/m2zv1cyPtz/Oy5Ljl4P8LvOq6mgwHrcWh7xCLRjG7PIcs8
5d6DyuDQELvpAi0ARAjfOMz0nqjAwEPtjF00rBKd1gfjaUFzDxZjcGcDsF93
9B74/hDdReYzHH2Fqsqvl8tLr4qbPFFu9rSPQOQp2aO4GT5nSd9klFcfYqE/
ZJpuEnBe8bSCEh7kbkiCz61dmjHIKlBfOp9dUXiVo1heQQfePf78vlotrt9P
3nWEIHCYptyo/Zqa7z66HF/bFD8Pv758v/gP1cOR+6ABbNtgDC4MJCjvrQ8k
Kp0W/udtAGc+8E0NEmsSMLO4xTYFbbZu/3TzjLiM8TvcVyui0bdxxMU8Tobl
faE57IYvCCiTRZBBB5IvGpxgh/vCw1Kk/qu4259gruBxt9l+zmNhAjBbST1a
6y2k2cHKyZzwTqzkcLZHP0T0O5PQqJapM++ywUKDz3czt20LYeegQdOSNaIi
ha5uZGYqQEdew9G45Yho2sPOBzVok9vLWclzjQiiPEZIdto3j159co+q1OHg
hHnqRbKs6qwswuFzs/ZvJFsoBmifUfYcgISdEUs12zJYeF04oqpi6/tJdLWn
wWDCIAQW6m6ppKa58kvgs9nwyW8CkTsptk2xw9vezagkL8gZtJmbtJBu8DDW
Ei8nMk06c2RhMVzLQ7M8trm81Drj4t5bQtgqdGLesaKTiRoqNH/JHANkC8W3
7hpeW2gOskXmZ+a1daQiSSLm7NNWmJzColkqKWnDdigGo9CCOitsZk0eLkF2
V3t4eX008YH07x/umb8QpVZ4ILGBzEL/wtj6J/Q0tOBVxWcoRKrW4hyNFqU6
Q4O5IEkKT+DoKY7vMIClIlLVNhGBG77eSoVVHRBFqjwBhmCmr5Zejcc1GMoa
D+S+YpLnJErP9Kpan+t3baITnOw6rDg0m+be9Ez9Mj7HAe5ey9VJDqygeHzo
/Q3eff4BEt07F9WJeg0g/EI95mrmRDHwMW7EJQ+zci3rB5gpi+Fr4zhYLdl2
3JAMAwzLwXLGYuYshuV6uWQx1wzmesaVuWZH9HrG9ed6zrWzuhr0B84fKMc3
K6bAZMq2DyjPyRGRogoVmcPZaWriz7cOPKUZm9FgphsLGrykwVc0+JoGTxhW
JgwvkwEz21ytmpKA1T6s1rEX6CtKqMwoKoPNszYb+HDBgeNPjNng6P15C2jO
9DIV5VaW471re3h5Pny7+O/D578fn78ety6MaSMbVd7GiVhXjpWbwwt6HRk/
MEqrlJkMobCIo1dRAZKr0NKREVt8Wle6MQk6nJ0D3XhxVSxvneNyhvnGAJoG
ubsYWqcmV7JEh2yJEZz9Wi3hFnOcexpzC6820FVKJWf9JdEqASWe2gmPYgzA
xkGHDHgk/B3PosZdjMe37MCeR3KDSBhMmRZ62LVSw2hquZej0SlUkyg/YmJH
bC4KyDu8lpFCZdjxYZVMS0jagNCWh4NZeydPSIzmvCC9w4apCEfpxCC1xU4N
Y8s9jKeUlO7zWBFwhmIfuubGOCauq50G0dh8D+N5s82DGy7+iKXYqPUmldR3
3iUiWLd+fMPBbDPHDOpj0ma0PeHsK9vxIFWo6PHbmBRuroujzVgNTMByYwOK
HFUBeBJsP/9IclecZVg3GtYMjEE5vI7qiVrtU3ZjTraMfCQwwBIlxpukWSP3
x7av+NZg3pVxku+IDx7RaLfBXEW3Xw6gzXRmX1+ZoxmhW/98a+qm+EV5N1Zo
nJ0WrdLI0fMCMi0K1MI5fclrWCY739I2tdjnXy+Pr7/H1r1ojeKJp/K+6tcM
1KXBMz3CpzTJHdIoPTCqqAhgC9KKfCNGMeWECbXPmJDD82xtwUGyDVWxcadd
i2kPxj4wFZlYU8RwdvFO0Ra8DwP6rrnFZzWTIbRrLqLUCz1yMeKj2ogJwQeA
OW+OI8WC8SZpKXbFGQK9LrnQ7i3FOp5MV2lN6QRaChkGoz7BGI5gBQKfRg0k
JZ3Cr3sdzI7XNYR/KKPoFh/Jihjb2Pw9VW9gUoVXdOrIbvB2+R+SNAvm8rN7
k7IsOO+W7ltgJLQj+lwjoag0fZ/tEJysQUvqPqXjoAznxFBvN+IjkxyzK5jV
gTrZuUrKk6/Y5iUet52qcCNkgn9Pz6FwxgQ56kcmlUnCeAD2g8NsVl03a72R
GbUldOvRjuiCybYrIiaZnENkgrR0BvfJ46eXh5ffFy/ff70+Pru6pUDpUmLQ
VOl+nyFGWtXaA/mRN5BGadiaSS5g/AbEVwRdogI71M51F8BQYkm8mHMGenyt
nQwsYS2Q6O5CwZptWpDwICXBceXAi1bQ7c4CAvWVXkpNCxp4JAlMtOFYttqU
gagLFSi/AOIfb7+339vv7ff2e/v9H3//A+fITfsA8AAA

---1622945119-1723704518-1202321619=:4601--
