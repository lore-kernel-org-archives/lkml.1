Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZC1LVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZC1LVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 07:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZC1LUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 07:20:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZC1LUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 07:20:53 -0400
Date: Sat, 28 Mar 2009 12:20:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael K. Johnson" <johnsonm@rpath.com>
Cc: jmforbes@linuxtx.org, hpa@zytor.com, Jordan_Hargrave@Dell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mark %esi as clobbered in E820 BIOS call
Message-ID: <20090328112035.GA11146@elte.hu>
References: <20090327171441.GD4363@logo.rdu.rpath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327171441.GD4363@logo.rdu.rpath.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael K. Johnson <johnsonm@rpath.com> wrote:

> Justin and Peter, please review this for stable .y trees.  Peter,
> please review this for trunk unless you decide to do a more 
> extensive workaround for BIOS register clobbering.
> 
> Thanks!
> 
> $ cat e820-esi-clobber-workaround.patch
> Jordan Hargrave diagnosed a BIOS clobbering %esi in the E820 call.
> That particular BIOS has been fixed, but there is a possibility that
> this is responsible for other occasional reports of early boot
> failure, and it does not hurt to add %esi to the clobbers.

nice fix! Would you mind to update the clobber list to include _all_ 
registers? I dont see why any of the other registers couldnt be 
clobbered by a BIOS, and this is boot-only code so micro-performance 
is not an issue.

	Ingo
