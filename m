Return-Path: <linux-kernel-owner+w=401wt.eu-S1763318AbXEWIHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763318AbXEWIHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbXEWIH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:07:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:5086 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbXEWIHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VfjFikTJJeX+CckEgkjtAO+xYmtfAPo4/vW6vk27e6V5yDZFmwJym7wGsjcJ6d7cgnUXP/QdU29xzzB439yZN0Ya0D+PyrbbZABSEJGdkeUP2xZ5HEBkS8j0Ny/PjF4+U2uBRYba7BL1vyLmerYD1KXDk15gNvZAJAXElzOor8c=
Message-ID: <4653F62C.4070700@gmail.com>
Date: Wed, 23 May 2007 10:07:08 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: pata_platform: Disable prereset logic.
References: <20070523064408.GA29593@linux-sh.org>
In-Reply-To: <20070523064408.GA29593@linux-sh.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On a number of boards the current prereset logic seems to misbehave:
> 
> scsi0 : pata_platform
> ata1: PATA max PIO0 cmd 0xb06001f0 ctl 0xb06003f6 bmdma 0x00000000 irq 0
> ata1: device not ready (errno=-19), forcing hardreset
> ata1: BUG: prereset() requested invalid reset type
> 
> This triggers when there is no card inserted in the slot.
> 
> Simply disabling the prereset gets rid of this, and doesn't seem to cause
> any problems for either PCMCIA or CF cards when they're actually present.

NACK.  The BUG printking needs fixing but you can't just kill
prereset().  Did it work properly on 2.6.21.1?  Can you modify
ata_wait_ready() such that it prints out the status value while waiting?

-- 
tejun
