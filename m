Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZELR1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZELR1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZELR1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:27:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:16720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZELR1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XErzuoHWnvhLUIyDcHOpU2dlRij/m98curzUTtlWRYwpKCIVVOMTC22yXcfdRIuL5u
         jFTvsMpzeQMmLMIqbYcStyE6M1z8nbJ0KgrqRHuNG9Ls3si7+HB0ba6q/a6874eZLDGO
         MQHqPof36+xT8X5CMjoNUu+fAQMptpx4yAaWE=
Date: Tue, 12 May 2009 21:27:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090512172710.GD12820@lenovo>
References: <49FC85A9.2070702@kernel.org> <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org> <20090512150631.GA32067@elte.hu> <20090512164617.GA21673@elte.hu> <20090512170246.GB12820@lenovo> <4A09ADE5.3010102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A09ADE5.3010102@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Tue, May 12, 2009 at 10:12:05AM -0700]
| Cyrill Gorcunov wrote:
| > [Ingo Molnar - Tue, May 12, 2009 at 06:46:17PM +0200]
| > | 
| > | got this on a testbox:
| > | 
| > | [    0.113333] WARNING: at arch/x86/kernel/apic/apic.c:253 warn_slowpath_null+0x28/0x50()
| > | 
| > | 	Ingo
| > |
| > 
| > It's expected (unfortunately). If we have SMP compiled kernel
| > we still rely on apic_read heavily. Since for fake'ed apic
| > we just return 0 for any reading I suspect we could just drop
| > WARN_ON_ONCE for native_apic_read_dummy. Yinghai?
| > 
| > (well, actually we should clean up callees but it would require
| >  some effort)
| 
| 32bit seems doesn't have this warning.
| 
| and on 64bit, we always assumed have local APIC there. so could be that
| noapic is not cleanly enforced
|

yes, that is why I said that we need to cleanup the call-pathes.
And since it requires some effort we either could save WARN_ON_ONCE
here (so it hit us everyday provoking to do cleanup) and keep
in mind that it's expected behaviour at moment, or if it's that
annoying -- remove it (though it would be just a hidding of code
defect I think). Unfortunatelly I have a number of tasks to be done
before I could start such a checking/cleanups.

| 
| YH
| 
	-- Cyrill
