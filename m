Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbYGQQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbYGQQCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760641AbYGQQCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:02:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:2036 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760203AbYGQQCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=dj2OHdOyQSrqSdXVB15nqh7jVZX9Xhp9WLUNi9w8fy+SrPBFrI+GwCBQ9t9l/Ib/6I
         4DUff9OC3GO4CIz6ZJjyCbTp1/Z1Qm3MmGAN4Duq48+TzzzA0Uhd6CMMzOV0CiHizJOP
         CLzpQFegV2bMTPNUGtxZ8Q+c3YtwmSrMNThlA=
Message-ID: <487F6D2E.2040501@tuffmail.co.uk>
Date: Thu, 17 Jul 2008 17:02:54 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs)
 on Asus EeePC
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F58B6.5040309@suse.de>
In-Reply-To: <487F58B6.5040309@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Hi Alan,
>
> Could you please test if your patch works with the last patch in #10919?
>
> Thanks,
> Alex.
Vacuously so.

My patch still applies, but #10919 makes it obsolete.  My patch fixed a
bug that shows up in polling mode.  #10919 kills polling mode.

I've tested v2.6.26 + #10919 and it works fine (except for spamming the
kernel log - please read my Bugzilla comment).


It appears that interrupt mode suffered from a race which is very
similar to my original problem.  If two GPE interrupts arrive before the
workqueue runs, then the second interrupt will be ignored because
EC_FLAGS_QUERY_PENDING is still set.  This will happen with any EC if
interrupts are very close together, right?

I think my patch also fixes this theoretical problem.  But I'd rather
you took over on this.  I was already confused by ec.c in v2.6.26, and
with #10919 I understand it even less.  E.g. why is
ec_switch_to_poll_mode() still present; what does it do now do_ec_poll()
is removed?

I'm happy to work on this with you, but I'd need to be able understand
the code first :-(.

Alan
