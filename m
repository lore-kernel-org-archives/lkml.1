Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576Ab0AaBmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0AaBmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 20:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494Ab0AaBmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 20:42:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34910 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab0AaBmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 20:42:43 -0500
Message-ID: <4B64E000.3020608@zytor.com>
Date: Sat, 30 Jan 2010 17:42:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: enlightenment for ticket spinlocks
References: <4B62A39D020000780002CA80@vpn.id2.novell.com>
In-Reply-To: <4B62A39D020000780002CA80@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 12:00 AM, Jan Beulich wrote:
> With the pv-ops based spinlocks reportedly having measurable overhead
> on native execution, and with them also not easily fit (at least) fully
> virtualized Xen guests, this patch series introduces a replacement
> mechanism based on alternative instruction patching, and then uses it
> for fully virtualized Xen guests. While coded to be orthogonal to
> pv-ops, it really isn't, and it shouldn't be difficult to make pv-ops guests
> use this in place of pv-ops spin locks.
> 
> The only additional overhead this introduces for native execution is
> the writing of the owning CPU in the lock acquire paths. If this is
> considered a problem, even that code could be eliminated for native
> execution (by further alternative instruction patching).
> 
> (1) base implementation
> (2) Xen implementation
> (3) [optional] eliminate on NOPs in unlock path (introduced in (1))
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

+ * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
+ *      of a Xen host.
+ */
+#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
+#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
+#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */

I hope you know this spells "MMXenVMMXenV".  The ordering is ecx-edx-ebx
(register numbers 1, 2, 3).

[Still working through the actual contents of the patchset... just a
nitpick.]

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

