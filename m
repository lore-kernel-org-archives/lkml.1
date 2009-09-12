Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZILSF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZILSF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 14:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZILSF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 14:05:27 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:44682 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZILSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 14:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wSLxSdoOAipL9Bg5DRslC7HZR849Mbrx2tcEeygdNJ6gXq/nYaWbZR31YsdlKOq8jL
         B+P3MK8MIDtmBjj9Ow02BMZer/Z7BjJPOgNzskggXifD2ON8wJE035eSmgnblURDM3Q2
         3N3R0sP0p+J9OxhVjl1HG9YAe5qnK9d0mg71Q=
Date: Sat, 12 Sep 2009 22:05:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ingo Molnar <mingo@elte.hu>, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: apic: convert BUG() to BUG_ON()
Message-ID: <20090912180527.GA4893@lenovo>
References: <1252777220-30796-1-git-send-email-dwalker@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252777220-30796-1-git-send-email-dwalker@fifo99.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Daniel Walker - Sat, Sep 12, 2009 at 10:40:20AM -0700]
| This was done using Coccinelle's BUG_ON semantic patch.
| 
| Signed-off-by: Daniel Walker <dwalker@fifo99.com>
| ---
|  arch/x86/kernel/apic/apic.c |    3 +--
|  1 files changed, 1 insertions(+), 2 deletions(-)
| 
| diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
| index a34601f..e3d467e 100644
| --- a/arch/x86/kernel/apic/apic.c
| +++ b/arch/x86/kernel/apic/apic.c
| @@ -1197,8 +1197,7 @@ void __cpuinit setup_local_APIC(void)
|  	 * Double-check whether this APIC is really registered.
|  	 * This is meaningless in clustered apic mode, so we skip it.
|  	 */
| -	if (!apic->apic_id_registered())
| -		BUG();
| +	BUG_ON(!apic->apic_id_registered());
|  
|  	/*
|  	 * Intel recommends to set DFR, LDR and TPR before enabling
| -- 
| 1.5.6.3
| 

Hi Daniel,

I believe having a changelog like

	Use short form of "if() BUG()" sequence

would be better perhaps? Since "Coccinelle's BUG_ON semantic patch"
somehow doesn't describe why it's done.

Don't get me wrong please. It's trivial and seen from patch
itself _why_ it's done though changelog doesn't say the same.

Perhaps I'm too nagging :) Feel free to ignore me.

	-- Cyrill
