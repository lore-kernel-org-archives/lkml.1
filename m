Return-Path: <linux-kernel-owner+w=401wt.eu-S1767801AbXCJEM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767801AbXCJEM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767782AbXCJELz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:11:55 -0500
Received: from relay5.ptmail.sapo.pt ([212.55.154.25]:58413 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1767781AbXCJELL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:11:11 -0500
X-AntiVirus: PTMail-AV 0.3-0.90.0
Subject: and try remove another quirk on this computers Re: [3/6]
	2.6.21-rc2: known regressions
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: Mathieu =?ISO-8859-1?Q?B=E9rard?= <Mathieu.Berard@crans.org>
Cc: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <45F20541.9090208@crans.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015036.GH3441@stusta.de> <45EE9E39.3010800@garzik.org>
	 <45F20541.9090208@crans.org>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-rcvjDeUNh1VIPUv47EU4"
Date: Sat, 10 Mar 2007 04:11:36 +0000
Message-Id: <1173499896.21891.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rcvjDeUNh1VIPUv47EU4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-03-10 at 02:09 +0100, Mathieu B=C3=A9rard wrote:
> Jeff Garzik a =C3=A9crit :
> > Adrian Bunk wrote:
> >> Subject    : NCQ problem with ahci and Hitachi drive
> >> References : http://lkml.org/lkml/2007/3/4/178
> >> Submitter  : Mathieu B=C3=A9rard <Mathieu.Berard@crans.org>
> >> Status     : unknown
> >
> > according to the last message in that thread, it sounds like ACPI and
> > interrupt problems
> >
> Hi,
> after more testing with a 2.6.21-rc3, it appears that after several ata
> errors the boot process
> somehow continued as normal, after a "NCQ disabled due to excessive
> errors" message.
> "pci=3Dnoacpi" or "noacpi" parameters workarounds the problem "irqpoll"
> does nothing.


Hi, I have a laptop quite similar to this report, but still running
2.4.20.
With /usr/bin/hal-device-manager on (00:1f.1) 82801FB/FBM/FR/FW/FRW
(ICH6 Family) IDE Controller (rev 03
I found that I have an Hitachi Travelstar 80GN.=20

And your initial report point that you have an Hitachi Travelstar 5K100
and the patch http://lkml.org/lkml/2007/2/22/8 blacklist your HD ,
correct ?=20

I will try 20-rc3 to see if I have any problem.
but blacklist it is not a good solution ...=20

well I recently found a quirk that is apply on laptop that I mention
here. which I remove from my kernel because I don't have a Assus and my
laptop is quirked too.=20

--- linux-2.6.20.i686/drivers/pci/quirks.c.orig 2007-03-04 04:52:21.0000000=
00 +0000
+++ linux-2.6.20.i686/drivers/pci/quirks.c      2007-03-04 04:52:41.0000000=
00 +0000
@@ -1121,8 +1121,8 @@ static void asus_hides_smbus_lpc_ich6(st
        iounmap(base);
        printk(KERN_INFO "PCI: Enabled ICH6/i801 SMBus device\n");
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,  PCI_DEVICE_ID_INTEL_ICH6_1,=
     asus_hides_smbus_lpc_ich6 );
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,  PCI_DEVICE_ID_INTEL_ICH6_1,=
     asus_hides_smbus_lpc_ich6 );
+/* DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,       PCI_DEVICE_ID_INTEL=
_ICH6_1,     asus_hides_smbus_lpc_ich6 ); */
+/* DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,       PCI_DEVICE_ID_INTEL=
_ICH6_1,     asus_hides_smbus_lpc_ich6 ); */

 /*
  * SiS 96x south bridge: BIOS typically hides SMBus device...


With this quirk I got this oops on hibernate (but computer still
working)=20

Suspending console(s)
eth1: Going into suspend...
ACPI: PCI interrupt for device 0000:02:04.0 disabled
ACPI: PCI interrupt for device 0000:00:1e.3 disabled
ACPI: PCI interrupt for device 0000:00:1e.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ipw2200: Unable to load ucode: -22
ipw2200: Unable to load firmware: -22
ipw2200: Failed to up device
swsusp: critical section:
swsusp: Need to copy 57480 pages
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
BUG: sleeping function called from invalid context at mm/slab.c:3035
in_atomic():0, irqs_disabled():1
no locks held by pm-hibernate/22979.
irq event stamp: 0
hardirqs last  enabled at (0): [<00000000>] 0x0
hardirqs last disabled at (0): [<c042580c>] copy_process+0x311/0x1249
softirqs last  enabled at (0): [<c042580c>] copy_process+0x311/0x1249
softirqs last disabled at (0): [<00000000>] 0x0
 [<c04051c9>] show_trace_log_lvl+0x1a/0x2f
 [<c040576e>] show_trace+0x12/0x14
 [<c04057f2>] dump_stack+0x16/0x18
 [<c0421266>] __might_sleep+0xc9/0xcf
 [<c0474cb1>] kmem_cache_alloc+0x28/0xc4
 [<c046bb50>] __get_vm_area_node+0x87/0x16f
 [<c046bcae>] __get_vm_area+0x22/0x28
 [<c046bcf3>] get_vm_area+0x3f/0x43
 [<c041f0ed>] __ioremap+0xa0/0xe6
 [<c041f147>] ioremap_nocache+0x14/0x79
 [<c04f070a>] asus_hides_smbus_lpc_ich6+0x37/0x61
 [<c04ef384>] pci_fixup_device+0x70/0x7c
 [<c04f0a70>] pci_device_resume_early+0x17/0x2e
 [<c0550779>] dpm_power_up+0x41/0x53
 [<c0550798>] device_power_up+0xd/0xf
 [<c0448bc4>] swsusp_suspend+0x55/0x62
 [<c044929c>] pm_suspend_disk+0xd5/0x181
 [<c04480a7>] enter_state+0x51/0x172
 [<c044824e>] state_store+0x86/0x9c
 [<c04b0a58>] subsys_attr_store+0x20/0x25
 [<c04b0b69>] sysfs_write_file+0xb8/0xe0
 [<c0478c68>] vfs_write+0xaf/0x163
 [<c04792b6>] sys_write+0x3d/0x61
 [<c0404058>] syscall_call+0x7/0xb
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
PCI: Enabled ICH6/i801 SMBus device

removing quirk resolve the oops.

BTW I have an HP Compaq nx6110 , what laptop is yours ?=20

ah! and WTF I don't attach your dmesg in a file ?=20
=20
>=20
> lspci:
> 00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
> Express Processor to DRAM Controller (rev 03)
> 00:01.0 PCI bridge: Intel Corporation Mobile 915GM/PM Express PCI
> Express Root Port (rev 03)
> 00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) PCI Express Port 1 (rev 03)
> 00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) PCI Express Port 2 (rev 03)
> 00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) USB UHCI #1 (rev 03)
> 00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) USB UHCI #2 (rev 03)
> 00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) USB UHCI #3 (rev 03)
> 00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) USB UHCI #4 (rev 03)
> 00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) USB2 EHCI Controller (rev 03)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
> 00:1e.2 Multimedia audio controller: Intel Corporation
> 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
> 00:1e.3 Modem: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> AC'97 Modem Controller (rev 03)
> 00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface
> Bridge (rev 03)
> 00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
> Family) IDE Controller (rev 03)
> 00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA
> Controller (rev 03)
> 00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> SMBus Controller (rev 03)
> 01:00.0 VGA compatible controller: ATI Technologies Inc M24 [Radeon
> Mobility X600]
> 06:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ (rev 10)
> 06:02.0 Network controller: Intel Corporation PRO/Wireless 2200BG
> Network Connection (rev 05)
> 06:04.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
> 06:04.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394
> Host Controller
> 06:04.3 Mass storage controller: Texas Instruments PCIxx21 Integrated
> FlashMedia Controller
> 06:04.4 Generic system peripheral [0805]: Texas Instruments
> PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
>=20
>=20
> /proc/interrupts:
>         CPU0     =20
>   0:       3242   IO-APIC-edge      timer
>   1:        863   IO-APIC-edge      i8042
>   8:          3   IO-APIC-edge      rtc
>   9:          1   IO-APIC-fasteoi   acpi
>  12:        116   IO-APIC-edge      i8042
>  14:        128   IO-APIC-edge      libata
>  15:          0   IO-APIC-edge      libata
>  16:          1   IO-APIC-fasteoi   uhci_hcd:usb4, yenta
>  17:          0   IO-APIC-fasteoi   tifm_7xx1, Intel ICH6
>  18:        249   IO-APIC-fasteoi   eth0
>  19:       2712   IO-APIC-fasteoi   libata, uhci_hcd:usb2, sdhci:slot0,
> sdhci:slot1, sdhci:slot2
>  20:         47   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
>  21:          3   IO-APIC-fasteoi   uhci_hcd:usb3, ohci1394
>  22:          1   IO-APIC-fasteoi   ipw2200
> NMI:          0
> LOC:      15767
> ERR:          0
> MIS:          0


--=20
S=C3=A9rgio M. B.

--=-rcvjDeUNh1VIPUv47EU4
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGVjCCAw8w
ggJ4oAMCAQICEGne8YrzxxgYAeyxZxmiO+owDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MTAxMTEwMjAzOVoXDTA3MTAxMTEwMjAz
OVowSzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEoMCYGCSqGSIb3DQEJARYZc2Vy
Z2lvQHNlcmdpb21iLm5vLWlwLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN9R
ix9koyWSNQDmAHxcSeWXdFO1osqg2yeNgBBl+fz8FLYyROsDGpZMcnOd/Df6tWwMZpMSYDNIksiZ
5VkCWaWIzIBccHX3wIkqrkcq3v1OcPGW9adXClXSbSZ0Hb4V4+bQ9LMAOjaMlH/dKLVkln6qmbko
NOxgPotdVxCGcUy1Pqa4dT1zFo5+nIv1NAUNqKpq63X/+3nILNG4JGAvLIL8wcYs0cETGS6vISgd
YFN/JlIqekWUGGUmc+SJcyyTWjXGN+2G0SDS8K3a9NFCo7a1Y0FyHQxikQRtB9sCcpQCoXiqaWsT
npSrNJ0Od4w1sHZz09uEdhWKqXEmJsKKwi8CAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgSQMBEGCWCG
SAGG+EIBAQQEAwIFoDAkBgNVHREEHTAbgRlzZXJnaW9Ac2VyZ2lvbWIubm8taXAub3JnMAwGA1Ud
EwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAwVE8/kY82qYG7I2+gW0NhSyn+DR0uAWYbSxB2NgP
16QOrzXt2HazlXkl2Bc+NKQEqEGKOu5fPPg2GoJ3zDO1Y8GUNGtJH0sX+63RGoUNOAv+bAK1Nxhb
illDUUCjW3OqA/hRyBwjU9kHJPYhl1EbAUGpAhfENHjkS/S7b1REBLMwggM/MIICqKADAgECAgEN
MA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIw
EAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9D
ZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwg
RnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20w
HhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZy
ZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZ
Wh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuv
PAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBly
YLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRw
Oi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMC
AQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEB
BQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFh
YsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVN
d+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIB/DCCAfgCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UE
ChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEGne8YrzxxgYAeyxZxmiO+owCQYFKw4DAhoFAKBdMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDMxMDA0MTEzNlowIwYJKoZI
hvcNAQkEMRYEFKBVbB8uCua9Kg1iisMv5xvyKX7MMA0GCSqGSIb3DQEBAQUABIIBAFJzLMgV+7dO
Ebhm1WNpY9fIg5TEqwp4tnGg7/LcczCpGacQLf4pHROLjqGm2xeprFgjqJ5jIMWuYDIPgGiKw7Op
KG9PYzMFGxuSA8eA7DQZ/X+Fdo2oDXMdOOK0QLTHDnAvWDia8pnINeACw5HmMrjX4MYOvIGFfKhl
NMAcweYkswSBYs21HL6iUEaF5gL49Ox15Jorr39WM7U0RkYpQYa22xtgptBHiARKIbCSzrunkrME
5DQ/moF81OL/SGSb4/6cYfpJ15F2vv/vHUBNjUzLlN7/S0cu/oz50eZP3BPHNExd5NV3uVVrhPvG
sIQsY6m/HY1PofrY2nErn41cVk8AAAAAAAA=


--=-rcvjDeUNh1VIPUv47EU4--

