Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYFKM7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYFKM7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYFKM7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:59:21 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:44934 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYFKM7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:59:20 -0400
Message-ID: <484FCC09.7020606@keyaccess.nl>
Date: Wed, 11 Jun 2008 14:58:49 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>, qt@alberich.amd.com
Subject: Re: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in	pat_init()
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl> <20080611094130.GA5889@alberich.amd.com>
In-Reply-To: <20080611094130.GA5889@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-08 11:41, Andreas Herrmann wrote:

> As I had no Transmeta or Centaur CPU at hand I just cleared the PAT
> flag in the CPU identification code to simulate the case that all CPUs
> of a Vendor are whitelisted (even those w/o PAT support).  The first
> time pat_init() is entered you get
> 
>   PAT enabled, but CPU feature cleared 
>     (=> which is wrong as no flag was cleared)

Again, you are misreading this. Please just replace the message mentally 
by "PAT enabled, but CPU claims to not support PAT". "cleared" here does 
not signify that we ourselves cleared anything, just that flag IS clear 
(unset). Yes, maybe the wording could be better but it's not wrong.

>   x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>     (=> which is wrong as PAT shouldn't be enabled on such CPUs)

Again not wrong, or at least by design. Thomas Gleixner did it this way 
and with that "paranoia check" explicitly bombing out only for SMP this 
wouldn't have been by accident. He no doubt knows why he did so (and 
he's in CC so if we're real lucky we might also now...)

> IMHO the current state is:
> 
> We can whitelist all Transmeta, Centaur and AMD CPUs (no errata wrt
> PAT are known).  So the assumption is that for those CPUs PAT works if
> advertised.
> 
> Then we have Intel for which all family 0xf CPUs, and family 6 CPUs
> starting with model 15 are whitelisted. AFAIK there are other Intel
> CPUs that advertise PAT support.

Definitely. Even my P2 (family 6, model 5) does. The whitelist was 
discussed to be a temporary measure in an attempt to for now not muddy 
testing of the feature with reports from CPUs in which the feature 
designers weren't particularly interested. It should be turned into a 
blacklist at a relatively nearby point after which also no whitelisting 
command line switches are needed anymore.

I have myself been applying a patch to whitelist all of AMD family 6 but 
  with things just temporary this is no big deal...

Rene.
