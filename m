Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYFXT5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYFXT5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYFXT5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:57:37 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:43891 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYFXT5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=lm72Fvs135pfcZjNJDVjXb4EFaBamAUvMA5xb+8eFHOQQf5YLXzT2/4O/EXrrPxjYV
         j7y0aO3iXYjzxJc14DBZJjVwdfGWlnsVmX2lSxqxi0UvXKpB16oTOgJbuTbgARS/FmZO
         vos+DGfOb6LlheGaT4mh0WnIiZvWh1egtqfVc=
Message-ID: <86802c440806241257m4401300aq6ce24787ec80b5cd@mail.gmail.com>
Date: Tue, 24 Jun 2008 12:57:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/3] e820_update_range(): Strip size of original region
Cc: x86@kernel.org, vgoyal@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1214318125-32619-2-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_170_1251426.1214337455358"
References: <1214318125-32619-1-git-send-email-bwalle@suse.de>
	 <1214318125-32619-2-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_170_1251426.1214337455358
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Jun 24, 2008 at 7:35 AM, Bernhard Walle <bwalle@suse.de> wrote:
> This patch fixes a bug in e820_update_range(): Previously, if a region was
> partially covered, then e820_update_range() only added a new E820 range but
> didn't update the end/size of the previous range. That lead to duplicate
> covering of a region.
>
> Patch tested on i386 and x86-64 with patch that uses e820_update_range()
> to limit the E820 map when "mem" parameter is specified on the command line.
>
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/x86/kernel/e820.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index e285ea3..e466073 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -422,6 +422,7 @@ u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
>                final_end = min(start + size, ei->addr + ei->size);
>                if (final_start >= final_end)
>                        continue;
> +               ei->size -= final_end - final_start;
>                e820_add_region(final_start, final_end - final_start,
>                                         new_type);
>                real_updated_size += final_end - final_start;
> --

thanks for finding it, but fix is not complete. could have problem
with fore boundary overlapping. need to update the ei->addr

please check attached patch

YH

------=_Part_170_1251426.1214337455358
Content-Type: text/x-patch; name=e820_update_range_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhux4zh30
Content-Disposition: attachment; filename=e820_update_range_fix.patch

W1BBVENIXSB4ODY6IGZpeCBlODIwX3VwZGF0ZV9yYW5nZSBzaXplIHdoZW4gb3ZlcmxhcHBpbmcK
CmJlZm9yZSB0aGF0IHdlIHJlbGF5IG9uIHNhbml0aXplX2U4MjBfbWFwIHRvIHJlbW92ZSB0aGUg
b3ZlcmxhcC4KCmJ1dCBlODIwX3VwZGF0ZV9yYW5nZSgsLEU4MjBfUkVTRVJWRUQsIEU4MjBfUkFN
KSB3aWxsIG5vdCB3b3JrCgp0aGlzIHBhdGNoIGZpeCB0aGF0Cgp3aG8gaXMgZ29pbmcgdG8gdXNl
IHRoaXM/CgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+
CgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2U4MjAuYyBiL2FyY2gveDg2L2tlcm5lbC9l
ODIwLmMKaW5kZXggNTEyZjc3OS4uMTViNDM5MyAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVs
L2U4MjAuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCkBAIC00MjUsNiArNDI1LDExIEBA
IHU2NCBfX2luaXQgZTgyMF91cGRhdGVfcmFuZ2UodTY0IHN0YXJ0LCB1NjQgc2l6ZSwgdW5zaWdu
ZWQgb2xkX3R5cGUsCiAJCWU4MjBfYWRkX3JlZ2lvbihmaW5hbF9zdGFydCwgZmluYWxfZW5kIC0g
ZmluYWxfc3RhcnQsCiAJCQkJCSBuZXdfdHlwZSk7CiAJCXJlYWxfdXBkYXRlZF9zaXplICs9IGZp
bmFsX2VuZCAtIGZpbmFsX3N0YXJ0OworCisJCWVpLT5zaXplIC09IGZpbmFsX2VuZCAtIGZpbmFs
X3N0YXJ0OworCQlpZiAoZWktPmFkZHIgPCBmaW5hbF9zdGFydCkKKwkJCWNvbnRpbnVlOworCQll
aS0+YWRkciA9IGZpbmFsX2VuZDsKIAl9CiAJcmV0dXJuIHJlYWxfdXBkYXRlZF9zaXplOwogfQo=

------=_Part_170_1251426.1214337455358--
