Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZIPI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZIPI6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbZIPI6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:58:35 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60821 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbZIPI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:58:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YoYaZ0D7KNIN0tVWAJZS+096pRdbuOYvi1fgFphJtxjz/nJTwlpkc9WG1WYQ8GG4Mt
         ozQr2B+KB/l9OTqm4dWCxqwv7um1BTCmZZrfET3K7yJHTRXdahmsIcUp4aola4rRpvOg
         lL54F8DtHxd7rePNhxcRCPNXeZ6giEAzOFkDw=
Date: Wed, 16 Sep 2009 12:58:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jun Nakajima <jun.nakajima@intel.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [RFC][PATCH 08/10] x86: Don't ack_APIC_irq() if lapic is
	disabled in GENERIC_INTERRUPT_VECTOR handler
Message-ID: <20090916085835.GE5094@lenovo>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com> <1253090551-7969-9-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253090551-7969-9-git-send-email-sheng@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sheng Yang - Wed, Sep 16, 2009 at 04:42:29PM +0800]
| Xen hybrid guest don't use lapic, but smp_generic_interrupt() assume all it's
| caller using lapic.
| 
| Signed-off-by: Sheng Yang <sheng@linux.intel.com>
| ---
|  arch/x86/kernel/irq.c |    3 ++-
|  1 files changed, 2 insertions(+), 1 deletions(-)
| 
| diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
| index c3fe010..a887d25 100644
| --- a/arch/x86/kernel/irq.c
| +++ b/arch/x86/kernel/irq.c
| @@ -236,7 +236,8 @@ void smp_generic_interrupt(struct pt_regs *regs)
|  {
|  	struct pt_regs *old_regs = set_irq_regs(regs);
|  
| -	ack_APIC_irq();
| +	if (!disable_apic)
| +		ack_APIC_irq();
|  
|  	exit_idle();

Hi Sheng,

is there was some problem with it? I'm asking you
because if disable_apic=1 then any apic write/read
operations become NOPs. So I don't see how it may
hurt. But I could be missing something.
 
	-- Cyrill
