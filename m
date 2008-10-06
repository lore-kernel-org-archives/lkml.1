Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYJFMVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYJFMVC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYJFMUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:20:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:54844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYJFMUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nBeqTerFbtRICpC4EBanrlek1VwE/C0Tt7X3CepvWfv2eUqwt6iL3yBeeHk+6PZZU0
         /GXM+I/PnD5XzjG9ugyPWA0q8Kw4E0RqCs+vdnvKiHOwrGf1gtij9kYJYiCabfE5TKtl
         3JFVHsWovYHL4PMh0Gdis2ea1A3iUYVj4R/Ws=
Message-ID: <48EA02A1.9030800@gmail.com>
Date: Mon, 06 Oct 2008 14:20:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -tip] Fastboot: fix initcalls disposition in bootgraph.pl
References: <48E7C594.4030400@gmail.com>	 <20081004131901.66720416@infradead.org>	 <c62985530810041328i282818cak8cd0ba36c450e3d6@mail.gmail.com>	 <20081004133940.44feb2a0@infradead.org>	 <20081005095559.GE29909@elte.hu>	 <c62985530810050422m23d875b1s46ed19c8b65b96e4@mail.gmail.com>	 <20081006071209.GB23506@elte.hu> <c62985530810060213k189095e5xb791e98db45c370d@mail.gmail.com>
In-Reply-To: <c62985530810060213k189095e5xb791e98db45c370d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 2008/10/6 Ingo Molnar <mingo@elte.hu>:
>> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>>
>>> 2008/10/5 Ingo Molnar <mingo@elte.hu>:
>>>> Frédéric, is the revert still needed, or is latest tip/master OK ?
>>> Yes it should be reverted. Tracing is still stopped at the end of
>>> kernel_init().
>> lost track - exactly which commit ID should be reverted?
>>
>>        Ingo
>>
> 
> Hmm actually, the "stop_boot_trace" feature may be needed in  the
> future. If I trace the shed events too,
> I should be able to limit the tracing to avoid too much entries. I
> will see later.
> Perhaps just a patch to remove the trace stopping after builtin initcalls.
> I will submit it soon.
> 
> Sorry, just forget this revert request.
> 
> Thanks.
> 

From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -tip] Tracing/fastboot: Revert the stopping of the boot tracer

Since the patch that stopped the tracing after builtin-initcalls wasn't
a real solution of a bootgraph.pl's bug, we may continue to trace boot
after builtin initcalls. But we want to keep the stop_boot_trace function
for further uses.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/init/main.c b/init/main.c
index 6371981..f039e7a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -975,7 +975,6 @@ static int __init kernel_init(void * unused)
 	 * we're essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
 	 */
-	stop_boot_trace();
 	init_post();
 	return 0;
 }
