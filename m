Return-Path: <linux-kernel-owner+w=401wt.eu-S965847AbXCLNKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965847AbXCLNKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965849AbXCLNKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:10:06 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:52038 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965847AbXCLNKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:10:02 -0400
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C764A7.AA7E6000"
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: RE: RSDL v0.30 cpu scheduler for ... 2.6.18.8 kernel
Date: Mon, 12 Mar 2007 09:09:28 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7028FE62C@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: RSDL v0.30 cpu scheduler for ... 2.6.18.8 kernel
Thread-Index: AcdkVRFiDN33f5SyQkCTulKPF2UWVQAPZepQAAUQywA=
References: <009601c76492$e6844760$4b00a8c0@donald>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: <rol@as2917.net>, "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Mar 2007 13:09:29.0493 (UTC) FILETIME=[AB058450:01C764A7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C764A7.AA7E6000
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>=20
> Hello Vincent,
>=20
> As it seems the 5s net gain is during the early phase of the=20
> boot process, could you please post longer dmesgs, to let us=20
> know where the gain occurs ?

Hi Paul,

Here is an sdiff between the two dmesg:
[    0.000000] Linux version 2.6.18.8-amd64-envcan-003 (root@ | [
0.000000] Linux version 2.6.18.8-rsdl-0.30-amd64-envcan
[    0.000000] time.c: Detected 2210.220 MHz processor.       | [
0.000000] time.c: Detected 2210.215 MHz processor.
[   37.396210] Console: colour dummy device 80x25             | [
32.320335] Console: colour dummy device 80x25
[   37.397484] Dentry cache hash table entries: 262144 (order | [
32.321611] Dentry cache hash table entries: 262144 (order
[   37.399120] Inode-cache hash table entries: 131072 (order: | [
32.323318] Inode-cache hash table entries: 131072 (order:
[   37.399633] Checking aperture...                           | [
32.323869] Checking aperture...
[   37.399641] CPU 0: aperture @ 8400000000 size 32 MB        | [
32.323877] CPU 0: aperture @ 8400000000 size 32 MB
[   37.399645] Aperture too small (32 MB)                     | [
32.323881] Aperture too small (32 MB)
[   37.404577] No AGP bridge found                            | [
32.328813] No AGP bridge found
[   37.421192] Memory: 2054704k/2096000k available (1934k ker | [
32.345833] Memory: 2054704k/2096000k available (1935k ker
[   37.498110] Calibrating delay using timer specific routine | [
32.422230] Calibrating delay using timer specific routine

Here is a bit more detailed info:

Vanilla Version:
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Built 1 zonelists.  Total pages: 515848
[    0.000000] Kernel command line: root=3DLABEL=3DDebianEtch_64 ro
vga=3D0x305
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Disabling vsyscall due to use of PM timer
[    0.000000] time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
[    0.000000] time.c: Detected 2210.220 MHz processor.
[   37.396210] Console: colour dummy device 80x25
[   37.397484] Dentry cache hash table entries: 262144 (order: 9,
2097152 bytes)
[   37.399120] Inode-cache hash table entries: 131072 (order: 8, 1048576
bytes)
[   37.399633] Checking aperture...
[   37.399641] CPU 0: aperture @ 8400000000 size 32 MB
[   37.399645] Aperture too small (32 MB)
[   37.404577] No AGP bridge found
[   37.421192] Memory: 2054704k/2096000k available (1934k kernel code,
40908k reserved, 868k data, 188k init)


RSDL Version:
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Disabling vsyscall due to use of PM timer
[    0.000000] time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
[    0.000000] time.c: Detected 2210.215 MHz processor.
[   32.320335] Console: colour dummy device 80x25
[   32.321611] Dentry cache hash table entries: 262144 (order: 9,
2097152 bytes)
[   32.323318] Inode-cache hash table entries: 131072 (order: 8, 1048576
bytes)
[   32.323869] Checking aperture...
[   32.323877] CPU 0: aperture @ 8400000000 size 32 MB
[   32.323881] Aperture too small (32 MB)
[   32.328813] No AGP bridge found

There seems to be a some sort of lag happening adter the CPU
detection... It might simply be the call to vga=3D0x305 which takes less
or more time depending of the kernel?  I have attached a gzip full
dmesg.

>=20
> Regards,
> Paul
>=20

- vin=20

------_=_NextPart_001_01C764A7.AA7E6000
Content-Type: application/x-gzip;
	name="dmesg.2.6.18.8-rsdl-0.30-amd64-envcan.gz"
Content-Transfer-Encoding: base64
Content-Description: dmesg.2.6.18.8-rsdl-0.30-amd64-envcan.gz
Content-Disposition: attachment;
	filename="dmesg.2.6.18.8-rsdl-0.30-amd64-envcan.gz"

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
YtXe+T9yvNODdnIAAA==

------_=_NextPart_001_01C764A7.AA7E6000--
