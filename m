Return-Path: <linux-kernel-owner+w=401wt.eu-S1761163AbYETCss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163AbYETCss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYETCsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:48:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:34333 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbYETCsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=ObInrKXM2E/lbb11q0i29Jn49dZ3muosnyloskxAe6b5AB04MD4CGzAP2C/VpOOJXhismRbJ+MpymEG15uUIp8sGn9RF5dj/TNxMKLAU1GSxpS0qAc4BKh64yovLNrmwmWQi7QRYivG/ysjUybzJWY8ZI2AwSckCUvsnem9M0jE=
Message-ID: <86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
Date: Mon, 19 May 2008 19:48:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080520022446.3b9c335a@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_18468_16374904.1211251718796"
References: <20080518014111.4f32298b@googlemail.com>
	 <86802c440805172055x30c2c6feg441e16f5fb24f64f@mail.gmail.com>
	 <20080518164127.2236d82a@googlemail.com>
	 <86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
	 <20080518232347.7964835c@snowcone>
	 <86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
	 <20080520014405.5eb150cd@googlemail.com>
	 <86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
	 <20080520022446.3b9c335a@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_18468_16374904.1211251718796
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, May 19, 2008 at 6:24 PM, Ciaran McCreesh
<ciaran.mccreesh@googlemail.com> wrote:
> On Mon, 19 May 2008 18:22:00 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>> >> could be pci iomem conflicts...
>> >> please enable CONFIG_PCI_DEBUG=y
>> >> and apply the following two debug patches
>> >
>> > dmesg with debugging attached.
>>
>> the iomem allocation seems good...
>>
>> can you send out /proc/iomem?
>
> 00000000-0009ffff : pnp 00:09
> 000f0000-000fffff : pnp 00:09
> 00100000-d7feffff : pnp 00:09
> d7ff0000-d7ffffff : pnp 00:09
> d8000000-dfffffff : PCI Bus 0000:01
>  d8000000-dfffffff : 0000:01:05.0
> e0000000-efffffff : PCI MMCONFIG 0
>  e0000000-efffffff : pnp 00:08
> fdb00000-fdbfffff : PCI Bus 0000:03
> fdc00000-fdcfffff : PCI Bus 0000:03
>  fdcff000-fdcff0ff : 0000:03:05.0
>    fdcff000-fdcff0ff : 8139too
> fdd00000-fddfffff : PCI Bus 0000:02
>  fdd00000-fdd1ffff : 0000:02:00.0
> fde00000-fdefffff : PCI Bus 0000:02
>  fdeff000-fdefffff : 0000:02:00.0
>    fdeff000-fdefffff : r8169
> fdf00000-fdffffff : PCI Bus 0000:01
>  fdf00000-fdf03fff : 0000:01:05.2
>    fdf00000-fdf03fff : ICH HD audio
>  fdff0000-fdffffff : 0000:01:05.0
> fe024000-fe027fff : 0000:00:14.2
>  fe024000-fe027fff : ICH HD audio
> fe029000-fe0290ff : 0000:00:13.5
>  fe029000-fe0290ff : ehci_hcd
> fe02a000-fe02afff : 0000:00:13.4
>  fe02a000-fe02afff : ohci_hcd
> fe02b000-fe02bfff : 0000:00:13.3
>  fe02b000-fe02bfff : ohci_hcd
> fe02c000-fe02cfff : 0000:00:13.2
>  fe02c000-fe02cfff : ohci_hcd
> fe02d000-fe02dfff : 0000:00:13.1
>  fe02d000-fe02dfff : ohci_hcd
> fe02e000-fe02efff : 0000:00:13.0
>  fe02e000-fe02efff : ohci_hcd
> fe02f000-fe02f3ff : 0000:00:12.0
>  fe02f000-fe02f3ff : ahci
> fec00000-fec00fff : IOAPIC 0
>  fec00000-fec00fff : pnp 00:09
> fed00000-fed003ff : HPET 0
>  fed00000-fed003ff : 0000:00:14.0
>    fed00000-fed000ff : pnp 00:09
> fee00000-fee00fff : Local APIC
>  fee00000-fee00fff : pnp 00:09
> ffff0000-ffffffff : pnp 00:09
> 100000000-11fffffff : System RAM
>  00200000-005d348d : Kernel code
>  005d348e-00771927 : Kernel data
>  007df000-0085f74f : Kernel bss


seems acpi pnp resource cause some problem....

please try attached patch and send out /proc/mtrr

YH

------=_Part_18468_16374904.1211251718796
Content-Type: text/x-patch; name=ram_reserve.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgfvxect1
Content-Disposition: attachment; filename=ram_reserve.patch

W1BBVENIXSB4ODY6IHVzZSByZXF1ZXN0IGluc3RlYWQgb2YgaW5zZXJ0IHJlc291cmNlIGZvciBl
ODIwIC0gNjRiaXQKCnRvIHByZXZlbnQgYWNwaSBwbnAgbWVzc2luZyBpdCB1cCBsYXRlciB3aXRo
IHJlcXVlc3QuCm90aGVyd2lzZSBzb21lIHN5c3RlbSB3aWxsIHNob3cKMDAwMDAwMDAtMDAwOWZm
ZmYgOiBwbnAgMDA6MDkKMDAwZjAwMDAtMDAwZmZmZmYgOiBwbnAgMDA6MDkKMDAxMDAwMDAtZDdm
ZWZmZmYgOiBwbnAgMDA6MDkKZDdmZjAwMDAtZDdmZmZmZmYgOiBwbnAgMDA6MDkKCmluc3RlYWQg
b2YgU3lzdGVtIFJBTS4uLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxA
Z21haWwuY29tPgoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvZTgyMF82NC5jCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9lODIwXzY0LmMKKysr
IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvZTgyMF82NC5jCkBAIC04OCw3ICs4OCw3IEBAIHZv
aWQgX19pbml0IGU4MjBfcmVzZXJ2ZV9yZXNvdXJjZXModm9pZCkKIAkJcmVzLT5zdGFydCA9IGU4
MjAubWFwW2ldLmFkZHI7CiAJCXJlcy0+ZW5kID0gcmVzLT5zdGFydCArIGU4MjAubWFwW2ldLnNp
emUgLSAxOwogCQlyZXMtPmZsYWdzID0gSU9SRVNPVVJDRV9NRU0gfCBJT1JFU09VUkNFX0JVU1k7
Ci0JCWluc2VydF9yZXNvdXJjZSgmaW9tZW1fcmVzb3VyY2UsIHJlcyk7CisJCXJlcXVlc3RfcmVz
b3VyY2UoJmlvbWVtX3Jlc291cmNlLCByZXMpOwogCQlyZXMrKzsKIAl9CiB9CkluZGV4OiBsaW51
eC0yLjYvYXJjaC94ODYva2VybmVsL3NldHVwXzY0LmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42
Lm9yaWcvYXJjaC94ODYva2VybmVsL3NldHVwXzY0LmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9r
ZXJuZWwvc2V0dXBfNjQuYwpAQCAtMzYxLDExICszNjEsNiBAQCB2b2lkIF9faW5pdCBzZXR1cF9h
cmNoKGNoYXIgKipjbWRsaW5lX3ApCiAKIAlmaW5pc2hfZTgyMF9wYXJzaW5nKCk7CiAKLQkvKiBh
ZnRlciBwYXJzZV9lYXJseV9wYXJhbSwgc28gY291bGQgZGVidWcgaXQgKi8KLQlpbnNlcnRfcmVz
b3VyY2UoJmlvbWVtX3Jlc291cmNlLCAmY29kZV9yZXNvdXJjZSk7Ci0JaW5zZXJ0X3Jlc291cmNl
KCZpb21lbV9yZXNvdXJjZSwgJmRhdGFfcmVzb3VyY2UpOwotCWluc2VydF9yZXNvdXJjZSgmaW9t
ZW1fcmVzb3VyY2UsICZic3NfcmVzb3VyY2UpOwotCiAJZWFybHlfZ2FydF9pb21tdV9jaGVjaygp
OwogCiAJZTgyMF9yZWdpc3Rlcl9hY3RpdmVfcmVnaW9ucygwLCAwLCAtMVVMKTsKQEAgLTQ3MSw2
ICs0NjYsMTEgQEAgdm9pZCBfX2luaXQgc2V0dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQogCQl9
CiAJfQogI2VuZGlmCisJZTgyMF9yZXNlcnZlX3Jlc291cmNlcygpOworCWluc2VydF9yZXNvdXJj
ZSgmaW9tZW1fcmVzb3VyY2UsICZjb2RlX3Jlc291cmNlKTsKKwlpbnNlcnRfcmVzb3VyY2UoJmlv
bWVtX3Jlc291cmNlLCAmZGF0YV9yZXNvdXJjZSk7CisJaW5zZXJ0X3Jlc291cmNlKCZpb21lbV9y
ZXNvdXJjZSwgJmJzc19yZXNvdXJjZSk7CisKIAlyZXNlcnZlX2NyYXNoa2VybmVsKCk7CiAKIAly
ZXNlcnZlX2liZnRfcmVnaW9uKCk7CkBAIC01MDIsNyArNTAyLDYgQEAgdm9pZCBfX2luaXQgc2V0
dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQogCS8qCiAJICogV2UgdHJ1c3QgZTgyMCBjb21wbGV0
ZWx5LiBObyBleHBsaWNpdCBST00gcHJvYmluZyBpbiBtZW1vcnkuCiAJICovCi0JZTgyMF9yZXNl
cnZlX3Jlc291cmNlcygpOwogCWU4MjBfbWFya19ub3NhdmVfcmVnaW9ucygpOwogCiAJLyogcmVx
dWVzdCBJL08gc3BhY2UgZm9yIGRldmljZXMgdXNlZCBvbiBhbGwgaVszNDVdODYgUENzICovCg==

------=_Part_18468_16374904.1211251718796--
