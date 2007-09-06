Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbXIFLb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbXIFLb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXIFLbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:31:52 -0400
Received: from ns.suse.de ([195.135.220.2]:47318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbXIFLbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:31:52 -0400
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
References: <46DF3BFF.9000809@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Sep 2007 13:31:50 +0200
In-Reply-To: <46DF3BFF.9000809@redhat.com>
Message-ID: <p73veao9gih.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:

> Some systems lock up without the noapic option.

Please find patterns: cpu type, chipsets, mainboard vendors etc.

> I found one
> that will freeze while trying to set up the timer interrupt.
> Passing 'nolapic' makes it freeze just after:
> 
>    Setting up timer through ExtINT... works

Always boot with apic=debug

The messages means the primary timer setup methods already didn't work.
ExtInt is really a crappy fallback that was originally only
needed for some early SMP systems which where the timer was not wired
according to specs.

But the real problem is that the standard timer access method
through the local APIC didn't work.

I had a rewrite of the timer probing some time ago that tried
more combinations automatically. It had some problems so it 
never went in, but perhaps it's worth revisiting.

-Andi 
