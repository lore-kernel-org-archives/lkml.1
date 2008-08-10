Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYHJJWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYHJJWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 05:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYHJJWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 05:22:00 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:34832 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYHJJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 05:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=bl/w0Ykb0DbqBJM1aAKAvixM+oxJ9rcTaIU5qST3ajDtJ/nR2KIn4axUcTaSALwlFY
         LvEFlb11p2EBiKo87EcJV3xOsYmF/JyUZQJHw/xti/kropaXVbxgPH4VZGSlMEwKDPbt
         MMqmpxQ9A/ABTjjerocSjsM9xacDaeOimR9OA=
Message-ID: <86802c440808100221i64b580d7k8b3d6fb2b0f82049@mail.gmail.com>
Date: Sun, 10 Aug 2008 02:21:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/43] dyn_array/nr_irqs/sparse_irq support v7
Cc: linux-kernel@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_57725_15269178.1218360117510"
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_57725_15269178.1218360117510
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Aug 10, 2008 at 12:35 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> Please check dyn_array support for x86
> v3: split changing to nr_irqs to small patches
>   fix checkpatch error
>   reorder the patch sequence to make dyn_array support go at first
>       so could use that with arrays other than NR_IRQS
>
> v4: add CONFIG_HAVE_SPARSE_IRQ with list to use condensed irq_desc array
>   so could use 32 init, and init more if needed.
>   x86 32bit: have CONFIG_HAVE_DYN_ARRAY
>   x86 64bit: have CONFIG_HAVE_DYN_ARRAY and CONFIG_HAVE_SPARSE_IRQ
>
> v5: apply alan cox patch with NR_IRQS for serial at first
>   seperate irq_descX with irq_descX_free, so could use -1U as valid irq
>   expand /proc/interrupts to process > nr_irqs
>   hook irq_2_iommu to irq_desc
>   more other arch irq_desc[] to irq_desc(), and kstat_cpu().irqs[] to kstat_irqs_cpu..
>
> v6: fixed checkpatch errors.., only left warning about lines > 80 chars.
>   put Eric's patch about NR_IRQS at first
>
> v7: according to Eric, need to take care of that some arch doesn't use generic_hardirqs
>   reorder some sequence, squash some patches into previous to make patchset bisectable.
>
> based on tip/master
>
> to do:
>   so dyn irq_desc is done, and ready to:
>   make create_irq to get irq according to bus/dev/func/vector

together with attached patch

LBSuse:~ # cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
      CPU6       CPU7       CPU8       CPU9       CPU10      CPU11
 CPU12      CPU13      CPU14      CPU15      CPU16      CPU17
CPU18      CPU19      CPU20      CPU21      CPU22      CPU23
CPU24      CPU25      CPU26      CPU27      CPU28      CPU29
CPU30      CPU31
  0:        255          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-edge      timer
  1:          2          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-edge      i8042
  4:        631          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-edge      serial
  7:         64          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-edge
  8:          1          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-edge      rtc0
  9:          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi   acpi
 12:          4          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-edge      i8042
 14:        346          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-edge      pata_amd
 15:          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-edge      pata_amd
 21:        142          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi   ohci_hcd:usb2
 20:         25          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi   ehci_hcd:usb1
 48:         45          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi   eth0
 49:         14          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi
 50:         15          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi
 51:         16          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi
 57:         36          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi   qla2xxx
 58:         35          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi   qla2xxx
 42:        848          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   IO-APIC-fasteoi   aacraid
393472:          0          0          0          0          0
 0          0          0          0          0          0          0
       0          0          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0   PCI-MSI-edge      aerdrv
426240:          0          0          0          0          0
 0          0          0          0          0          0          0
       0          0          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0   PCI-MSI-edge      aerdrv
459008:          0          0          0          0          0
 0          0          0          0          0          0          0
       0          0          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0   PCI-MSI-edge      aerdrv
134611200:          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0   PCI-MSI-edge      aerdrv
134643968:          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0   PCI-MSI-edge      aerdrv
134676736:          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0   PCI-MSI-edge      aerdrv
6291712:          8          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0   PCI-MSI-edge      lpfc
6295808:          8          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0   PCI-MSI-edge      lpfc
12714240:        292          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0   PCI-MSI-edge      ioc0
4194560:          8          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0      none-edge
4198656:          8          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0      none-edge
5243136:          8          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0      none-edge
5247232:          9          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0      none-edge
9437440:          9          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0      none-edge
9441536:          7          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0      none-edge
10486016:          7          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0      none-edge
10490112:          7          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0      none-edge
137363712:          7          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0      none-edge
137367808:          8          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0      none-edge
138412288:          6          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0      none-edge
138416384:          6          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0      none-edge
139460864:          7          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0      none-edge
139464960:          7          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0      none-edge
12615936:          5          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0      none-edge
NMI:          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   Non-maskable interrupts
LOC:      18545      10702       8821       7691       7521       8903
      7618       7497       7091      11846       7026       6973
 6957       7865       6862       6825       6900       7674
6716       6807       6832       7456       6795       6987       6500
      7421       6440       6363       7780       7456       6273
 7591   Local timer interrupts
RES:       3131       2258       1735        361        550       4774
       135       1125        100       2434         96         92
  105        905         96         95        101        962
104         92         99       1839         93         94        103
     2696         98         94       1002       1551        101
 144   Rescheduling interrupts
CAL:         49        166        132        129        129        184
       129        128        129        171        129        129
  129        181        129        129        129        163
129        129        128        146        129        129        129
      197        129        129         92        167        129
 128   function call interrupts
TLB:          1        231          1          0          1        159
         4          0          0         98          1          0
    0         90          1          0          0         71
1          0          0         84          0          0          0
     35          1          0          1        506          7
 0   TLB shootdowns
TRM:          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   Thermal event interrupts
THR:          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   Threshold APIC interrupts
SPU:          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0   Spurious interrupts
ERR:         64


LBSuse:~ # cat /proc/stat
cpu  259 0 49333 1534809 10 1 15 0 0
cpu0 0 0 3990 46163 8 1 6 0 0
cpu1 30 0 1556 47896 0 0 0 0 0
cpu2 0 0 1412 48509 0 0 0 0 0
cpu3 0 0 1403 48972 0 0 0 0 0
cpu4 0 0 1407 48565 0 0 0 0 0
cpu5 62 0 1488 48980 0 0 0 0 0
cpu6 0 0 1404 48629 0 0 0 0 0
cpu7 0 0 1450 48803 0 0 0 0 0
cpu8 0 0 1404 48691 0 0 0 0 0
cpu9 45 0 1452 48925 0 0 0 0 0
cpu10 0 0 1402 48762 0 0 0 0 0
cpu11 0 0 1403 48794 0 0 0 0 0
cpu12 0 0 1404 48827 0 0 0 0 0
cpu13 19 0 1437 48870 0 0 0 0 0
cpu14 0 0 1402 47298 0 0 0 0 0
cpu15 0 0 1402 47332 0 0 0 0 0
cpu16 0 0 1403 47366 0 0 0 0 0
cpu17 18 0 1428 47360 1 0 0 0 0
cpu18 0 0 1404 47434 0 0 0 0 0
cpu19 0 0 1408 47469 0 0 0 0 0
cpu20 0 0 1510 47404 0 0 0 0 0
cpu21 12 0 1525 47422 0 0 0 0 0
cpu22 0 0 1414 47572 0 0 0 0 0
cpu23 0 0 1415 47606 0 0 0 0 0
cpu24 0 0 1420 47639 0 0 0 0 0
cpu25 51 0 1545 47501 0 0 0 0 0
cpu26 0 0 1424 47710 0 0 0 0 0
cpu27 0 0 1425 47744 0 0 0 0 0
cpu28 0 0 1804 47334 0 0 4 0 0
cpu29 18 0 1456 47778 0 0 0 0 0
cpu30 0 0 1423 47852 0 0 0 0 0
cpu31 0 0 1897 47586 0 0 4 0 0
intr 307885 0:255 1:2 2:0 3:0 4:1918 5:0 6:0 7:64 8:1 9:0 10:0 11:0
12:4 13:0 14:3853 15:0 22:0 21:142 20:25 19:0 18:0 17:0 16:0 48:303
49:14 50:15 51:16 56:0 57:36 58:35 43:0 42:848 41:0 40:0 393472:0
426240:0 459008:0 3211520:0 3277056:0 8454400:0 8519936:0 134611200:0
134643968:0 134676736:0 136380672:0 136446208:0 6291712:8 6295808:8
12714240:292 4194560:8 4198656:8 5243136:8 5247232:9 9437440:9
9441536:7 10486016:7 10490112:7 137363712:7 137367808:8 138412288:6
138416384:6 139460864:7 139464960:7 12615936:5
ctxt 90665
btime 1218359101
processes 8457
procs_running 1
procs_blocked 0


need to change irq no to hex?

YH

------=_Part_57725_15269178.1218360117510
Content-Type: text/x-patch; name=pci_28bit_irq_x.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjpg24iq0
Content-Disposition: attachment; filename=pci_28bit_irq_x.patch

ZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtaW9wMTN4eC9tc2kuYyBiL2FyY2gvYXJtL21hY2gt
aW9wMTN4eC9tc2kuYwppbmRleCA2M2VmMTEyLi5hY2U1YmFkIDEwMDY0NAotLS0gYS9hcmNoL2Fy
bS9tYWNoLWlvcDEzeHgvbXNpLmMKKysrIGIvYXJjaC9hcm0vbWFjaC1pb3AxM3h4L21zaS5jCkBA
IC0xMjUsNyArMTI1LDcgQEAgdm9pZCBfX2luaXQgaW9wMTN4eF9tc2lfaW5pdCh2b2lkKQogLyoK
ICAqIER5bmFtaWMgaXJxIGFsbG9jYXRlIGFuZCBkZWFsbG9jYXRpb24KICAqLwotaW50IGNyZWF0
ZV9pcnEodm9pZCkKK3Vuc2lnbmVkIGludCBjcmVhdGVfaXJxKHVuc2lnbmVkIG5vdF91c2VkKQog
ewogCWludCBpcnEsIHBvczsKIApAQCAtMTczLDcgKzE3Myw3IEBAIHN0YXRpYyBzdHJ1Y3QgaXJx
X2NoaXAgaW9wMTN4eF9tc2lfY2hpcCA9IHsKIAogaW50IGFyY2hfc2V0dXBfbXNpX2lycShzdHJ1
Y3QgcGNpX2RldiAqcGRldiwgc3RydWN0IG1zaV9kZXNjICpkZXNjKQogewotCWludCBpZCwgaXJx
ID0gY3JlYXRlX2lycSgpOworCWludCBpZCwgaXJxID0gY3JlYXRlX2lycSgwKTsKIAlzdHJ1Y3Qg
bXNpX21zZyBtc2c7CiAKIAlpZiAoaXJxIDwgMCkKZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9rZXJu
ZWwvaW9zYXBpYy5jIGIvYXJjaC9pYTY0L2tlcm5lbC9pb3NhcGljLmMKaW5kZXggZDM3MzI5MC4u
OTU1NDUxMyAxMDA2NDQKLS0tIGEvYXJjaC9pYTY0L2tlcm5lbC9pb3NhcGljLmMKKysrIGIvYXJj
aC9pYTY0L2tlcm5lbC9pb3NhcGljLmMKQEAgLTUzMiw3ICs1MzIsNyBAQCBpb3NhcGljX3JlYXNz
aWduX3ZlY3RvciAoaW50IGlycSkKIAlpbnQgbmV3X2lycTsKIAogCWlmIChpb3NhcGljX2ludHJf
aW5mb1tpcnFdLmNvdW50KSB7Ci0JCW5ld19pcnEgPSBjcmVhdGVfaXJxKCk7CisJCW5ld19pcnEg
PSBjcmVhdGVfaXJxKDApOwogCQlpZiAobmV3X2lycSA8IDApCiAJCQlwYW5pYygiJXM6IG91dCBv
ZiBpbnRlcnJ1cHQgdmVjdG9ycyFcbiIsIF9fZnVuY19fKTsKIAkJcHJpbnRrKEtFUk5fSU5GTyAi
UmVhc3NpZ25pbmcgdmVjdG9yICVkIHRvICVkXG4iLApAQCAtNzg0LDcgKzc4NCw3IEBAIGlvc2Fw
aWNfcmVnaXN0ZXJfaW50ciAodW5zaWduZWQgaW50IGdzaSwKIAkJCWdvdG8gdW5sb2NrX2lvc2Fw
aWNfbG9jazsKIAkJfQogCX0gZWxzZQotCQlpcnEgPSBjcmVhdGVfaXJxKCk7CisJCWlycSA9IGNy
ZWF0ZV9pcnEoMCk7CiAKIAkvKiBJZiB2ZWN0b3IgaXMgcnVubmluZyBvdXQsIHdlIHRyeSB0byBm
aW5kIGEgc2hhcmFibGUgdmVjdG9yICovCiAJaWYgKGlycSA8IDApIHsKQEAgLTkyNSw3ICs5MjUs
NyBAQCBpb3NhcGljX3JlZ2lzdGVyX3BsYXRmb3JtX2ludHIgKHUzMiBpbnRfdHlwZSwgdW5zaWdu
ZWQgaW50IGdzaSwKIAkJZGVsaXZlcnkgPSBJT1NBUElDX1BNSTsKIAkJYnJlYWs7CiAJICAgICAg
Y2FzZSBBQ1BJX0lOVEVSUlVQVF9JTklUOgotCQlpcnEgPSBjcmVhdGVfaXJxKCk7CisJCWlycSA9
IGNyZWF0ZV9pcnEoMCk7CiAJCWlmIChpcnEgPCAwKQogCQkJcGFuaWMoIiVzOiBvdXQgb2YgaW50
ZXJydXB0IHZlY3RvcnMhXG4iLCBfX2Z1bmNfXyk7CiAJCXZlY3RvciA9IGlycV90b192ZWN0b3Io
aXJxKTsKZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9rZXJuZWwvaXJxX2lhNjQuYyBiL2FyY2gvaWE2
NC9rZXJuZWwvaXJxX2lhNjQuYwppbmRleCBmYTI4NDgzLi4xMjNmOGMxIDEwMDY0NAotLS0gYS9h
cmNoL2lhNjQva2VybmVsL2lycV9pYTY0LmMKKysrIGIvYXJjaC9pYTY0L2tlcm5lbC9pcnFfaWE2
NC5jCkBAIC00MDMsNyArNDAzLDcgQEAgdm9pZCBkZXN0cm95X2FuZF9yZXNlcnZlX2lycSh1bnNp
Z25lZCBpbnQgaXJxKQogLyoKICAqIER5bmFtaWMgaXJxIGFsbG9jYXRlIGFuZCBkZWFsbG9jYXRp
b24gZm9yIE1TSQogICovCi1pbnQgY3JlYXRlX2lycSh2b2lkKQordW5zaWduZWQgaW50IGNyZWF0
ZV9pcnEodW5zaWduZWQgaW50IG5vdF91c2VkKQogewogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAJ
aW50IGlycSwgdmVjdG9yLCBjcHU7CmRpZmYgLS1naXQgYS9hcmNoL2lhNjQva2VybmVsL21zaV9p
YTY0LmMgYi9hcmNoL2lhNjQva2VybmVsL21zaV9pYTY0LmMKaW5kZXggODE5OWViMi4uMjc3NDc5
MiAxMDA2NDQKLS0tIGEvYXJjaC9pYTY0L2tlcm5lbC9tc2lfaWE2NC5jCisrKyBiL2FyY2gvaWE2
NC9rZXJuZWwvbXNpX2lhNjQuYwpAQCAtODQsNyArODQsNyBAQCBpbnQgaWE2NF9zZXR1cF9tc2lf
aXJxKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBzdHJ1Y3QgbXNpX2Rlc2MgKmRlc2MpCiAJaW50CWly
cSwgdmVjdG9yOwogCWNwdW1hc2tfdCBtYXNrOwogCi0JaXJxID0gY3JlYXRlX2lycSgpOworCWly
cSA9IGNyZWF0ZV9pcnEoMCk7CiAJaWYgKGlycSA8IDApCiAJCXJldHVybiBpcnE7CiAKZGlmZiAt
LWdpdCBhL2FyY2gvaWE2NC9zbi9rZXJuZWwvbXNpX3NuLmMgYi9hcmNoL2lhNjQvc24va2VybmVs
L21zaV9zbi5jCmluZGV4IDUxZjY2ZDguLjAwNGUwYmIgMTAwNjQ0Ci0tLSBhL2FyY2gvaWE2NC9z
bi9rZXJuZWwvbXNpX3NuLmMKKysrIGIvYXJjaC9pYTY0L3NuL2tlcm5lbC9tc2lfc24uYwpAQCAt
ODMsNyArODMsNyBAQCBpbnQgc25fc2V0dXBfbXNpX2lycShzdHJ1Y3QgcGNpX2RldiAqcGRldiwg
c3RydWN0IG1zaV9kZXNjICplbnRyeSkKIAlpZiAocHJvdmlkZXIgPT0gTlVMTCB8fCBwcm92aWRl
ci0+ZG1hX21hcF9jb25zaXN0ZW50ID09IE5VTEwpCiAJCXJldHVybiAtRUlOVkFMOwogCi0JaXJx
ID0gY3JlYXRlX2lycSgpOworCWlycSA9IGNyZWF0ZV9pcnEoMCk7CiAJaWYgKGlycSA8IDApCiAJ
CXJldHVybiBpcnE7CiAKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9pb19hcGljXzMyLmMg
Yi9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpY18zMi5jCmluZGV4IDIzOGUyZGMuLmJjYzFkZDcgMTAw
NjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9pb19hcGljXzMyLmMKKysrIGIvYXJjaC94ODYva2Vy
bmVsL2lvX2FwaWNfMzIuYwpAQCAtMjQ5OSwxNSArMjQ5OSwxNSBAQCBkZXZpY2VfaW5pdGNhbGwo
aW9hcGljX2luaXRfc3lzZnMpOwogLyoKICAqIER5bmFtaWMgaXJxIGFsbG9jYXRlIGFuZCBkZWFs
bG9jYXRpb24KICAqLwotaW50IGNyZWF0ZV9pcnEodm9pZCkKK3Vuc2lnbmVkIGludCBjcmVhdGVf
aXJxKHVuc2lnbmVkIGludCBub3RfdXNlZCkKIHsKIAkvKiBBbGxvY2F0ZSBhbiB1bnVzZWQgaXJx
ICovCi0JaW50IGlycSwgbmV3LCB2ZWN0b3IgPSAwOworCXVuc2lnbmVkIGludCBpcnEsIG5ldywg
dmVjdG9yID0gMDsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwogCi0JaXJxID0gLUVOT1NQQzsKKwlp
cnEgPSAwOwogCXNwaW5fbG9ja19pcnFzYXZlKCZ2ZWN0b3JfbG9jaywgZmxhZ3MpOwotCWZvciAo
bmV3ID0gKG5yX2lycXMgLSAxKTsgbmV3ID49IDA7IG5ldy0tKSB7CisJZm9yIChuZXcgPSAobnJf
aXJxcyAtIDEpOyBuZXcgPiAwOyBuZXctLSkgewogCQlpZiAocGxhdGZvcm1fbGVnYWN5X2lycShu
ZXcpKQogCQkJY29udGludWU7CiAJCWlmIChpcnFfdmVjdG9yW25ld10gIT0gMCkKQEAgLTI1MTks
NyArMjUxOSw3IEBAIGludCBjcmVhdGVfaXJxKHZvaWQpCiAJfQogCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoJnZlY3Rvcl9sb2NrLCBmbGFncyk7CiAKLQlpZiAoaXJxID49IDApIHsKKwlpZiAoaXJx
ID4gMCkgewogCQlzZXRfaW50cl9nYXRlKHZlY3RvciwgaW50ZXJydXB0W2lycV0pOwogCQlkeW5h
bWljX2lycV9pbml0KGlycSk7CiAJfQpAQCAtMjYyNCw3ICsyNjI0LDcgQEAgaW50IGFyY2hfc2V0
dXBfbXNpX2lycShzdHJ1Y3QgcGNpX2RldiAqZGV2LCBzdHJ1Y3QgbXNpX2Rlc2MgKmRlc2MpCiB7
CiAJc3RydWN0IG1zaV9tc2cgbXNnOwogCWludCBpcnEsIHJldDsKLQlpcnEgPSBjcmVhdGVfaXJx
KCk7CisJaXJxID0gY3JlYXRlX2lycSgwKTsKIAlpZiAoaXJxIDwgMCkKIAkJcmV0dXJuIGlycTsK
IApkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2lvX2FwaWNfNjQuYyBiL2FyY2gveDg2L2tl
cm5lbC9pb19hcGljXzY0LmMKaW5kZXggMTdhNjkxNC4uMjI3NmJlNyAxMDA2NDQKLS0tIGEvYXJj
aC94ODYva2VybmVsL2lvX2FwaWNfNjQuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpY182
NC5jCkBAIC0yNTA4LDE3ICsyNTA4LDIxIEBAIGRldmljZV9pbml0Y2FsbChpb2FwaWNfaW5pdF9z
eXNmcyk7CiAvKgogICogRHluYW1pYyBpcnEgYWxsb2NhdGUgYW5kIGRlYWxsb2NhdGlvbgogICov
Ci1pbnQgY3JlYXRlX2lycSh2b2lkKQordW5zaWduZWQgaW50IGNyZWF0ZV9pcnEodW5zaWduZWQg
aW50IGlycV93YW50KQogewogCS8qIEFsbG9jYXRlIGFuIHVudXNlZCBpcnEgKi8KLQlpbnQgaXJx
OwotCWludCBuZXc7CisJdW5zaWduZWQgaW50IGlycTsKKwl1bnNpZ25lZCBpbnQgbmV3OwogCXVu
c2lnbmVkIGxvbmcgZmxhZ3M7CiAJc3RydWN0IGlycV9jZmcgKmNmZ19uZXc7CiAKLQlpcnEgPSAt
RU5PU1BDOworI2lmbmRlZiBDT05GSUdfSEFWRV9TUEFSU0VfSVJRCisJaXJxX3dhbnQgPSBucl9p
cnFzIC0gMTsKKyNlbmRpZgorCisJaXJxID0gMDsKIAlzcGluX2xvY2tfaXJxc2F2ZSgmdmVjdG9y
X2xvY2ssIGZsYWdzKTsKLQlmb3IgKG5ldyA9IChucl9pcnFzIC0gMSk7IG5ldyA+PSAwOyBuZXct
LSkgeworCWZvciAobmV3ID0gaXJxX3dhbnQ7IG5ldyA+IDA7IG5ldy0tKSB7CiAJCWlmIChwbGF0
Zm9ybV9sZWdhY3lfaXJxKG5ldykpCiAJCQljb250aW51ZTsKIAkJY2ZnX25ldyA9IGlycV9jZmco
bmV3KTsKQEAgLTI1MzMsNyArMjUzNyw3IEBAIGludCBjcmVhdGVfaXJxKHZvaWQpCiAJfQogCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJnZlY3Rvcl9sb2NrLCBmbGFncyk7CiAKLQlpZiAoaXJxID49
IDApIHsKKwlpZiAoaXJxID4gMCkgewogCQlkeW5hbWljX2lycV9pbml0KGlycSk7CiAJfQogCXJl
dHVybiBpcnE7CkBAIC0yNzg3LDEzICsyNzkxLDI5IEBAIHN0YXRpYyBpbnQgc2V0dXBfbXNpX2ly
cShzdHJ1Y3QgcGNpX2RldiAqZGV2LCBzdHJ1Y3QgbXNpX2Rlc2MgKmRlc2MsIGludCBpcnEpCiAJ
cmV0dXJuIDA7CiB9CiAKK3N0YXRpYyB1bnNpZ25lZCBpbnQgYnVpbGRfaXJxX2Zvcl9wY2lfZGV2
KHN0cnVjdCBwY2lfZGV2ICpkZXYpCit7CisJdW5zaWduZWQgaW50IGlycTsKKworCWlycSA9IGRl
di0+YnVzLT5udW1iZXI7CisJaXJxIDw8PSA4OworCWlycSB8PSBkZXYtPmRldmZuOworCWlycSA8
PD0gMTI7CisKKwlyZXR1cm4gaXJxOworfQorCiBpbnQgYXJjaF9zZXR1cF9tc2lfaXJxKHN0cnVj
dCBwY2lfZGV2ICpkZXYsIHN0cnVjdCBtc2lfZGVzYyAqZGVzYykKIHsKLQlpbnQgaXJxLCByZXQ7
CisJdW5zaWduZWQgaW50IGlycTsKKwlpbnQgcmV0OworCXVuc2lnbmVkIGlycV93YW50OwogCi0J
aXJxID0gY3JlYXRlX2lycSgpOwotCWlmIChpcnEgPCAwKQotCQlyZXR1cm4gaXJxOworCWlycV93
YW50ID0gYnVpbGRfaXJxX2Zvcl9wY2lfZGV2KGRldikgKyAweDEwMDsKKworCWlycSA9IGNyZWF0
ZV9pcnEoaXJxX3dhbnQpOworCWlmIChpcnEgPT0gMCkKKwkJcmV0dXJuIC0xOwogCiAjaWZkZWYg
Q09ORklHX0lOVFJfUkVNQVAKIAlpZiAoIWludHJfcmVtYXBwaW5nX2VuYWJsZWQpCkBAIC0yODIw
LDE4ICsyODQwLDIyIEBAIGVycm9yOgogCiBpbnQgYXJjaF9zZXR1cF9tc2lfaXJxcyhzdHJ1Y3Qg
cGNpX2RldiAqZGV2LCBpbnQgbnZlYywgaW50IHR5cGUpCiB7Ci0JaW50IGlycSwgcmV0LCBzdWJf
aGFuZGxlOworCXVuc2lnbmVkIGludCBpcnE7CisJaW50IHJldCwgc3ViX2hhbmRsZTsKIAlzdHJ1
Y3QgbXNpX2Rlc2MgKmRlc2M7CisJdW5zaWduZWQgaW50IGlycV93YW50OworCiAjaWZkZWYgQ09O
RklHX0lOVFJfUkVNQVAKIAlzdHJ1Y3QgaW50ZWxfaW9tbXUgKmlvbW11ID0gMDsKIAlpbnQgaW5k
ZXggPSAwOwogI2VuZGlmCiAKKwlpcnFfd2FudCA9IGJ1aWxkX2lycV9mb3JfcGNpX2RldihkZXYp
ICsgMHgxMDA7CiAJc3ViX2hhbmRsZSA9IDA7CiAJbGlzdF9mb3JfZWFjaF9lbnRyeShkZXNjLCAm
ZGV2LT5tc2lfbGlzdCwgbGlzdCkgewotCQlpcnEgPSBjcmVhdGVfaXJxKCk7Ci0JCWlmIChpcnEg
PCAwKQotCQkJcmV0dXJuIGlycTsKKwkJaXJxID0gY3JlYXRlX2lycShpcnFfd2FudC0tKTsKKwkJ
aWYgKGlycSA9PSAwKQorCQkJcmV0dXJuIC0xOwogI2lmZGVmIENPTkZJR19JTlRSX1JFTUFQCiAJ
CWlmICghaW50cl9yZW1hcHBpbmdfZW5hYmxlZCkKIAkJCWdvdG8gbm9faXI7CmRpZmYgLS1naXQg
YS9kcml2ZXJzL3BjaS9odGlycS5jIGIvZHJpdmVycy9wY2kvaHRpcnEuYwppbmRleCAyNzljOTQw
Li42YzgyZWFiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9odGlycS5jCisrKyBiL2RyaXZlcnMv
cGNpL2h0aXJxLmMKQEAgLTgyLDYgKzgyLDE4IEBAIHZvaWQgdW5tYXNrX2h0X2lycSh1bnNpZ25l
ZCBpbnQgaXJxKQogCXdyaXRlX2h0X2lycV9tc2coaXJxLCAmbXNnKTsKIH0KIAorc3RhdGljIHVu
c2lnbmVkIGludCBidWlsZF9pcnFfZm9yX3BjaV9kZXYoc3RydWN0IHBjaV9kZXYgKmRldikKK3sK
Kwl1bnNpZ25lZCBpbnQgaXJxOworCisJaXJxID0gZGV2LT5idXMtPm51bWJlcjsKKwlpcnEgPDw9
IDg7CisJaXJxIHw9IGRldi0+ZGV2Zm47CisJaXJxIDw8PSAxMjsKKworCXJldHVybiBpcnE7Cit9
CisKIC8qKgogICogX19odF9jcmVhdGVfaXJxIC0gY3JlYXRlIGFuIGlycSBhbmQgYXR0YWNoIGl0
IHRvIGEgZGV2aWNlLgogICogQGRldjogVGhlIGh5cGVydHJhbnNwb3J0IGRldmljZSB0byBmaW5k
IHRoZSBpcnEgY2FwYWJpbGl0eSBvbi4KQEAgLTk3LDcgKzEwOSw4IEBAIGludCBfX2h0X2NyZWF0
ZV9pcnEoc3RydWN0IHBjaV9kZXYgKmRldiwgaW50IGlkeCwgaHRfaXJxX3VwZGF0ZV90ICp1cGRh
dGUpCiAJdTMyIGRhdGE7CiAJaW50IG1heF9pcnE7CiAJaW50IHBvczsKLQlpbnQgaXJxOworCXVu
c2lnbmVkIGludCBpcnE7CisJdW5zaWduZWQgaW50IGlycV93YW50OwogCiAJcG9zID0gcGNpX2Zp
bmRfaHRfY2FwYWJpbGl0eShkZXYsIEhUX0NBUFRZUEVfSVJRKTsKIAlpZiAoIXBvcykKQEAgLTEy
NSw4ICsxMzgsOSBAQCBpbnQgX19odF9jcmVhdGVfaXJxKHN0cnVjdCBwY2lfZGV2ICpkZXYsIGlu
dCBpZHgsIGh0X2lycV91cGRhdGVfdCAqdXBkYXRlKQogCWNmZy0+bXNnLmFkZHJlc3NfbG8gPSAw
eGZmZmZmZmZmOwogCWNmZy0+bXNnLmFkZHJlc3NfaGkgPSAweGZmZmZmZmZmOwogCi0JaXJxID0g
Y3JlYXRlX2lycSgpOwotCWlmIChpcnEgPCAwKSB7CisJaXJxX3dhbnQ9IGJ1aWxkX2lycV9mb3Jf
cGNpX2RldihkZXYpOworCWlycSA9IGNyZWF0ZV9pcnEoaXJxX3dhbnQgKyBpZHgpOworCWlmIChp
cnEgPT0gMCkgewogCQlrZnJlZShjZmcpOwogCQlyZXR1cm4gLUVCVVNZOwogCX0KZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvaXJxLmggYi9pbmNsdWRlL2xpbnV4L2lycS5oCmluZGV4IDBmYjNh
ZTAuLmIxNzljY2QgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvaXJxLmgKKysrIGIvaW5jbHVk
ZS9saW51eC9pcnEuaApAQCAtNDA0LDcgKzQwNCw3IEBAIGV4dGVybiB2b2lkIHNldF9pcnFfbm9w
cm9iZSh1bnNpZ25lZCBpbnQgaXJxKTsKIGV4dGVybiB2b2lkIHNldF9pcnFfcHJvYmUodW5zaWdu
ZWQgaW50IGlycSk7CiAKIC8qIEhhbmRsZSBkeW5hbWljIGlycSBjcmVhdGlvbiBhbmQgZGVzdHJ1
Y3Rpb24gKi8KLWV4dGVybiBpbnQgY3JlYXRlX2lycSh2b2lkKTsKK2V4dGVybiB1bnNpZ25lZCBp
bnQgY3JlYXRlX2lycSh1bnNpZ25lZCBpbnQgaXJxX3dhbnQpOwogZXh0ZXJuIHZvaWQgZGVzdHJv
eV9pcnEodW5zaWduZWQgaW50IGlycSk7CiAKIC8qIFRlc3QgdG8gc2VlIGlmIGEgZHJpdmVyIGhh
cyBzdWNjZXNzZnVsbHkgcmVxdWVzdGVkIGFuIGlycSAqLwo=
------=_Part_57725_15269178.1218360117510--
