Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYIKMxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYIKMxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYIKMxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:53:07 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:16027 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYIKMxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=H1ileSIfGhpigDJ5umGwcDtEVSM6NFu7v9SHSI1ezaAgJctAau3Mho9t91zaAn+nnu
         ozHdX5ieXmR2VDBsRihGKIlDH+8t0fGBqe5aPGKqtkLwT38ZYlkzGPDqytGRha6LmOzW
         llw8FKq8ZfOFugY11dbTgMdjuMX7tRq0AXX4g=
Message-ID: <48C91458.7090503@gmail.com>
Date: Thu, 11 Sep 2008 14:51:36 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>	<48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local>	<48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local>	<48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local>	<48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local>	<48C7DC55.30002@gmail.com> <8763p3ol55.fsf@denkblock.local>	<48C82CB1.2070308@gmail.com> <871vzrogpz.fsf@denkblock.local>	<48C850AA.2030409@gmail.com> <87k5diq35g.fsf@denkblock.local>
In-Reply-To: <87k5diq35g.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> We mustn't release the lock between pulling the actions into eh_context
> and clearing eh_info, so I've designed ata_eh_pull_action() to be used
> instead of ata_eh_about_to_do().

Yes, right again.  :-)

> What about the following patch? Also, I've slipped in a minor comment
> fix to ata_eh_done() which probably doesn't warrant a separate patch; on
> the other hand, mixing things like that isn't quite the right thing
> either, so, perhaps I should drop it in the final version?

Hmmm... I think either way is okay but there's no harm in splitting
them.

> From: Elias Oltmanns <eo@nebensachen.de>
> Subject: [PATCH] libata: Implement disk shock protection support
> 
> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> FEATURE as specified in ATA-7 is issued to the device and processing of
> the request queue is stopped thereafter until the specified timeout
> expires or user space asks to resume normal operation. This is supposed
> to prevent the heads of a hard drive from accidentally crashing onto the
> platter when a heavy shock is anticipated (like a falling laptop
> expected to hit the floor). In fact, the whole port stops processing
> commands until the timeout has expired in order to avoid any resets due
> to failed commands on another device.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
