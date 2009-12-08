Return-Path: <linux-kernel-owner+w=401wt.eu-S965991AbZLHULi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965991AbZLHULi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965977AbZLHULh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:11:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965975AbZLHULh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:11:37 -0500
Message-ID: <4B1EB2B0.4000204@zytor.com>
Date: Tue, 08 Dec 2009 12:10:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: tglx@linutronix.de, mingo@elte.hu, macro@linux-mips.org,
       yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86,apic: Use logical OR in noop-write operation
References: <20091208155316.561853924@openvz.org> <20091208155557.326359748@openvz.org>
In-Reply-To: <20091208155557.326359748@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2009 07:53 AM, Cyrill Gorcunov wrote:
> For apic noop'ified we have to use logical OR statement,
> otherwise any write on systems shipped with 82489DX
> (where apic presence bit can't be retrieved via cpuid)
> will not trigger the warning which is not desired.
> 
> In turn noop'ified read operation remains using logical
> AND statement. This will catch _only_ future code bugs
> since:
> 
> 1) The old 32bit systems without apic presence bit use
>    disable_apic only as a flag that chip was turned off
>    via boot option but not due to MP-table (BIOS) bug where
>    we may try to re-enable apic via MSR registers. The further
>    SMP setup code already prepared for a such situation
>    (ie it disables SMP support) and do not issue write
>    operations but still needs to issue apic_read. So instead
>    of deforming code with "if" we just allow reads until
>    SMP support gets disabled. But even then we still need
>    apic_read issued on a such machine at shutdown procedure.
> 
> 2) x86-64 at moment properly uses cpu_has_apic and turn
>    this feature off as only chip is disabled together
>    with disable_apic flag.
> 

Could you clarify the question I asked yesterday: how is the "or"
different from just warning unconditionally (which would at least be a
lot more clear)?  Can the situation that !cpu_has_apic && disable_apic
actually happen and we *still* end up in apic_write?

	-hpa
