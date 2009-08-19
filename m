Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZHSTA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZHSTA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZHSTA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 15:00:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbZHSTA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 15:00:26 -0400
Date: Wed, 19 Aug 2009 11:58:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@intel.com,
       rui.zhang@intel.com, stable@kernel.org
Subject: Re: [PATCH 1/2] ACPI processor: force throttling state when BIOS
 returns incorrect value
Message-Id: <20090819115855.193ea8bb.akpm@linux-foundation.org>
In-Reply-To: <200908171443.35622.elendil@planet.nl>
References: <200908171443.35622.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc stable)

On Mon, 17 Aug 2009 14:43:34 +0200 Frans Pop <elendil@planet.nl> wrote:

> If the BIOS reports an invalid throttling state (which seems to be
> fairly common after system boot), a reset is done to state T0.
> Because of a check in acpi_processor_get_throttling_ptc(), the reset
> never actually gets executed, which results in the error reoccurring
> on every access of for example /proc/acpi/processor/CPU0/throttling.
> 
> Add a 'force' option to acpi_processor_set_throttling() to ensure
> the reset really takes effect.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13389
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Acked-by: Zhang Rui <rui.zhang@intel.com>

Unfortunately there are changes in linux-next which make this patch
inapplicable in non-trivial ways.

So we'll be needing one flavour of the patch for 2.6.30.x and 2.6.31.x
(the patch you just sent) and a different flavour for 2.6.32.

Or we preempt the pending linux-next changes and jam these patches into the
tree first.

>
> This patch, together with the next one, fixes a regression introduced in
> 2.6.30, listed on the regression list. They have been available for 2.5
> months now in bugzilla, but have not been picked up, despite various
> reminders and without any reason given.
> 
> Google shows that numerous people are hitting this issue. The issue is in
> itself relatively minor, but the bug in the code is clear.
> 
> The patches have been in all mu kernels and today testing has shown that
> throttling works correctly with the patches applied when the system
> overheats (http://bugzilla.kernel.org/show_bug.cgi?id=13918#c14).

OK, that sucks.

Guys, what happened here?  Fixing regressions surely is our number one
hair-on-fire priority, yet the ACPI developers have found other things
to be doing for two and a half months and now we have a mess on our
hands.

Did this just fall through the cracks or is there some problem?
