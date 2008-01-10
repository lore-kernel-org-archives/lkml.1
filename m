Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYAJJ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYAJJ7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYAJJ7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:59:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:57648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbYAJJ67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:58:59 -0500
Date: Thu, 10 Jan 2008 10:58:57 +0100
From: Andi Kleen <ak@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <ak@suse.de>, rjw@sisk.pl, pavel@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080110095857.GN25945@bingen.suse.de>
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de> <20080103181438.GA7141@does.not.exist> <200801031943.43828.ak@suse.de> <20080110095407.GB28740@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110095407.GB28740@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems the correct solution would be not to hijack __cpuinit
> (as your patch does), but to create a new annotation.

The rationale is that after suspend the CPU has to be reinitialized.
That is because it is essentially like a reboot. All the previous
CPU state is gone.

It doesn't need to touch state in memory only -- if you want
you could create a new annotation for functions that only touch
memory; but I'm not sure it would buy all that much.

-Andi
