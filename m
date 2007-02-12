Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXBLTuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXBLTuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965353AbXBLTuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:50:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46719 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965352AbXBLTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:50:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [7/29] x86_64: update IO-APIC dest field to 8-bit for xAPIC
References: <20070212551.664370000@suse.de>
	<20070212165127.1790A13FAE@wotan.suse.de>
Date: Mon, 12 Feb 2007 12:49:28 -0700
In-Reply-To: <20070212165127.1790A13FAE@wotan.suse.de> (Andi Kleen's message
	of "Mon, 12 Feb 2007 17:51:27 +0100 (CET)")
Message-ID: <m164a7w3zr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> From: Benjamin Romer <benjamin.romer@unisys.com>
>
> On the Unisys ES7000/ONE system, we encountered a problem where performing
> a kexec reboot or dump on any cell other than cell 0 causes the system
> timer to stop working, resulting in a hang during timer calibration in the
> new kernel.
>
> We traced the problem to one line of code in disable_IO_APIC(), which needs
> to restore the timer's IO-APIC configuration before rebooting.  The code is
> currently using the 4-bit physical destination field, rather than using the
> 8-bit logical destination field, and it cuts off the upper 4 bits of the
> timer's APIC ID.  If we change this to use the logical destination field,
> the timer works and we can kexec on the upper cells.  This was tested on
> two different cells (0 and 2) in an ES7000/ONE system.
>
> For reference, the relevant Intel xAPIC spec is kept at
> ftp://download.intel.com/design/chipsets/e8501/datashts/30962001.pdf,
> specifically on page 334.
>
> Signed-off-by: Benjamin M Romer <benjamin.romer@unisys.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
> Cc: Andi Kleen <ak@suse.de>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@in.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Eric W. Biederman" <ebiederm@xmission.com>

