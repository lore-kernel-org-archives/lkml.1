Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYJDQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYJDQ1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYJDQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 12:27:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:43301 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751833AbYJDQ1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 12:27:08 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/Vr7VyzO/Vp4ASof8wnB47pTzrVEFiBMFJ4itj+3
	t52uJP9fEw/6OI
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: patch sata_nv-disable-hardreset-for-generic.patch added to 2.6.26-stable tree
Date: Sat, 4 Oct 2008 18:27:03 +0200
User-Agent: KMail/1.9.9
Cc: tj@kernel.org, gregkh@suse.de, jgarzik@redhat.com, pchen@nvidia.com,
       stable@kernel.org
References: <20081001234424.C72C114543E5@imap.suse.de>
In-Reply-To: <20081001234424.C72C114543E5@imap.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart122318328.npy3HuDcpp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810041827.04721.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart122318328.npy3HuDcpp
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Yl55IrE8XSRmKvd"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_Yl55IrE8XSRmKvd
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Donnerstag, 2. Oktober 2008, gregkh@suse.de wrote:
>=20
> This is a note to let you know that we have just queued up the patch titl=
ed
>=20
>     Subject: sata_nv: disable hardreset for generic
>=20
> to the 2.6.26-stable tree.  Its filename is
>=20
>     sata_nv-disable-hardreset-for-generic.patch
>=20
> A git repo of this tree can be found at=20
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>=20
>=20
> From 2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 29 Aug 2008 16:13:12 +0200
> Subject: sata_nv: disable hardreset for generic
>=20
> From: Tejun Heo <tj@kernel.org>
>=20
> commit 2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6 upstream
>=20
> of them being unifying probing, hotplug and EH reset paths uniform.
> Previously, broken hardreset could go unnoticed as it wasn't used
> during probing but when something goes wrong or after hotplug the
> problem will surface and bite hard.
>=20
> OSDL bug 11195 reports that sata_nv generic flavor falls into this
> category.  Hardreset itself succeeds but PHY stays offline after
> hardreset.  I tried longer debounce timing but the result was the
> same.
>=20
>   http://bugzilla.kernel.org/show_bug.cgi?id=3D11195
>=20
> So, it seems we'll have to drop hardreset from the generic flavor.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Peer Chen <pchen@nvidia.com>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

On 2.6.26.5 + the pending stable queue applied, this patch results in lots=
=20
of noise in my syslog (full gzipped dmesg with and without this patch=20
attached):

ata4: EH complete
ata5: EH pending after 5 tries, giving up
ata5: EH complete
ata6: EH pending after 5 tries, giving up
ata6: EH complete
ata5: EH pending after 5 tries, giving up
ata5: EH complete
ata6: EH pending after 5 tries, giving up
ata6: EH complete

reverting just this patch fixes the issue again.

This triggers reproducably for me on different nforce3 and nforce4 systems=
=20
running a 64 bit kernel:

nforce3:
00:00.0 Host bridge [0600]: nVidia Corporation nForce3 250Gb Host Bridge [1=
0de:00e1] (rev a1)
00:01.0 ISA bridge [0601]: nVidia Corporation nForce3 250Gb LPC Bridge [10d=
e:00e0] (rev a2)
00:01.1 SMBus [0c05]: nVidia Corporation nForce 250Gb PCI System Management=
 [10de:00e4] (rev a1)
00:02.0 USB Controller [0c03]: nVidia Corporation CK8S USB Controller [10de=
:00e7] (rev a1)
00:02.1 USB Controller [0c03]: nVidia Corporation CK8S USB Controller [10de=
:00e7] (rev a1)
00:02.2 USB Controller [0c03]: nVidia Corporation nForce3 EHCI USB 2.0 Cont=
roller [10de:00e8] (rev a2)
00:05.0 Bridge [0680]: nVidia Corporation CK8S Ethernet Controller [10de:00=
df] (rev a2)
00:06.0 Multimedia audio controller [0401]: nVidia Corporation nForce3 250G=
b AC'97 Audio Controller [10de:00ea] (rev a1)
00:08.0 IDE interface [0101]: nVidia Corporation CK8S Parallel ATA Controll=
er (v2.5) [10de:00e5] (rev a2)
00:09.0 IDE interface [0101]: nVidia Corporation nForce3 Serial ATA Control=
ler 2 [10de:00ee] (rev a2)
00:0a.0 IDE interface [0101]: nVidia Corporation nForce3 Serial ATA Control=
ler [10de:00e3] (rev a2)
00:0b.0 PCI bridge [0604]: nVidia Corporation nForce3 250Gb AGP Host to PCI=
 Bridge [10de:00e2] (rev a2)
00:0e.0 PCI bridge [0604]: nVidia Corporation nForce3 250Gb PCI-to-PCI Brid=
ge [10de:00ed] (rev a2)
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] Miscellaneous Control [1022:1103]
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV280 [Radeo=
n 9200 PRO] [1002:5960] (rev 01)
01:00.1 Display controller [0380]: ATI Technologies Inc RV280 [Radeon 9200 =
PRO] (Secondary) [1002:5940] (rev 01)
02:0a.0 Multimedia controller [0480]: Philips Semiconductors TriMedia TM-13=
00 [1131:5402] (rev 82)
02:0c.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6306 Fire II =
IEEE 1394 OHCI Link Layer Controller [1106:3044] (rev 46)
02:0d.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-816=
9 Gigabit Ethernet [10ec:8169] (rev 10)

nforce4:
00:00.0 Memory controller [0580]: nVidia Corporation CK804 Memory Controlle=
r [10de:005e] (rev a3)
00:01.0 ISA bridge [0601]: nVidia Corporation CK804 ISA Bridge [10de:0050] =
(rev a3)
00:01.1 SMBus [0c05]: nVidia Corporation CK804 SMBus [10de:0052] (rev a2)
00:02.0 USB Controller [0c03]: nVidia Corporation CK804 USB Controller [10d=
e:005a] (rev a2)
00:02.1 USB Controller [0c03]: nVidia Corporation CK804 USB Controller [10d=
e:005b] (rev a3)
00:04.0 Multimedia audio controller [0401]: nVidia Corporation CK804 AC'97 =
Audio Controller [10de:0059] (rev a2)
00:06.0 IDE interface [0101]: nVidia Corporation CK804 IDE [10de:0053] (rev=
 f2)
00:07.0 IDE interface [0101]: nVidia Corporation CK804 Serial ATA Controlle=
r [10de:0054] (rev f3)
00:08.0 IDE interface [0101]: nVidia Corporation CK804 Serial ATA Controlle=
r [10de:0055] (rev f3)
00:09.0 PCI bridge [0604]: nVidia Corporation CK804 PCI Bridge [10de:005c] =
(rev a2)
00:0a.0 Bridge [0680]: nVidia Corporation CK804 Ethernet Controller [10de:0=
057] (rev a3)
00:0b.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d]=
 (rev a3)
00:0c.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d]=
 (rev a3)
00:0d.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d]=
 (rev a3)
00:0e.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d]=
 (rev a3)
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] Miscellaneous Control [1022:1103]
01:06.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-818=
5 IEEE 802.11a/b/g Wireless LAN Controller [10ec:8185] (rev 20)
01:07.0 Ethernet controller [0200]: Intel Corporation 82541GI Gigabit Ether=
net Controller [8086:1076]
01:0c.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6306 Fire II =
IEEE 1394 OHCI Link Layer Controller [1106:3044] (rev 80)
05:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV370 5B60 [=
Radeon X300 (PCIE)] [1002:5b60]
05:00.1 Display controller [0380]: ATI Technologies Inc RV370 [Radeon X300S=
E] [1002:5b70]

and=20

nforce4
00:00.0 Memory controller [0580]: nVidia Corporation CK804 Memory Controlle=
r [10de:005e] (rev a3)
00:01.0 ISA bridge [0601]: nVidia Corporation CK804 ISA Bridge [10de:0050] =
(rev a3)
00:01.1 SMBus [0c05]: nVidia Corporation CK804 SMBus [10de:0052] (rev a2)
00:02.0 USB Controller [0c03]: nVidia Corporation CK804 USB Controller [10d=
e:005a] (rev a2)
00:02.1 USB Controller [0c03]: nVidia Corporation CK804 USB Controller [10d=
e:005b] (rev a3)
00:04.0 Multimedia audio controller [0401]: nVidia Corporation CK804 AC'97 =
Audio Controller [10de:0059] (rev a2)
00:06.0 IDE interface [0101]: nVidia Corporation CK804 IDE [10de:0053] (rev=
 f2)
00:07.0 IDE interface [0101]: nVidia Corporation CK804 Serial ATA Controlle=
r [10de:0054] (rev f3)
00:08.0 IDE interface [0101]: nVidia Corporation CK804 Serial ATA Controlle=
r [10de:0055] (rev f3)
00:09.0 PCI bridge [0604]: nVidia Corporation CK804 PCI Bridge [10de:005c] =
(rev a2)
00:0a.0 Bridge [0680]: nVidia Corporation CK804 Ethernet Controller [10de:0=
057] (rev a3)
00:0b.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d]=
 (rev a3)
00:0c.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d]=
 (rev a3)
00:0d.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d]=
 (rev a3)
00:0e.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d]=
 (rev a3)
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opter=
on] Miscellaneous Control [1022:1103]
01:07.0 Multimedia video controller [0400]: Conexant CX23880/1/2/3 PCI Vide=
o and Audio Decoder [14f1:8800] (rev 05)
01:07.1 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video and =
Audio Decoder [Audio Port] [14f1:8801] (rev 05)
01:07.2 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video and =
Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
01:07.4 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video and =
Audio Decoder [IR Port] [14f1:8804] (rev 05)
01:08.0 Network controller [0280]: Techsan Electronics Co Ltd B2C2 FlexCopI=
I DVB chip / Technisat SkyStar2 DVB card [13d0:2103] (rev 02)
01:0a.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB82AA2 IEEE-1394b =
Link Layer Controller [104c:8025] (rev 01)
02:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88E8053 P=
CI-E Gigabit Ethernet Controller [11ab:4362] (rev 19)
05:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV370 5B60 [=
Radeon X300 (PCIE)] [1002:5b60]
05:00.1 Display controller [0380]: ATI Technologies Inc RV370 [Radeon X300S=
E] [1002:5b70]

Regards
	Stefan Lippers-Hollmann

> ---
>  drivers/ata/sata_nv.c |   19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
>=20
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -309,8 +309,6 @@ static void nv_nf2_freeze(struct ata_por
>  static void nv_nf2_thaw(struct ata_port *ap);
>  static void nv_ck804_freeze(struct ata_port *ap);
>  static void nv_ck804_thaw(struct ata_port *ap);
> -static int nv_hardreset(struct ata_link *link, unsigned int *class,
> -			unsigned long deadline);
>  static int nv_adma_slave_config(struct scsi_device *sdev);
>  static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
>  static void nv_adma_qc_prep(struct ata_queued_cmd *qc);
> @@ -407,7 +405,7 @@ static struct scsi_host_template nv_swnc
> =20
>  static struct ata_port_operations nv_generic_ops =3D {
>  	.inherits		=3D &ata_bmdma_port_ops,
> -	.hardreset		=3D nv_hardreset,
> +	.hardreset		=3D ATA_OP_NULL,
>  	.scr_read		=3D nv_scr_read,
>  	.scr_write		=3D nv_scr_write,
>  };
> @@ -1588,21 +1586,6 @@ static void nv_mcp55_thaw(struct ata_por
>  	ata_sff_thaw(ap);
>  }
> =20
> -static int nv_hardreset(struct ata_link *link, unsigned int *class,
> -			unsigned long deadline)
> -{
> -	int rc;
> -
> -	/* SATA hardreset fails to retrieve proper device signature on
> -	 * some controllers.  Request follow up SRST.  For more info,
> -	 * see http://bugzilla.kernel.org/show_bug.cgi?id=3D3352
> -	 */
> -	rc =3D sata_sff_hardreset(link, class, deadline);
> -	if (rc)
> -		return rc;
> -	return -EAGAIN;
> -}
> -
>  static void nv_adma_error_handler(struct ata_port *ap)
>  {
>  	struct nv_adma_port_priv *pp =3D ap->private_data;
>=20
>=20
> Patches currently in stable-queue which might be from tj@kernel.org are
>=20
> queue-2.6.26/sata_nv-disable-hardreset-for-generic.patch

--Boundary-01=_Yl55IrE8XSRmKvd
Content-Type: application/x-gzip;
  name="with-2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="with-2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6.log.gz"

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

--Boundary-01=_Yl55IrE8XSRmKvd
Content-Type: application/x-gzip;
  name="without-2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="without-2fd673ecf0378ddeeeb87b3605e50212e0c0ddc6.log.gz"

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
G2Et2DsfbwAA

--Boundary-01=_Yl55IrE8XSRmKvd--

--nextPart122318328.npy3HuDcpp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjnmVgACgkQORbEMfgJlPZIiACeKrxSiHDHOO2Bh/5wDYZ+inmQ
UNwAoLK8VzuEmvLoYP2RSeu62gbKp+D8
=WhqR
-----END PGP SIGNATURE-----

--nextPart122318328.npy3HuDcpp--
