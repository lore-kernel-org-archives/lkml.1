Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYHWTSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYHWTSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYHWTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:18:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:56279 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbYHWTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=hMTcJ7IecxmxDMOZJI1zGBAOvEUYbr/cXsrciav/b26RCT21CAEmrSDT6HdEDQhiEb
         lvxOhVOjwn7gRGZoSRZt3QyrD0pNxBY0nxhfClbYdZ0SM3iwNSYcICE+8VnDCOYDcBM4
         Lou5lWPt6FN8Xtbp3auh2aW8199duS0cnrRAo=
Message-ID: <86802c440808231217q3eebc738v863170b178bb03ab@mail.gmail.com>
Date: Sat, 23 Aug 2008 12:17:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rufus & Azrael" <rufus-azrael@numericable.fr>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kenrel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>
In-Reply-To: <48B0563B.2040207@numericable.fr>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_34487_9404078.1219519078827"
References: <48B0563B.2040207@numericable.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_34487_9404078.1219519078827
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Aug 23, 2008 at 11:26 AM, Rufus & Azrael
<rufus-azrael@numericable.fr> wrote:
>>
>> On Sat, Aug 23, 2008 at 4:58 AM, David Witbrodt<dawitbro@sbcglobal.net>
>>  wrote:
>> >
>> >
>> >>  please send out after booting with hpet=disable
>> >>  lspci -tv
>> >>  lspci -vvxxx
>> >
>> >  Info attached:
>>
>> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 13)
>>        Subsystem: Elitegroup Computer Systems Device 2621
>>        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium>TAbort-
>> <TAbort-<MAbort->SERR-<PERR- INTx-
>>        Region 0: I/O ports at fa00 [size=16]
>>        Region 1: Memory at 80000000 (32-bit, non-prefetchable) [size=1K]
>>        Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
>>        Kernel driver in use: piix4_smbus
>> 00: 02 10 85 43 03 04 30 02 13 00 05 0c 00 00 80 00
>> 10: 01 fa 00 00 00 00 00 80 00 00 00 00 00 00 00 00
>> 20: 00 00 00 00 00 00 00 00 00 00 00 00 19 10 21 26
>> 30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00
>> 40: d4 3b 00 05 00 00 00 00 0f ff 00 00 00 00 00 00
>> 50: f0 01 f0 0e f0 0f f0 07 11 0b f0 0f 00 00 00 00
>> 60: 01 00 24 00 bf fd de 8f 3f 90 00 00 20 00 00 00
>> 70: 00 01 00 00 08 00 c0 fe ff 6e 00 00 00 00 f0 0f
>> 80: f0 0a f0 0f 00 00 00 00 00 00 00 00 8c 00 00 80
>> 90: 01 fa 00 00 fa de ff 00 00 00 00 00 00 00 00 00
>> a0: 00 00 ff ff ff ff f0 08 ff fd 12 02 16 7b 20 00
>> b0: 08 00 02 a8 00 00 00 00 00 00 00 00 f0 0f 08 1a
>> c0: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00
>> d0: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
>> e0: 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> f0: d8 0c 00 00 00 00 44 00 00 00 00 00 aa 00 10 01
>> it seems kernel update BAR1 from 0xfed00000 to 0x80000000 after it can
>> not give 0xfed00000 to that device.
>> please try attached patch, and send out lspci -vvxxxx again.
>> YH
>> [PATCH] x86: protect hpet in BAR for one ATI chipset
>>
>> so avoid kernel don't allocate nre resource for it because it can not
>> allocate the old
>> address from BIOS.
>>
>> the same way like some IO APIC address in BAR handling
>>
>> Signed-off-by: Yinghai Lu<yhlu.kenrel@gmail.com>
>>
>> ---
>>  drivers/pci/quirks.c |   16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>> Index: linux-2.6/drivers/pci/quirks.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/quirks.c
>> +++ linux-2.6/drivers/pci/quirks.c
>> @@ -1918,6 +1918,22 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_B
>>                         PCI_DEVICE_ID_NX2_5709S,
>>                         quirk_brcm_570x_limit_vpd);
>>
>> +static void __init quirk_hpet_in_bar(struct pci_dev *pdev)
>> +{
>> +       int i;
>> +       unsigned int base, size;
>> +
>> +       /* the BAR1 is the location of the HPET...we must
>> +        * not touch this, so forcibly insert it into the resource tree */
>> +       base = pci_resource_start(pdev, 1);
>> +       size = pci_resource_len(pdev, 1);
>> +       if (base&&  size) {
>> +               insert_resource(&iomem_resource,&pdev->resource[1]);
>> +               dev_info(&dev->dev, "HPET at %04x-%04x\n", name, base,
>> base + size - 1);
>> +       }
>> +}
>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 0x3485, quirk_hpet_in_bar);
>> +
>>  #ifdef CONFIG_PCI_MSI
>>  /* Some chipsets do not support MSI. We cannot easily rely on setting
>>   * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
>
> Hi Yinghai,
>
>
> Your patch seems to be broken, see :
>
>>  CC      drivers/pci/quirks.o
>> drivers/pci/quirks.c: In function 'quirk_hpet_in_bar':
>> drivers/pci/quirks.c:1804: erreur: 'dev' undeclared (first use in this
>> function)
>> drivers/pci/quirks.c:1804: erreur: (Each undeclared identifier is reported
>> only once
>> drivers/pci/quirks.c:1804: erreur: for each function it appears in.)
>> drivers/pci/quirks.c:1804: erreur: 'name' undeclared (first use in this
>> function)
>> drivers/pci/quirks.c:1804: attention : trop d'arguments pour le format
>> drivers/pci/quirks.c:1795: attention : unused variable 'i'
>> make[2]: *** [drivers/pci/quirks.o] Erreur 1
>

please check v2.

YH

------=_Part_34487_9404078.1219519078827
Content-Type: text/x-patch; name=hpet_in_bar1_v2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk8m44t40
Content-Disposition: attachment; filename=hpet_in_bar1_v2.patch

W1BBVENIXSB4ODY6IHByb3RlY3QgaHBldCBpbiBCQVIgZm9yIG9uZSBBVEkgY2hpcHNldCB2MgoK
c28gYXZvaWQga2VybmVsIGRvbid0IGFsbG9jYXRlIG5yZSByZXNvdXJjZSBmb3IgaXQgYmVjYXVz
ZSBpdCBjYW4gbm90IGFsbG9jYXRlIHRoZSBvbGQKYWRkcmVzcyBmcm9tIEJJT1MuCgp0aGUgc2Ft
ZSB3YXkgbGlrZSBzb21lIElPIEFQSUMgYWRkcmVzcyBpbiBCQVIgaGFuZGxpbmcKClNpZ25lZC1v
ZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VucmVsQGdtYWlsLmNvbT4KCi0tLQogZHJpdmVycy9w
Y2kvcXVpcmtzLmMgfCAgIDE2ICsrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNiBp
bnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3F1aXJrcy5jCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3F1aXJrcy5jCisrKyBsaW51eC0y
LjYvZHJpdmVycy9wY2kvcXVpcmtzLmMKQEAgLTE5MTgsNiArMTkxOCwyMiBAQCBERUNMQVJFX1BD
SV9GSVhVUF9IRUFERVIoUENJX1ZFTkRPUl9JRF9CCiAJCQkgUENJX0RFVklDRV9JRF9OWDJfNTcw
OVMsCiAJCQkgcXVpcmtfYnJjbV81NzB4X2xpbWl0X3ZwZCk7CiAKK3N0YXRpYyB2b2lkIF9faW5p
dCBxdWlya19ocGV0X2luX2JhcihzdHJ1Y3QgcGNpX2RldiAqcGRldikKK3sKKwlpbnQgaTsKKwl1
NjQgYmFzZSwgc2l6ZTsKKworCS8qIHRoZSBCQVIxIGlzIHRoZSBsb2NhdGlvbiBvZiB0aGUgSFBF
VC4uLndlIG11c3QKKwkgKiBub3QgdG91Y2ggdGhpcywgc28gZm9yY2libHkgaW5zZXJ0IGl0IGlu
dG8gdGhlIHJlc291cmNlIHRyZWUgKi8KKwliYXNlID0gcGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYs
IDEpOworCXNpemUgPSBwY2lfcmVzb3VyY2VfbGVuKHBkZXYsIDEpOworCWlmIChiYXNlICYmIHNp
emUpIHsKKwkJaW5zZXJ0X3Jlc291cmNlKCZpb21lbV9yZXNvdXJjZSwgJnBkZXYtPnJlc291cmNl
WzFdKTsKKwkJZGV2X2luZm8oJnBkZXYtPmRldiwgIkhQRVQgYXQgJTA4bGx4LSUwOGxseFxuIiwg
YmFzZSwgYmFzZSArIHNpemUgLSAxKTsKKwl9Cit9CitERUNMQVJFX1BDSV9GSVhVUF9IRUFERVIo
UENJX1ZFTkRPUl9JRF9BVEksIDB4MzQ4NSwgcXVpcmtfaHBldF9pbl9iYXIpOworCiAjaWZkZWYg
Q09ORklHX1BDSV9NU0kKIC8qIFNvbWUgY2hpcHNldHMgZG8gbm90IHN1cHBvcnQgTVNJLiBXZSBj
YW5ub3QgZWFzaWx5IHJlbHkgb24gc2V0dGluZwogICogUENJX0JVU19GTEFHU19OT19NU0kgaW4g
aXRzIGJ1cyBmbGFncyBiZWNhdXNlIHRoZXJlIGFyZSBhY3R1YWxseQo=
------=_Part_34487_9404078.1219519078827--
