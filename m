Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbYCRH5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbYCRH5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYCRH5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:57:03 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:5066 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYCRH5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h98CTUUgNBPqimdAe+7MmSekLSxw0iF8bCUp4miBBS8mc/yYvA/BC5aMFrnuY9TbIg4w6XvKF1gZNHu3B3wK9/v48++Fz1x3kZ+b4/Vbb2zk8GqiAoGMWfSreSsCucHAJ5+0OUD+XBcaOrCNx9dPTiauJcLcGttsTUh5ns8sS1Q=
Message-ID: <86802c440803180056i4d3a7029n6f4d07f3ca5763ee@mail.gmail.com>
Date: Tue, 18 Mar 2008 00:56:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran Thirumalai" <kiran@scalemp.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: + x86-vsmp-build-fixes.patch added to -mm tree
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       gcosta@redhat.com, mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <20080318072802.GH6091@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803180514.m2I5ElVJ015693@imap1.linux-foundation.org>
	 <86802c440803172226yb867326rb595b36b03e6c4b9@mail.gmail.com>
	 <20080318072802.GH6091@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 12:28 AM, Ravikiran Thirumalai
<kiran@scalemp.com> wrote:
> On Mon, Mar 17, 2008 at 10:26:55PM -0700, Yinghai Lu wrote:
>  >On Mon, Mar 17, 2008 at 10:14 PM,  <akpm@linux-foundation.org> wrote:
>  >> ...
>
> >>  Subject: x86: vsmp build fixes
>  >>  From: Glauber Costa <gcosta@redhat.com>
>  >>
>  >>  VSMP depends on PCI, but the file is now compiled conditionally on PARAVIRT,
>  >>  no VSMP, so enclose everything in an ifdef CONFIG_PCI.
>
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  ...
>
> >
>  >in arch/x86/Kconfig
>  >
>  >config PCI
>  >        bool "PCI support" if !X86_VISWS && !X86_VSMP
>  >        depends on !X86_VOYAGER
>  >        default y
>  >        select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
>  >        help
>  >          Find out whether you have a PCI motherboard. PCI is the name of a
>  >          bus system, i.e. the way the CPU talks to the other stuff inside
>  >          your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
>  >          VESA. If you have PCI, say Y, otherwise N.
>  >
>  >will make sure if X86_VSMP, the PCI=y
>  >
>  >so NAK this patch.
>  >
>
>  Not really, as you can tell from the description Glauber provided above.

oh, you mean PARAVIRT is defined, but VSMP is not used ?

then that patch is OK, but it is some ugly... or you can split that file?

>
>  Btw, I had something similar to this cooking for the build breakage, along
>  with a few more updates (is_vsmp_box() is broken on vsmp).  Thanks Glauber
>  for this patch.
>
that is funny, i just extracted is_vsmp_box from vsmp_init...

YH
