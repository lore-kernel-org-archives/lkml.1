Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYGIOi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYGIOi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbYGIOia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:38:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1137 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754212AbYGIOi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:38:29 -0400
Date: Tue, 8 Jul 2008 21:37:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC PATCH 0/4] save and restore ACPI NVS memory during hibernation
Message-ID: <20080708193752.GD8694@ucw.cz>
References: <1215051868.5628.32.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215051868.5628.32.camel@rzhang-dt.sh.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> According to the ACPI spec, ACPI NVS memory region is required to
> be saved/restored by OS during hibernation.
> 
> Section 15.3.2 ACPI Spec 3.0b,
> "OSPM will call the _PTS control method some time before entering
> a sleeping state, to allow the platform???s AML code to update
> this memory image before entering the sleeping state.
> After the system awakes from an S4 state, OSPM will restore this
> memory area and call the _WAK control method to enable the BIOS
> to reclaim its memory image."
> 
> This patch set add the mechanism to save/restore ACPI NVS memory
> during hibernation.
> 
> Patch 01: call platform_begin before swsusp_shrink_memory.
> 	So that we can allocate enough pages for ACPI NVS memory
> 	before shrink the memory.

Why is it neccessary to allocate memory for a copy? We should be able
to save ACPI NVS area same way we are saving kernel pages, no?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
