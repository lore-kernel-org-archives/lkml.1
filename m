Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbZD2Tav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbZD2Tav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZD2Tak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:30:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbZD2Tak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:30:40 -0400
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, <mingo@elte.hu>,
       <tglx@linutronix.de>, <hpa@zytor.com>, <dougthompson@xmission.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
From: Andi Kleen <andi@firstfloor.org>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
Date: Wed, 29 Apr 2009 21:30:31 +0200
In-Reply-To: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> (Borislav Petkov's message of "Wed, 29 Apr 2009 18:54:46 +0200")
Message-ID: <87iqknp8a0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <borislav.petkov@amd.com> writes:

> Hi,
>
> thanks to all reviewers of the previous submission, here is the second
> version of this series.

The classic problem of the previous versions of these patches was that
they consume the same error registers (even if using pci config versus
msrs as access methods) as the kernel machine check poll/threshold
interrupt code.  And with two logging agents racing on the same
registers you will always get junk results. Typically with threshold 
enabled the mce code wins the race. I suspect this patchkit has
exactly the same fundamental design problem. EDAC really is not
particularly fitting for integrated memory controllers that report
their errors using standard machine check events.

-Andi (who thinks all of this decoding should be in user space anyways)

-- 
ak@linux.intel.com -- Speaking for myself only.
