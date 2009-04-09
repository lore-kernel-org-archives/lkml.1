Return-Path: <linux-kernel-owner+w=401wt.eu-S936446AbZDIUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936446AbZDIUAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbZDIUAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:00:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:60003 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZDIUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=f62eq4lDgzlVPYz1RkPSA/qc/GrCzDAyY4cRspn73B5yWOq6tO1DjCpvghWi+Xi4ag
         1mdZ9HsxupADhn8RTKzahIhhHyLaRkDYihVDl+mrUkT+lWoxphLZZswoK6vMon+0D2bK
         /ijXja5T5z1n8pB2g19FXBYR5hhMkrKgtDmuU=
Date: Fri, 10 Apr 2009 00:00:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86,apic: Checking kernel option before
	detect_init_APIC()
Message-ID: <20090409200011.GD7558@lenovo>
References: <b9df5fa10903271825g62b95e62p6e7006f0594e2c4b@mail.gmail.com> <20090408145041.GL12931@elte.hu> <b9df5fa10904082208x69dc3b2ex46b8edac7d8cee81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9df5fa10904082208x69dc3b2ex46b8edac7d8cee81@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rakib Mullick - Thu, Apr 09, 2009 at 11:08:43AM +0600]
| On Wed, Apr 8, 2009 at 8:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
| >
| > * Rakib Mullick <rakib.mullick@gmail.com> wrote:
| >
| > Hm, are you sure this is a cleanup only? (i.e. no side-effects)
| My quick review over code, i don't think there's any.Unless I'm not
| missing anything. Kernel option has been passed when before kernel
| starts, so I think it's safe.

Hi Rakib,

yes, disable_apic early parameter handled earlier then
init_apic_mappings is being called but we could reach
disable_apic=1 with not only as kernel option but as
result of acpi_mps_check for example (which
is called earlier then init_apic_mappings though).
So this snippet is safe I believe.

| >
| > Also, even if it's a pure cleanup, wouldnt it be even cleaner to
| > propagate this check into detect_init_APIC() - and thus get rid of
| > the open-coded disable_apic check altogether?

In point! We do same fasion check in APIC_init_uniprocessor

| Yes, could be. How we'll understand that whether apic has been
| disabled from kernel option or not (if we requires later on)?

AFAIS, as only we set disable_apic=1 from kernel option (or other
ways) we clear X86_FEATURE_APIC likewise. So I don't see easy way
to distinguish the reason why apic is disabled. But to be precise
APIC_init_uniprocessor print us some info.

So I'm for Ingo's idea!

| 
| Rakib
| >
| >        Ingo
| >
| 
        Cyrill
