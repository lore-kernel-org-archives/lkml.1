Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918Ab0AVQXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0AVQXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414Ab0AVQXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:23:11 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:50791 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0AVQXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:23:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qAkb5XyRndOZuqJA/szEtCLi1X0B86u2MRsOpfuSjk/R78WGm1YGLDmry5Za3CxvV8
         4wL4K5cogIcb+LGAZMUebkxJ0qYDqWANgPcdtaYpmzmwOnJpzG8ocp6XKl0AsgPPjQ56
         pE8iZIQD1waADKl154S+viNw1TicDg/xpk6/k=
MIME-Version: 1.0
In-Reply-To: <20100121222627.GA22897@basil.fritz.box>
References: <20100121222627.GA22897@basil.fritz.box>
Date: Fri, 22 Jan 2010 11:23:08 -0500
Message-ID: <5e61b72f1001220823i364a7a40l21a46e0f127341fb@mail.gmail.com>
Subject: Re: [PATCH] Add Xeon 7500 series support to oprofile
From: John Villalovos <sodarock@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, robert.richter@amd.com,
       oprofile-list@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 5:26 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Add Xeon 7500 series support to oprofile
>
> Straight forward: it's the same as Core i7, so just detect
> the model number. No user space changes needed.
>
> Very simple patch, so it could be still merged for .33?
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  arch/x86/oprofile/nmi_int.c |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: linux/arch/x86/oprofile/nmi_int.c
> ===================================================================
> --- linux.orig/arch/x86/oprofile/nmi_int.c
> +++ linux/arch/x86/oprofile/nmi_int.c
> @@ -598,6 +598,7 @@ static int __init ppro_init(char **cpu_t
>        case 15: case 23:
>                *cpu_type = "i386/core_2";
>                break;
> +       case 0x2e:
>        case 26:
>                spec = &op_arch_perfmon_spec;
>                *cpu_type = "i386/core_i7";

How about: this instead?

Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cb88b1a..edc074c 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -598,7 +598,7 @@ static int __init ppro_init(char **cpu_type)
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
-	case 26:
+	case 26: case 46:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;
