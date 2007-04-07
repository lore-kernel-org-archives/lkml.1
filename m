Return-Path: <linux-kernel-owner+w=401wt.eu-S965981AbXDGWjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965981AbXDGWjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 18:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965961AbXDGWjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 18:39:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:45966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965975AbXDGWjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 18:39:47 -0400
To: "Andika Triwidada" <andika@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: CPU offline but power consumption increased?
References: <7e0bae390704062123i2dfaf030icd5a710677bc989a@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Apr 2007 01:38:14 +0200
In-Reply-To: <7e0bae390704062123i2dfaf030icd5a710677bc989a@mail.gmail.com>
Message-ID: <p73odlzkb6h.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Andika Triwidada" <andika@gmail.com> writes:

[cc linux-acpi]
 
> Question: is that normal? I thought power consumption will be
> automatically reduced if one core offlined.

The current cpu offline essentially just runs a special idle loop.
The standard idle loop is even a bit more aggressive on some systems
because it knows about the deeper ACPI sleep modi.

There are also dependencies between cores because current CPUs
have shared power planes between cores.

I suppose in the future when a whole socket goes off line one could
implement special code to turn off the CPU further. But it likely
won't work on older hardware.

-Andi
