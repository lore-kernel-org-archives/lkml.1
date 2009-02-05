Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbZBEVS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbZBEVS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZBEVSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:18:49 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:1511 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbZBEVSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:18:48 -0500
From: Frans Pop <elendil@planet.nl>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: PATCH:  Allow user to force 'tsc' to be treated as stable.
Date: Thu, 5 Feb 2009 22:18:45 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
References: <498B42C5.7010905@candelatech.com>
In-reply-To: <498B42C5.7010905@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902052218.46235.elendil@planet.nl>
X-OriginalArrivalTime: 05 Feb 2009 21:18:46.0662 (UTC) FILETIME=[54C40260:01C987D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear wrote:
> +       if (force_tsc_stable && (strcmp(cs->name, "tsc") == 0))
> +               printk(KERN_WARNING "Forcing tsc to be treated as stable due to force_tsc_stable=1\n");
> +       else { 
> +               printk(KERN_WARNING "  This clock is no longer valid for WATCHDOG or HIGH-RES.\n");
> +               if (strcmp(cs->name, "tsc") == 0)
> +                       printk(KERN_WARNING "  Use force_tsc_stable=1 to override.\n");

Do we really want to be so verbose?

Loads of users get these messages (I get it on both my laptops) and IIUC
the workaround is only valid for a very limited group of users.

I'd suggest dropping the "else" branch. It seems inadvisable to encourage
workarounds that may not be valid (or even safe).

Cheers,
FJP
