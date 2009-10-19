Return-Path: <linux-kernel-owner+w=401wt.eu-S932148AbZJSPIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbZJSPIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZJSPIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:08:01 -0400
Received: from fmmailgate07.web.de ([217.72.192.248]:42640 "EHLO
	fmmailgate07.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZJSPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:08:00 -0400
Date: Mon, 19 Oct 2009 16:47:10 +0200
Message-Id: <1392884759@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Jan Beulich <JBeulich@novell.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, dri-devel@lists.sourceforge.net,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Thomas Hellstrom <thellstrom@vmware.com>, Tejun Heo <tj@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not__available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19ZlUd4Y/03uBjN7eVmh9lQeiPdX0M2co2aMLkt0XLynFxgi
 UwGbannFbSR1yIRmxm0SlZO2Cel47FPi8Bjanrktr2Ntf2EIoEajUwyHfUDd
 g==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> >>> Thomas Schlichter <thomas.schlichter@web.de> 17.10.09 21:48 >>>
> >What do you think about these patches?
> 
> Functionality-wise this looks fine to me; whether the core sysfs changes
> are acceptable I can't judge, though.

OK, who can? Or shall I simply ask get_maintainer.pl again?

> However, I would recommend folding the last two arguments of
> mtrr_add_unaligned(), i.e. use mtrr_usage != NULL as the increment
> argument passed to mtrr_add().

Good idea, I will do so this evening...

> And patches 5 and 6 would apparently not build right now, as they're
> failing to pass the new 5th argument to mtrr_add_unaligned().

*Grml* you are of course right. But I am not sure if these both patches
are a goot idea at all.

> Also, why do you add x86-specific code to drivers/pci-sysfs.c when the
> function called there (pci_mmap_page_range()) already is arch-specific?
> Moving your addition there would also allow covering the related
> (legacy?) procfs based functionality... pci_release() could also become
> arch-specific, with a fall-back definition to NULL.

You are right, I should do that...

> Additionally, I would suggest making those code portions depend on
> CONFIG_X86_MTRR rather than CONFIG_X86, so that you don't
> needlessly (try to) allocate the mtrr_usage vector.

Good idea, I will do so.

Thank you very much for your feedback, I'll hopefully come up with an
even better version tonight...

Kind regards,
  Thomas
