Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0BCM3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:29:48 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:40978 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab0BCM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:29:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XIiwsDB2HlzOJgFgeGX7vGGMCnUP60rQAUdjLfXAUbefek1FOwxNKZKMxKkDNnmK94
         U11UDE4V58GQtuO7MRiDhZd+lpHXgTDp8zKpLA6Xt4UQO089VhU0W0yOr9GyZxD/w2h7
         pnmTWE36IlR+xaRU2UKqfmWZanhJOneAnbnog=
MIME-Version: 1.0
In-Reply-To: <20100203152947.f4955d91.sfr@canb.auug.org.au>
References: <20100203152947.f4955d91.sfr@canb.auug.org.au>
Date: Wed, 3 Feb 2010 14:29:43 +0200
Message-ID: <6ed0b2681002030429t1f6b33e9r3b6ea667fffb0f6a@mail.gmail.com>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap tree
From: Grazvydas Ignotas <notasas@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Content-Type: multipart/mixed; boundary=001485f78c6880b69c047eb15f8b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001485f78c6880b69c047eb15f8b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

hi,

On Wed, Feb 3, 2010 at 6:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wro=
te:
> Hi Tomi,
>
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> arch/arm/mach-omap2/board-omap3pandora.c between commit
> f8b6f704105164eac7c043a48f79c4234e03e4b2 ("omap: Rename hsmmc symbols to
> reflect independence from twl4030") from the omap tree and commit
> aacb4387a1e6f3b57977375532c6d8e47fcd5652 ("OMAP: pandora: add DSS2
> support and related regulators") from the omap_dss2 tree.

I've rebased my patch against linux-omap/for-next (attached). To fix
the conflict, Tomi can rebase his queue on linux-omap/for-next, or
Tony can simply take this to his queue - this has no "hard"
dependencies on other queued DSS2 changes, has only board file changes
and builds fine in linux-omap/for-next. I would prefer the second
option, as I plan sending more boardfile changes to linux-omap.

>
> I fixed it up (see below) and can carry the fix as necessary.
> --
> Cheers,
> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr@canb.auug.org=
.au
>
> diff --cc arch/arm/mach-omap2/board-omap3pandora.c
> index 9967b5d,bd3e577..0000000
> --- a/arch/arm/mach-omap2/board-omap3pandora.c
> +++ b/arch/arm/mach-omap2/board-omap3pandora.c
> @@@ -192,7 -193,62 +193,62 @@@ static struct twl4030_keypad_data pando
> =A0 =A0 =A0 =A0.rep =A0 =A0 =A0 =A0 =A0 =A0=3D 1,
> =A0};
>
> + static struct omap_dss_device pandora_lcd_device =3D {
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D "lcd",
> + =A0 =A0 =A0 .driver_name =A0 =A0 =A0 =A0 =A0 =A0=3D "tpo_td043mtea1_pan=
el",
> + =A0 =A0 =A0 .type =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D OMAP_DISPLAY_=
TYPE_DPI,
> + =A0 =A0 =A0 .phy.dpi.data_lines =A0 =A0 =3D 24,
> + =A0 =A0 =A0 .reset_gpio =A0 =A0 =A0 =A0 =A0 =A0 =3D 157,
> + };
> +
> + static struct omap_dss_device pandora_tv_device =3D {
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D "tv",
> + =A0 =A0 =A0 .driver_name =A0 =A0 =A0 =A0 =A0 =A0=3D "venc",
> + =A0 =A0 =A0 .type =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D OMAP_DISPLAY_=
TYPE_VENC,
> + =A0 =A0 =A0 .phy.venc.type =A0 =A0 =A0 =A0 =A0=3D OMAP_DSS_VENC_TYPE_SV=
IDEO,
> + };
> +
> + static struct omap_dss_device *pandora_dss_devices[] =3D {
> + =A0 =A0 =A0 &pandora_lcd_device,
> + =A0 =A0 =A0 &pandora_tv_device,
> + };
> +
> + static struct omap_dss_board_info pandora_dss_data =3D {
> + =A0 =A0 =A0 .num_devices =A0 =A0=3D ARRAY_SIZE(pandora_dss_devices),
> + =A0 =A0 =A0 .devices =A0 =A0 =A0 =A0=3D pandora_dss_devices,
> + =A0 =A0 =A0 .default_device =3D &pandora_lcd_device,
> + };
> +
> + static struct platform_device pandora_dss_device =3D {
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =3D "omapdss",
> + =A0 =A0 =A0 .id =A0 =A0 =A0 =A0 =A0 =A0 =3D -1,
> + =A0 =A0 =A0 .dev =A0 =A0 =A0 =A0 =A0 =A0=3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .platform_data =3D &pandora_dss_data,
> + =A0 =A0 =A0 },
> + };
> +
> + static struct regulator_consumer_supply pandora_vcc_lcd_supply =3D {
> + =A0 =A0 =A0 .supply =A0 =A0 =A0 =A0 =3D "vcc",
> + =A0 =A0 =A0 .dev =A0 =A0 =A0 =A0 =A0 =A0=3D &pandora_lcd_device.dev,
> + };
> +
> + static struct regulator_consumer_supply pandora_vdda_dac_supply =3D {
> + =A0 =A0 =A0 .supply =A0 =A0 =A0 =A0 =3D "vdda_dac",
> + =A0 =A0 =A0 .dev =A0 =A0 =A0 =A0 =A0 =A0=3D &pandora_dss_device.dev,
> + };
> +
> + static struct regulator_consumer_supply pandora_vdds_supplies[] =3D {
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .supply =A0 =A0 =A0 =A0 =3D "vdds_sdi",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .dev =A0 =A0 =A0 =A0 =A0 =A0=3D &pandora_ds=
s_device.dev,
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .supply =A0 =A0 =A0 =A0 =3D "vdds_dsi",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .dev =A0 =A0 =A0 =A0 =A0 =A0=3D &pandora_ds=
s_device.dev,
> + =A0 =A0 =A0 },
> + };
> +
> =A0-static struct twl4030_hsmmc_info omap3pandora_mmc[] =3D {
> =A0+static struct omap2_hsmmc_info omap3pandora_mmc[] =3D {
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.mmc =A0 =A0 =A0 =A0 =A0 =A0=3D 1,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.wires =A0 =A0 =A0 =A0 =A0=3D 4,
>

--001485f78c6880b69c047eb15f8b
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-OMAP-pandora-add-DSS2-support-and-related-regulato.patch"
Content-Disposition: attachment; 
	filename="0001-OMAP-pandora-add-DSS2-support-and-related-regulato.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g5837qdq0

RnJvbSA2ZWY4NTBhMTU5YjRlNTdiNzkyZDdmODRlMThjNDQzZWYxNWZlM2U1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHcmF6dnlkYXMgSWdub3RhcyA8bm90YXNhc0BnbWFpbC5jb20+
CkRhdGU6IFdlZCwgMTMgSmFuIDIwMTAgMjI6MTk6MDcgKzAxMDAKU3ViamVjdDogW1BBVENIXSBP
TUFQOiBwYW5kb3JhOiBhZGQgRFNTMiBzdXBwb3J0IGFuZCByZWxhdGVkIHJlZ3VsYXRvcnMKClRo
aXMgcGF0Y2ggYWRkcyBjb25maWd1cmF0aW9uIGRhdGEgZm9yIERTUzIgYW5kIHNldHMgdXAKZGlz
cGxheSByZWxhdGVkIHJlZ3VsYXRvcnMuCgpTaWduZWQtb2ZmLWJ5OiBHcmF6dnlkYXMgSWdub3Rh
cyA8bm90YXNhc0BnbWFpbC5jb20+CkFja2VkLWJ5OiBUb21pIFZhbGtlaW5lbiA8dG9taS52YWxr
ZWluZW5Abm9raWEuY29tPgotLS0KIGFyY2gvYXJtL21hY2gtb21hcDIvYm9hcmQtb21hcDNwYW5k
b3JhLmMgfCAgMTExICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlcyBjaGFu
Z2VkLCAxMTEgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNo
L2FybS9tYWNoLW9tYXAyL2JvYXJkLW9tYXAzcGFuZG9yYS5jIGIvYXJjaC9hcm0vbWFjaC1vbWFw
Mi9ib2FyZC1vbWFwM3BhbmRvcmEuYwppbmRleCA5OTY3YjVkLi43ZWEzODk0IDEwMDY0NAotLS0g
YS9hcmNoL2FybS9tYWNoLW9tYXAyL2JvYXJkLW9tYXAzcGFuZG9yYS5jCisrKyBiL2FyY2gvYXJt
L21hY2gtb21hcDIvYm9hcmQtb21hcDNwYW5kb3JhLmMKQEAgLTQwLDYgKzQwLDcgQEAKICNpbmNs
dWRlIDxtYWNoL2hhcmR3YXJlLmg+CiAjaW5jbHVkZSA8cGxhdC9tY3NwaS5oPgogI2luY2x1ZGUg
PHBsYXQvdXNiLmg+CisjaW5jbHVkZSA8cGxhdC9kaXNwbGF5Lmg+CiAKICNpbmNsdWRlICJtdXgu
aCIKICNpbmNsdWRlICJzZHJhbS1taWNyb24tbXQ0NmgzMm0zMmxmLTYuaCIKQEAgLTE5Miw2ICsx
OTMsNjEgQEAgc3RhdGljIHN0cnVjdCB0d2w0MDMwX2tleXBhZF9kYXRhIHBhbmRvcmFfa3BfZGF0
YSA9IHsKIAkucmVwCQk9IDEsCiB9OwogCitzdGF0aWMgc3RydWN0IG9tYXBfZHNzX2RldmljZSBw
YW5kb3JhX2xjZF9kZXZpY2UgPSB7CisJLm5hbWUJCQk9ICJsY2QiLAorCS5kcml2ZXJfbmFtZQkJ
PSAidHBvX3RkMDQzbXRlYTFfcGFuZWwiLAorCS50eXBlCQkJPSBPTUFQX0RJU1BMQVlfVFlQRV9E
UEksCisJLnBoeS5kcGkuZGF0YV9saW5lcwk9IDI0LAorCS5yZXNldF9ncGlvCQk9IDE1NywKK307
CisKK3N0YXRpYyBzdHJ1Y3Qgb21hcF9kc3NfZGV2aWNlIHBhbmRvcmFfdHZfZGV2aWNlID0gewor
CS5uYW1lCQkJPSAidHYiLAorCS5kcml2ZXJfbmFtZQkJPSAidmVuYyIsCisJLnR5cGUJCQk9IE9N
QVBfRElTUExBWV9UWVBFX1ZFTkMsCisJLnBoeS52ZW5jLnR5cGUJCT0gT01BUF9EU1NfVkVOQ19U
WVBFX1NWSURFTywKK307CisKK3N0YXRpYyBzdHJ1Y3Qgb21hcF9kc3NfZGV2aWNlICpwYW5kb3Jh
X2Rzc19kZXZpY2VzW10gPSB7CisJJnBhbmRvcmFfbGNkX2RldmljZSwKKwkmcGFuZG9yYV90dl9k
ZXZpY2UsCit9OworCitzdGF0aWMgc3RydWN0IG9tYXBfZHNzX2JvYXJkX2luZm8gcGFuZG9yYV9k
c3NfZGF0YSA9IHsKKwkubnVtX2RldmljZXMJPSBBUlJBWV9TSVpFKHBhbmRvcmFfZHNzX2Rldmlj
ZXMpLAorCS5kZXZpY2VzCT0gcGFuZG9yYV9kc3NfZGV2aWNlcywKKwkuZGVmYXVsdF9kZXZpY2UJ
PSAmcGFuZG9yYV9sY2RfZGV2aWNlLAorfTsKKworc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgcGFuZG9yYV9kc3NfZGV2aWNlID0geworCS5uYW1lCQk9ICJvbWFwZHNzIiwKKwkuaWQJCT0g
LTEsCisJLmRldgkJPSB7CisJCS5wbGF0Zm9ybV9kYXRhID0gJnBhbmRvcmFfZHNzX2RhdGEsCisJ
fSwKK307CisKK3N0YXRpYyBzdHJ1Y3QgcmVndWxhdG9yX2NvbnN1bWVyX3N1cHBseSBwYW5kb3Jh
X3ZjY19sY2Rfc3VwcGx5ID0geworCS5zdXBwbHkJCT0gInZjYyIsCisJLmRldgkJPSAmcGFuZG9y
YV9sY2RfZGV2aWNlLmRldiwKK307CisKK3N0YXRpYyBzdHJ1Y3QgcmVndWxhdG9yX2NvbnN1bWVy
X3N1cHBseSBwYW5kb3JhX3ZkZGFfZGFjX3N1cHBseSA9IHsKKwkuc3VwcGx5CQk9ICJ2ZGRhX2Rh
YyIsCisJLmRldgkJPSAmcGFuZG9yYV9kc3NfZGV2aWNlLmRldiwKK307CisKK3N0YXRpYyBzdHJ1
Y3QgcmVndWxhdG9yX2NvbnN1bWVyX3N1cHBseSBwYW5kb3JhX3ZkZHNfc3VwcGxpZXNbXSA9IHsK
Kwl7CisJCS5zdXBwbHkJCT0gInZkZHNfc2RpIiwKKwkJLmRldgkJPSAmcGFuZG9yYV9kc3NfZGV2
aWNlLmRldiwKKwl9LAorCXsKKwkJLnN1cHBseQkJPSAidmRkc19kc2kiLAorCQkuZGV2CQk9ICZw
YW5kb3JhX2Rzc19kZXZpY2UuZGV2LAorCX0sCit9OworCiBzdGF0aWMgc3RydWN0IG9tYXAyX2hz
bW1jX2luZm8gb21hcDNwYW5kb3JhX21tY1tdID0gewogCXsKIAkJLm1tYwkJPSAxLApAQCAtMjc3
LDYgKzMzMyw1MSBAQCBzdGF0aWMgc3RydWN0IHJlZ3VsYXRvcl9pbml0X2RhdGEgcGFuZG9yYV92
bW1jMiA9IHsKIAkuY29uc3VtZXJfc3VwcGxpZXMJPSAmcGFuZG9yYV92bW1jMl9zdXBwbHksCiB9
OwogCisvKiBWREFDIGZvciBEU1MgZHJpdmluZyBTLVZpZGVvICovCitzdGF0aWMgc3RydWN0IHJl
Z3VsYXRvcl9pbml0X2RhdGEgcGFuZG9yYV92ZGFjID0geworCS5jb25zdHJhaW50cyA9IHsKKwkJ
Lm1pbl91VgkJCT0gMTgwMDAwMCwKKwkJLm1heF91VgkJCT0gMTgwMDAwMCwKKwkJLmFwcGx5X3VW
CQk9IHRydWUsCisJCS52YWxpZF9tb2Rlc19tYXNrCT0gUkVHVUxBVE9SX01PREVfTk9STUFMCisJ
CQkJCXwgUkVHVUxBVE9SX01PREVfU1RBTkRCWSwKKwkJLnZhbGlkX29wc19tYXNrCQk9IFJFR1VM
QVRPUl9DSEFOR0VfTU9ERQorCQkJCQl8IFJFR1VMQVRPUl9DSEFOR0VfU1RBVFVTLAorCX0sCisJ
Lm51bV9jb25zdW1lcl9zdXBwbGllcwk9IDEsCisJLmNvbnN1bWVyX3N1cHBsaWVzCT0gJnBhbmRv
cmFfdmRkYV9kYWNfc3VwcGx5LAorfTsKKworLyogVlBMTDIgZm9yIGRpZ2l0YWwgdmlkZW8gb3V0
cHV0cyAqLworc3RhdGljIHN0cnVjdCByZWd1bGF0b3JfaW5pdF9kYXRhIHBhbmRvcmFfdnBsbDIg
PSB7CisJLmNvbnN0cmFpbnRzID0geworCQkubWluX3VWCQkJPSAxODAwMDAwLAorCQkubWF4X3VW
CQkJPSAxODAwMDAwLAorCQkuYXBwbHlfdVYJCT0gdHJ1ZSwKKwkJLnZhbGlkX21vZGVzX21hc2sJ
PSBSRUdVTEFUT1JfTU9ERV9OT1JNQUwKKwkJCQkJfCBSRUdVTEFUT1JfTU9ERV9TVEFOREJZLAor
CQkudmFsaWRfb3BzX21hc2sJCT0gUkVHVUxBVE9SX0NIQU5HRV9NT0RFCisJCQkJCXwgUkVHVUxB
VE9SX0NIQU5HRV9TVEFUVVMsCisJfSwKKwkubnVtX2NvbnN1bWVyX3N1cHBsaWVzCT0gQVJSQVlf
U0laRShwYW5kb3JhX3ZkZHNfc3VwcGxpZXMpLAorCS5jb25zdW1lcl9zdXBwbGllcwk9IHBhbmRv
cmFfdmRkc19zdXBwbGllcywKK307CisKKy8qIFZBVVgxIGZvciBMQ0QgKi8KK3N0YXRpYyBzdHJ1
Y3QgcmVndWxhdG9yX2luaXRfZGF0YSBwYW5kb3JhX3ZhdXgxID0geworCS5jb25zdHJhaW50cyA9
IHsKKwkJLm1pbl91VgkJCT0gMzAwMDAwMCwKKwkJLm1heF91VgkJCT0gMzAwMDAwMCwKKwkJLmFw
cGx5X3VWCQk9IHRydWUsCisJCS52YWxpZF9tb2Rlc19tYXNrCT0gUkVHVUxBVE9SX01PREVfTk9S
TUFMCisJCQkJCXwgUkVHVUxBVE9SX01PREVfU1RBTkRCWSwKKwkJLnZhbGlkX29wc19tYXNrCQk9
IFJFR1VMQVRPUl9DSEFOR0VfTU9ERQorCQkJCQl8IFJFR1VMQVRPUl9DSEFOR0VfU1RBVFVTLAor
CX0sCisJLm51bV9jb25zdW1lcl9zdXBwbGllcwk9IDEsCisJLmNvbnN1bWVyX3N1cHBsaWVzCT0g
JnBhbmRvcmFfdmNjX2xjZF9zdXBwbHksCit9OworCiBzdGF0aWMgc3RydWN0IHR3bDQwMzBfdXNi
X2RhdGEgb21hcDNwYW5kb3JhX3VzYl9kYXRhID0gewogCS51c2JfbW9kZQk9IFQyX1VTQl9NT0RF
X1VMUEksCiB9OwpAQCAtMjk4LDYgKzM5OSw5IEBAIHN0YXRpYyBzdHJ1Y3QgdHdsNDAzMF9wbGF0
Zm9ybV9kYXRhIG9tYXAzcGFuZG9yYV90d2xkYXRhID0gewogCS5jb2RlYwkJPSAmb21hcDNwYW5k
b3JhX2NvZGVjX2RhdGEsCiAJLnZtbWMxCQk9ICZwYW5kb3JhX3ZtbWMxLAogCS52bW1jMgkJPSAm
cGFuZG9yYV92bW1jMiwKKwkudmRhYwkJPSAmcGFuZG9yYV92ZGFjLAorCS52cGxsMgkJPSAmcGFu
ZG9yYV92cGxsMiwKKwkudmF1eDEJCT0gJnBhbmRvcmFfdmF1eDEsCiAJLmtleXBhZAkJPSAmcGFu
ZG9yYV9rcF9kYXRhLAogfTsKIApAQCAtMzY1LDYgKzQ2OSwxMiBAQCBzdGF0aWMgc3RydWN0IHNw
aV9ib2FyZF9pbmZvIG9tYXAzcGFuZG9yYV9zcGlfYm9hcmRfaW5mb1tdIF9faW5pdGRhdGEgPSB7
CiAJCS5jb250cm9sbGVyX2RhdGEJPSAmYWRzNzg0Nl9tY3NwaV9jb25maWcsCiAJCS5pcnEJCQk9
IE9NQVBfR1BJT19JUlEoT01BUDNfUEFORE9SQV9UU19HUElPKSwKIAkJLnBsYXRmb3JtX2RhdGEJ
CT0gJmFkczc4NDZfY29uZmlnLAorCX0sIHsKKwkJLm1vZGFsaWFzCQk9ICJ0cG9fdGQwNDNtdGVh
MV9wYW5lbF9zcGkiLAorCQkuYnVzX251bQkJPSAxLAorCQkuY2hpcF9zZWxlY3QJCT0gMSwKKwkJ
Lm1heF9zcGVlZF9oegkJPSAzNzUwMDAsCisJCS5wbGF0Zm9ybV9kYXRhCQk9ICZwYW5kb3JhX2xj
ZF9kZXZpY2UsCiAJfQogfTsKIApAQCAtMzc5LDYgKzQ4OSw3IEBAIHN0YXRpYyB2b2lkIF9faW5p
dCBvbWFwM3BhbmRvcmFfaW5pdF9pcnEodm9pZCkKIHN0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlICpvbWFwM3BhbmRvcmFfZGV2aWNlc1tdIF9faW5pdGRhdGEgPSB7CiAJJnBhbmRvcmFfbGVk
c19ncGlvLAogCSZwYW5kb3JhX2tleXNfZ3BpbywKKwkmcGFuZG9yYV9kc3NfZGV2aWNlLAogfTsK
IAogc3RhdGljIHN0cnVjdCBlaGNpX2hjZF9vbWFwX3BsYXRmb3JtX2RhdGEgZWhjaV9wZGF0YSBf
X2luaXRjb25zdCA9IHsKLS0gCjEuNS42LjMKCg==
--001485f78c6880b69c047eb15f8b--
