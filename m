Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZLYMc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZLYMc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 07:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZLYMc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 07:32:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:43451 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZLYMc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 07:32:56 -0500
MIME-Version: 1.0
In-Reply-To: <2d0a357f0912250315r1f3922e1ta731d03a313d69c6@mail.gmail.com>
References: <2d0a357f0912241711o97011od6c1750d7acf8b9e@mail.gmail.com>
	 <4B3413C4.6070602@gmail.com>
	 <2d0a357f0912250048h2bc987ccs4d4d253a4155becf@mail.gmail.com>
	 <2d0a357f0912250315r1f3922e1ta731d03a313d69c6@mail.gmail.com>
Date: Fri, 25 Dec 2009 13:32:54 +0100
Message-ID: <2d0a357f0912250432l4c407696g5ff7c35d5721a2ae@mail.gmail.com>
Subject: Re: [2.6.33-rc2] ACPI problems on HP nc6400 notebook
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Cc: len.brown@intel.com, maciej.rutecki@gmail.com, w.landgraf@ru.ru,
       "Justin P. Mattock" <justinmattock@gmail.com>
Content-Type: multipart/mixed; boundary=00148531b4004151cd047b8cc15e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00148531b4004151cd047b8cc15e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

While dell-wmi and hp-wmi is concerned I only applied this patch (see
file attachment):

    0001-Revert-wmi-Free-the-allocated-acpi-objects-through-w.patch

This fixes ACPI/WMI problems onmy HP nc6400 notebook.

----- Please REVERT the following commit in 2.6.33-rc2 -----

commit 3e9b988e4edf065d39c1343937f717319b1c1065
Refs: v2.6.33-rc1-10-g3e9b988
Author:     Anisse Astier <anisse@astier.eu>
AuthorDate: Fri Dec 4 10:10:09 2009 +0100
Commit:     Len Brown <len.brown@intel.com>
CommitDate: Thu Dec 24 00:42:00 2009 -0500

    wmi: Free the allocated acpi objects through wmi_get_event_data

    These function allocate an acpi object by calling wmi_get_event_data, w=
hich
    then calls acpi_evaluate_object, and it is not freed afterwards.

    And kernel doc is fixed for parameters of wmi_get_event_data.

    Signed-off-by: Anisse Astier <anisse@astier.eu>
    Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
    Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>
[...]

- Sedat -

On Fri, Dec 25, 2009 at 12:15 PM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> [CCed linux-acpi ML, maciej.rutecki@gmail.com and landgraf@ru.ru]
> (see [2] and [3])
>
> GOTCHA!
>
> I reverted patches introduced in:
>
> commit 2969cd482ebe9c5b82d55917b0cd41175eff042a:
> "Merge branch 'misc-2.6.33' into release"
>
> ...and now I could boot into 2.6.33-rc2.
>
> Here the revert-acpi-patches:
>
> $ ls debian/patches/revert-acpi-patches/
> 0001-Revert-hp-wmi-Fix-two-memleaks.patch
> 0002-Revert-acer-wmi-msi-wmi-Remove-needless-DMI-MODULE_A.patch
> 0003-Revert-dell-wmi-do-not-keep-driver-loaded-on-unsuppo.patch
> 0004-Revert-wmi-Free-the-allocated-acpi-objects-through-w.patch
> 0005-Revert-drivers-platform-x86-acerhdf.c-check-BIOS-inf.patch
> 0006-Revert-acerhdf-add-new-BIOS-versions.patch
> 0007-Revert-acerhdf-limit-modalias-matching-to-supported.patch
> 0008-Revert-toshiba_acpi-convert-to-seq_file.patch
> 0009-Revert-asus_acpi-convert-to-seq_file.patch
> 0010-Revert-ACPI-do-not-select-ACPI_DOCK-from-ATA_ACPI.patch
> 0011-Revert-MAINTAINERS-add-maintainer-for-msi-wmi-driver.patch
> 0012-Revert-fujitu-laptop-fix-tests-of-acpi_evaluate_inte.patch
> 0013-Revert-arch-x86-kernel-cpu-cpufreq-acpi-cpufreq.c-av.patch
>
> In [1] you can find revert-acpi-patchset, dmesg & lspci outputs of my
> new kernel.
>
> Marciej and Werner can you please verify or dig deeper by partially
> excluding the single reverts?
> Thank you.
>
> Kind Regards,
> - Sedat -
>
> [1] http://files.iniza.org/linux-kernel/BUG_2.6.33-rc2/
> [2] http://marc.info/?l=3Dlinux-kernel&m=3D126171951030608&w=3D2
> [3] http://marc.info/?l=3Dlinux-kernel&m=3D126173586309724&w=3D2
>
> On Fri, Dec 25, 2009 at 9:48 AM, Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>> Hi,
>>
>> as I suspected it is an ACPI issue while I tried to boot with "acpi=3Dof=
f".
>>
>> I have taken new screenshots and added dmesg (acpi=3Doff) and all
>> messages in /var/log/* [1].
>>
>> It is possible to load acpi kernel-module afterwards?
>> Or it is not possible whenn loading with acpi=3Doff?
>>
>> @Len Brown:
>> There are two photos showing thermal problems.
>> Notebook did shut down in the night.
>> But this was before 2.6.33-rc2.
>>
>> I will not try a bisect (visting currently my brother and working with
>> touchpad really sucks), but I will revert the wmi-related (wmi/hp-wmi)
>> commits.
>> There seems problems with wmi on other systems w/ 2.6.33-rc2 [2].
>>
>> Kind Regards,
>> - Sedat -
>>
>> [1] http://files.iniza.org/linux-kernel/BUG_2.6.33-rc2/
>> [2] http://marc.info/?l=3Dlinux-kernel&m=3D126171951030608&w=3D2
>>
>> On Fri, Dec 25, 2009 at 2:22 AM, Justin P. Mattock
>> <justinmattock@gmail.com> wrote:
>>> On 12/24/09 17:11, Sedat Dilek wrote:
>>>>
>>>> Hi,
>>>>
>>>> I build linux-2.6.33-rc2 on a Debian/sid 32-bit host.
>>>> Unfortunately, this kernel falls in an unusable state (sort of loop)
>>>> and does not a normal startup.
>>>>
>>>> With this setting (see below), I hoped to catch the early
>>>> boot-messages (but, no success):
>>>>
>>>> # cat /etc/default/bootlogd
>>>> # Run bootlogd at startup ?
>>>> BOOTLOGD_ENABLE=3DYes
>>>>
>>>> Finally, I could take a picture [1].
>>>> It seems to be that latest ACPI patches are breaking my system
>>>> (speculating).
>>>>
>>>> Q: How can I log such early boot (error) messages to give a detailled =
log?
>>>>
>>>> Hope this helps fixing the problem.
>>>>
>>>> Kind Regards,
>>>> - Sedat -
>>>>
>>>>
>>>> [1] http://files.iniza.org/linux-kernel/DSCN2134.JPG
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel=
" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.htm=
l
>>>> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>>>>
>>>
>>> you can try(if you have the port)
>>> ohci1394_dma=3Dearly or the usb
>>> early logging located in kernel hacking.
>>>
>>> but if this thing is hitting way early it
>>> might be a bit more tricky.
>>>
>>> if you can try =C2=A0a bisect from the bad
>>> kernel to the good.
>>>
>>> Justin P. Mattock
>>>
>>
>

--00148531b4004151cd047b8cc15e
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-Revert-wmi-Free-the-allocated-acpi-objects-through-w.patch"
Content-Disposition: attachment; 
	filename="0001-Revert-wmi-Free-the-allocated-acpi-objects-through-w.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3mxxzsc1

RnJvbSBmMjM2NmEwYjAwOWRlM2ZjN2JlOTk2N2U5ZTY1YTEyYjY2NmIwNWMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBGcmksIDI1IERlYyAyMDA5IDA5OjU0OjMxICswMTAwClN1YmplY3Q6IFtQQVRDSF0gUmV2
ZXJ0ICJ3bWk6IEZyZWUgdGhlIGFsbG9jYXRlZCBhY3BpIG9iamVjdHMgdGhyb3VnaCB3bWlfZ2V0
X2V2ZW50X2RhdGEiCgpUaGlzIHJldmVydHMgY29tbWl0IDNlOWI5ODhlNGVkZjA2NWQzOWMxMzQz
OTM3ZjcxNzMxOWIxYzEwNjUuCi0tLQogZHJpdmVycy9wbGF0Zm9ybS94ODYvZGVsbC13bWkuYyB8
ICAgIDEgLQogZHJpdmVycy9wbGF0Zm9ybS94ODYvaHAtd21pLmMgICB8ICAgIDIgLS0KIGRyaXZl
cnMvcGxhdGZvcm0veDg2L3dtaS5jICAgICAgfCAgICA0ICsrLS0KIDMgZmlsZXMgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGxh
dGZvcm0veDg2L2RlbGwtd21pLmMgYi9kcml2ZXJzL3BsYXRmb3JtL3g4Ni9kZWxsLXdtaS5jCmlu
ZGV4IDY1NjFkZmMuLjY3ZjNmZTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGxhdGZvcm0veDg2L2Rl
bGwtd21pLmMKKysrIGIvZHJpdmVycy9wbGF0Zm9ybS94ODYvZGVsbC13bWkuYwpAQCAtMjM4LDcg
KzIzOCw2IEBAIHN0YXRpYyB2b2lkIGRlbGxfd21pX25vdGlmeSh1MzIgdmFsdWUsIHZvaWQgKmNv
bnRleHQpCiAJCQlpbnB1dF9zeW5jKGRlbGxfd21pX2lucHV0X2Rldik7CiAJCX0KIAl9Ci0Ja2Zy
ZWUob2JqKTsKIH0KIAogCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BsYXRmb3JtL3g4Ni9ocC13bWku
YyBiL2RyaXZlcnMvcGxhdGZvcm0veDg2L2hwLXdtaS5jCmluZGV4IGRiMTBjNWQuLjYzYzNlNjUg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGxhdGZvcm0veDg2L2hwLXdtaS5jCisrKyBiL2RyaXZlcnMv
cGxhdGZvcm0veDg2L2hwLXdtaS5jCkBAIC0zODEsOCArMzgxLDYgQEAgc3RhdGljIHZvaWQgaHBf
d21pX25vdGlmeSh1MzIgdmFsdWUsIHZvaWQgKmNvbnRleHQpCiAJfSBlbHNlCiAJCXByaW50ayhL
RVJOX0lORk8gIkhQIFdNSTogVW5rbm93biBrZXkgcHJlc3NlZCAtICV4XG4iLAogCQkJZXZlbnRj
b2RlKTsKLQotCWtmcmVlKG9iaik7CiB9CiAKIHN0YXRpYyBpbnQgX19pbml0IGhwX3dtaV9pbnB1
dF9zZXR1cCh2b2lkKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wbGF0Zm9ybS94ODYvd21pLmMgYi9k
cml2ZXJzL3BsYXRmb3JtL3g4Ni93bWkuYwppbmRleCA5ZjkzZDZjLi5lNDI1YTg2IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3BsYXRmb3JtL3g4Ni93bWkuYworKysgYi9kcml2ZXJzL3BsYXRmb3JtL3g4
Ni93bWkuYwpAQCAtNTQwLDggKzU0MCw4IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHdtaV9yZW1vdmVf
bm90aWZ5X2hhbmRsZXIpOwogLyoqCiAgKiB3bWlfZ2V0X2V2ZW50X2RhdGEgLSBHZXQgV01JIGRh
dGEgYXNzb2NpYXRlZCB3aXRoIGFuIGV2ZW50CiAgKgotICogQGV2ZW50OiBFdmVudCB0byBmaW5k
Ci0gKiBAb3V0OiBCdWZmZXIgdG8gaG9sZCBldmVudCBkYXRhLiBvdXQtPnBvaW50ZXIgc2hvdWxk
IGJlIGZyZWVkIHdpdGgga2ZyZWUoKQorICogQGV2ZW50IC0gRXZlbnQgdG8gZmluZAorICogJm91
dCAtIEJ1ZmZlciB0byBob2xkIGV2ZW50IGRhdGEKICAqCiAgKiBSZXR1cm5zIGV4dHJhIGRhdGEg
YXNzb2NpYXRlZCB3aXRoIGFuIGV2ZW50IGluIFdNSS4KICAqLwotLSAKMS42LjUuNwoK
--00148531b4004151cd047b8cc15e--
