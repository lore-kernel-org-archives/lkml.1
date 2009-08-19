Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbZHSQPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbZHSQPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZHSQPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:15:05 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53083 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZHSQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ui5Dg3PJtJlFlEGczl/9GthnNQofpUomO0Cy1z9c3Z2+wNebCC7LrqXXYfVvlBHYho
         a5Hki8cK8rjxTdXiA7rx7T7jgt+h/7tJ67bRktoG5ClK3s6jXO1oR0z19fPwZoN2kWYf
         yCK6IUKryTKbYYs73IVDL/0/VD5vsqlD2CkTc=
Date: Wed, 19 Aug 2009 20:15:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic: set cpu_has_apic manually for discrete
	apic
Message-ID: <20090819161500.GA5457@lenovo>
References: <20090816195736.GB4788@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816195736.GB4788@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Aug 16, 2009 at 11:57:36PM +0400]
|
| In case of discrete apic (due to hardware or firmware reason)
| cpuid may not retrieve cpu_has_apic bit. But we rely on this
| bit in SMP compiled kernels. So instead of long condition checking
| we set cpu_has_apic bit manually and check it only in further
| code flow.
| 
| Note that the case is applied to x86-32 pretty old machines only.
| Also verify_local_APIC is the only place where such a trick
| could be done. We can't do it earlier since there could be
| a BIOS bug and other checks which we are to pass to ensure
| that APIC is functional.
| 
| The patch also make lapic_shutdown, disable_IO_APIC callable
| which should take place even on discrete apics.
| 
| As a side effect it makes lapic sysfs device available
| for such machines so lets check for apic being integrated
| since we don't support suspend/resume for disrete apics.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| ---

Please drop this RFC now as to eliminate side effects
a number of quirks (MCE,MSI) would be needed. I didn't trigger
problems because not all interrupt types were covered
with qemu. The simpliest (and more safe) approach will
be just to fix lapic_shutdown and disable_IO_APIC for
discrete apic case. Will cook a patch.

	-- Cyrill
