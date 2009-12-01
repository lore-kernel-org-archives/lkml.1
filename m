Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbZLAEaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbZLAEaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZLAEaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:30:12 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:45093 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZLAEaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:30:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=atqIFpuBP4DNo8rRSsPAGRcFuZuAwgLkWmCcBXMigAI0UW4TTYuzx4JchFytMJkSCw
         rzyPtiLvvSlOg7fUlfG4PgUFx48OHlrQ5RtSzDolyTA0ou86S31Uh0E3TabtaXBeloZC
         byp9CXGuhO9MEOLPxudH/zjt54RLa1PrRm24s=
MIME-Version: 1.0
In-Reply-To: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
Date: Mon, 30 Nov 2009 23:30:16 -0500
Message-ID: <b4198de60911302030v504abfb3g805da2d0b9b7ffac@mail.gmail.com>
Subject: Re: [PATCH] [alpha] Add minimal support for software performance 
	events.
From: Matt Turner <mattst88@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: multipart/mixed; boundary=000e0cd59fc6feb61d0479a336d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd59fc6feb61d0479a336d7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2009 at 3:32 AM, Michael Cree <mcree@orcon.net.nz> wrote:
> In the kernel the patch enables configuration of the perf event
> option, adds the perf_event_open syscall, and includes a minimal
> architecture specific asm/perf_event.h header file.
>
> For the perf tool the patch implements an Alpha specific section
> in the perf.h header file and adjusts options used in the
> Makefile to allow compilation on Alpha. =A0The -Wcast-align gives
> a "cast increases required alignment of target type" warning for
> the list_for_each_entry() macro. The -fstack-protector-all
> option generates a "not supported for this target" warning which
> with -Werror causes the compiler to abort.
>
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
> =A0arch/alpha/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
> =A0arch/alpha/include/asm/perf_event.h | =A0 =A09 +++++++++
> =A0arch/alpha/include/asm/unistd.h =A0 =A0 | =A0 =A03 ++-
> =A0arch/alpha/kernel/systbls.S =A0 =A0 =A0 =A0 | =A0 =A01 +
> =A0tools/perf/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A05 ++---
> =A0tools/perf/perf.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A06 +++++=
+
> =A06 files changed, 21 insertions(+), 4 deletions(-)
> =A0create mode 100644 arch/alpha/include/asm/perf_event.h
>
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index 4434481..bd7261e 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -9,6 +9,7 @@ config ALPHA
> =A0 =A0 =A0 =A0select HAVE_IDE
> =A0 =A0 =A0 =A0select HAVE_OPROFILE
> =A0 =A0 =A0 =A0select HAVE_SYSCALL_WRAPPERS
> + =A0 =A0 =A0 select HAVE_PERF_EVENTS
> =A0 =A0 =A0 =A0help
> =A0 =A0 =A0 =A0 =A0The Alpha is a 64-bit general-purpose processor design=
ed and
> =A0 =A0 =A0 =A0 =A0marketed by the Digital Equipment Corporation of bless=
ed memory,
> diff --git a/arch/alpha/include/asm/perf_event.h b/arch/alpha/include/asm=
/perf_event.h
> new file mode 100644
> index 0000000..3bef852
> --- /dev/null
> +++ b/arch/alpha/include/asm/perf_event.h
> @@ -0,0 +1,9 @@
> +#ifndef __ASM_ALPHA_PERF_EVENT_H
> +#define __ASM_ALPHA_PERF_EVENT_H
> +
> +/* Alpha only supports software events through this interface. */
> +static inline void set_perf_event_pending(void) { }
> +
> +#define PERF_EVENT_INDEX_OFFSET 0
> +
> +#endif /* __ASM_ALPHA_PERF_EVENT_H */
> diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/uni=
std.h
> index 17f72b7..414de17 100644
> --- a/arch/alpha/include/asm/unistd.h
> +++ b/arch/alpha/include/asm/unistd.h
> @@ -447,10 +447,11 @@
> =A0#define __NR_preadv =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0489
> =A0#define __NR_pwritev =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 490
> =A0#define __NR_rt_tgsigqueueinfo =A0 =A0 =A0 =A0 491
> +#define __NR_perf_event_open =A0 =A0 =A0 =A0 =A0 492
>
> =A0#ifdef __KERNEL__
>
> -#define NR_SYSCALLS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0492
> +#define NR_SYSCALLS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0493
>
> =A0#define __ARCH_WANT_IPC_PARSE_VERSION
> =A0#define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
> index 78199b9..63c78e4 100644
> --- a/arch/alpha/kernel/systbls.S
> +++ b/arch/alpha/kernel/systbls.S
> @@ -510,6 +510,7 @@ sys_call_table:
> =A0 =A0 =A0 =A0.quad sys_preadv
> =A0 =A0 =A0 =A0.quad sys_pwritev =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 /* 490 */
> =A0 =A0 =A0 =A0.quad sys_rt_tgsigqueueinfo
> + =A0 =A0 =A0 .quad sys_perf_event_open
>
> =A0 =A0 =A0 =A0.size sys_call_table, . - sys_call_table
> =A0 =A0 =A0 =A0.type sys_call_table, @object
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 742a32e..7940d66 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -177,8 +177,7 @@ endif
> =A0# Include saner warnings here, which can catch bugs:
> =A0#
>
> -EXTRA_WARNINGS :=3D -Wcast-align
> -EXTRA_WARNINGS :=3D $(EXTRA_WARNINGS) -Wformat
> +EXTRA_WARNINGS :=3D -Wformat
> =A0EXTRA_WARNINGS :=3D $(EXTRA_WARNINGS) -Wformat-security
> =A0EXTRA_WARNINGS :=3D $(EXTRA_WARNINGS) -Wformat-y2k
> =A0EXTRA_WARNINGS :=3D $(EXTRA_WARNINGS) -Wshadow
> @@ -201,7 +200,7 @@ EXTRA_WARNINGS :=3D $(EXTRA_WARNINGS) -Wold-style-def=
inition
> =A0EXTRA_WARNINGS :=3D $(EXTRA_WARNINGS) -Wstrict-prototypes
> =A0EXTRA_WARNINGS :=3D $(EXTRA_WARNINGS) -Wdeclaration-after-statement
>
> -CFLAGS =3D $(MBITS) -ggdb3 -Wall -Wextra -std=3Dgnu99 -Werror -O6 -fstac=
k-protector-all -D_FORTIFY_SOURCE=3D2 $(EXTRA_WARNINGS)
> +CFLAGS =3D $(MBITS) -ggdb3 -Wall -Wextra -std=3Dgnu99 -Werror -O6 -D_FOR=
TIFY_SOURCE=3D2 $(EXTRA_WARNINGS)
> =A0LDFLAGS =3D -lpthread -lrt -lelf -lm
> =A0ALL_CFLAGS =3D $(CFLAGS)
> =A0ALL_LDFLAGS =3D $(LDFLAGS)
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 8cc4623..216bdb2 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -47,6 +47,12 @@
> =A0#define cpu_relax() =A0 =A0asm volatile("":::"memory")
> =A0#endif
>
> +#ifdef __alpha__
> +#include "../../arch/alpha/include/asm/unistd.h"
> +#define rmb() =A0 =A0 =A0 =A0 =A0asm volatile("mb" ::: "memory")
> +#define cpu_relax() =A0 =A0asm volatile("" ::: "memory")
> +#endif
> +
> =A0#include <time.h>
> =A0#include <unistd.h>
> =A0#include <sys/types.h>
> --
> 1.6.3.3
>
> --

Please take a look at the attached patch and let me know if it's what
you want pushed. I wasn't sure if the last hunk (the memory barriers)
needed to be included or had already been picked up.

Thanks,
Matt

--000e0cd59fc6feb61d0479a336d7
Content-Type: application/octet-stream; 
	name="0001-alpha-Add-minimal-support-for-software-performance-e.patch"
Content-Disposition: attachment; 
	filename="0001-alpha-Add-minimal-support-for-software-performance-e.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g2o668030

RnJvbSBjYjU4ZTZkMzdiNDA2Y2RiMTU0YjM0ZDcwMGM5NDc4NTQ2YjFlODRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWNoYWVsIENyZWUgPG1jcmVlQG9yY29uLm5ldC5uej4KRGF0
ZTogTW9uLCAzMCBOb3YgMjAwOSAyMzoyNzozNiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGFscGhh
OiBBZGQgbWluaW1hbCBzdXBwb3J0IGZvciBzb2Z0d2FyZSBwZXJmb3JtYW5jZSBldmVudHMuCgpJ
biB0aGUga2VybmVsIHRoZSBwYXRjaCBlbmFibGVzIGNvbmZpZ3VyYXRpb24gb2YgdGhlIHBlcmYg
ZXZlbnQKb3B0aW9uLCBhZGRzIHRoZSBwZXJmX2V2ZW50X29wZW4gc3lzY2FsbCwgYW5kIGluY2x1
ZGVzIGEgbWluaW1hbAphcmNoaXRlY3R1cmUgc3BlY2lmaWMgYXNtL3BlcmZfZXZlbnQuaCBoZWFk
ZXIgZmlsZS4KCkZvciB0aGUgcGVyZiB0b29sIHRoZSBwYXRjaCBpbXBsZW1lbnRzIGFuIEFscGhh
IHNwZWNpZmljIHNlY3Rpb24KaW4gdGhlIHBlcmYuaCBoZWFkZXIgZmlsZSBhbmQgYWRqdXN0cyBv
cHRpb25zIHVzZWQgaW4gdGhlCk1ha2VmaWxlIHRvIGFsbG93IGNvbXBpbGF0aW9uIG9uIEFscGhh
LiAgVGhlIC1XY2FzdC1hbGlnbiBnaXZlcwphICJjYXN0IGluY3JlYXNlcyByZXF1aXJlZCBhbGln
bm1lbnQgb2YgdGFyZ2V0IHR5cGUiIHdhcm5pbmcgZm9yCnRoZSBsaXN0X2Zvcl9lYWNoX2VudHJ5
KCkgbWFjcm8uIFRoZSAtZnN0YWNrLXByb3RlY3Rvci1hbGwKb3B0aW9uIGdlbmVyYXRlcyBhICJu
b3Qgc3VwcG9ydGVkIGZvciB0aGlzIHRhcmdldCIgd2FybmluZyB3aGljaAp3aXRoIC1XZXJyb3Ig
Y2F1c2VzIHRoZSBjb21waWxlciB0byBhYm9ydC4KClNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgQ3Jl
ZSA8bWNyZWVAb3Jjb24ubmV0Lm56PgpDYzogUmljaGFyZCBIZW5kZXJzb24gPHJ0aEB0d2lkZGxl
Lm5ldD4KQ2M6IEl2YW4gS29rc2hheXNreSA8aW5rQGp1cmFzc2ljLnBhcmsubXN1LnJ1PgpDYzog
UGV0ZXIgWmlqbHN0cmEgPGEucC56aWpsc3RyYUBjaGVsbG8ubmw+CkNjOiBQYXVsIE1hY2tlcnJh
cyA8cGF1bHVzQHNhbWJhLm9yZz4KQ2M6IEluZ28gTW9sbmFyIDxtaW5nb0BlbHRlLmh1PgpTaWdu
ZWQtb2ZmLWJ5OiBNYXR0IFR1cm5lciA8bWF0dHN0ODhAZ21haWwuY29tPgotLS0KIGFyY2gvYWxw
aGEvS2NvbmZpZyAgICAgICAgICAgICAgICAgIHwgICAgMSArCiBhcmNoL2FscGhhL2luY2x1ZGUv
YXNtL3BlcmZfZXZlbnQuaCB8ICAgIDkgKysrKysrKysrCiBhcmNoL2FscGhhL2luY2x1ZGUvYXNt
L3VuaXN0ZC5oICAgICB8ICAgIDMgKystCiBhcmNoL2FscGhhL2tlcm5lbC9zeXN0YmxzLlMgICAg
ICAgICB8ICAgIDEgKwogdG9vbHMvcGVyZi9wZXJmLmggICAgICAgICAgICAgICAgICAgfCAgICA2
ICsrKysrKwogNSBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygt
KQogY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvYWxwaGEvaW5jbHVkZS9hc20vcGVyZl9ldmVudC5o
CgpkaWZmIC0tZ2l0IGEvYXJjaC9hbHBoYS9LY29uZmlnIGIvYXJjaC9hbHBoYS9LY29uZmlnCmlu
ZGV4IDQ0MzQ0ODEuLmJkNzI2MWUgMTAwNjQ0Ci0tLSBhL2FyY2gvYWxwaGEvS2NvbmZpZworKysg
Yi9hcmNoL2FscGhhL0tjb25maWcKQEAgLTksNiArOSw3IEBAIGNvbmZpZyBBTFBIQQogCXNlbGVj
dCBIQVZFX0lERQogCXNlbGVjdCBIQVZFX09QUk9GSUxFCiAJc2VsZWN0IEhBVkVfU1lTQ0FMTF9X
UkFQUEVSUworCXNlbGVjdCBIQVZFX1BFUkZfRVZFTlRTCiAJaGVscAogCSAgVGhlIEFscGhhIGlz
IGEgNjQtYml0IGdlbmVyYWwtcHVycG9zZSBwcm9jZXNzb3IgZGVzaWduZWQgYW5kCiAJICBtYXJr
ZXRlZCBieSB0aGUgRGlnaXRhbCBFcXVpcG1lbnQgQ29ycG9yYXRpb24gb2YgYmxlc3NlZCBtZW1v
cnksCmRpZmYgLS1naXQgYS9hcmNoL2FscGhhL2luY2x1ZGUvYXNtL3BlcmZfZXZlbnQuaCBiL2Fy
Y2gvYWxwaGEvaW5jbHVkZS9hc20vcGVyZl9ldmVudC5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0Cmlu
ZGV4IDAwMDAwMDAuLjNiZWY4NTIKLS0tIC9kZXYvbnVsbAorKysgYi9hcmNoL2FscGhhL2luY2x1
ZGUvYXNtL3BlcmZfZXZlbnQuaApAQCAtMCwwICsxLDkgQEAKKyNpZm5kZWYgX19BU01fQUxQSEFf
UEVSRl9FVkVOVF9ICisjZGVmaW5lIF9fQVNNX0FMUEhBX1BFUkZfRVZFTlRfSAorCisvKiBBbHBo
YSBvbmx5IHN1cHBvcnRzIHNvZnR3YXJlIGV2ZW50cyB0aHJvdWdoIHRoaXMgaW50ZXJmYWNlLiAq
Lworc3RhdGljIGlubGluZSB2b2lkIHNldF9wZXJmX2V2ZW50X3BlbmRpbmcodm9pZCkgeyB9CisK
KyNkZWZpbmUgUEVSRl9FVkVOVF9JTkRFWF9PRkZTRVQgMAorCisjZW5kaWYgLyogX19BU01fQUxQ
SEFfUEVSRl9FVkVOVF9IICovCmRpZmYgLS1naXQgYS9hcmNoL2FscGhhL2luY2x1ZGUvYXNtL3Vu
aXN0ZC5oIGIvYXJjaC9hbHBoYS9pbmNsdWRlL2FzbS91bmlzdGQuaAppbmRleCAxN2Y3MmI3Li40
MTRkZTE3IDEwMDY0NAotLS0gYS9hcmNoL2FscGhhL2luY2x1ZGUvYXNtL3VuaXN0ZC5oCisrKyBi
L2FyY2gvYWxwaGEvaW5jbHVkZS9hc20vdW5pc3RkLmgKQEAgLTQ0NywxMCArNDQ3LDExIEBACiAj
ZGVmaW5lIF9fTlJfcHJlYWR2CQkJNDg5CiAjZGVmaW5lIF9fTlJfcHdyaXRldgkJCTQ5MAogI2Rl
ZmluZSBfX05SX3J0X3Rnc2lncXVldWVpbmZvCQk0OTEKKyNkZWZpbmUgX19OUl9wZXJmX2V2ZW50
X29wZW4JCTQ5MgogCiAjaWZkZWYgX19LRVJORUxfXwogCi0jZGVmaW5lIE5SX1NZU0NBTExTCQkJ
NDkyCisjZGVmaW5lIE5SX1NZU0NBTExTCQkJNDkzCiAKICNkZWZpbmUgX19BUkNIX1dBTlRfSVBD
X1BBUlNFX1ZFUlNJT04KICNkZWZpbmUgX19BUkNIX1dBTlRfT0xEX1JFQURESVIKZGlmZiAtLWdp
dCBhL2FyY2gvYWxwaGEva2VybmVsL3N5c3RibHMuUyBiL2FyY2gvYWxwaGEva2VybmVsL3N5c3Ri
bHMuUwppbmRleCA3ODE5OWI5Li42M2M3OGU0IDEwMDY0NAotLS0gYS9hcmNoL2FscGhhL2tlcm5l
bC9zeXN0YmxzLlMKKysrIGIvYXJjaC9hbHBoYS9rZXJuZWwvc3lzdGJscy5TCkBAIC01MTAsNiAr
NTEwLDcgQEAgc3lzX2NhbGxfdGFibGU6CiAJLnF1YWQgc3lzX3ByZWFkdgogCS5xdWFkIHN5c19w
d3JpdGV2CQkJLyogNDkwICovCiAJLnF1YWQgc3lzX3J0X3Rnc2lncXVldWVpbmZvCisJLnF1YWQg
c3lzX3BlcmZfZXZlbnRfb3BlbgogCiAJLnNpemUgc3lzX2NhbGxfdGFibGUsIC4gLSBzeXNfY2Fs
bF90YWJsZQogCS50eXBlIHN5c19jYWxsX3RhYmxlLCBAb2JqZWN0CmRpZmYgLS1naXQgYS90b29s
cy9wZXJmL3BlcmYuaCBiL3Rvb2xzL3BlcmYvcGVyZi5oCmluZGV4IDhjYzQ2MjMuLjIxNmJkYjIg
MTAwNjQ0Ci0tLSBhL3Rvb2xzL3BlcmYvcGVyZi5oCisrKyBiL3Rvb2xzL3BlcmYvcGVyZi5oCkBA
IC00Nyw2ICs0NywxMiBAQAogI2RlZmluZSBjcHVfcmVsYXgoKQlhc20gdm9sYXRpbGUoIiI6Ojoi
bWVtb3J5IikKICNlbmRpZgogCisjaWZkZWYgX19hbHBoYV9fCisjaW5jbHVkZSAiLi4vLi4vYXJj
aC9hbHBoYS9pbmNsdWRlL2FzbS91bmlzdGQuaCIKKyNkZWZpbmUgcm1iKCkJCWFzbSB2b2xhdGls
ZSgibWIiIDo6OiAibWVtb3J5IikKKyNkZWZpbmUgY3B1X3JlbGF4KCkJYXNtIHZvbGF0aWxlKCIi
IDo6OiAibWVtb3J5IikKKyNlbmRpZgorCiAjaW5jbHVkZSA8dGltZS5oPgogI2luY2x1ZGUgPHVu
aXN0ZC5oPgogI2luY2x1ZGUgPHN5cy90eXBlcy5oPgotLSAKMS42LjQuNAoK
--000e0cd59fc6feb61d0479a336d7--
