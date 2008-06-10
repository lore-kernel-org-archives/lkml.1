Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYFJWzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYFJWzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYFJWzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:55:40 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:40423 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbYFJWzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:55:39 -0400
Message-ID: <484F065B.2050002@keyaccess.nl>
Date: Wed, 11 Jun 2008 00:55:23 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in pat_init()
References: <20080610140518.GF5024@alberich.amd.com>
In-Reply-To: <20080610140518.GF5024@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-06-08 16:05, Andreas Herrmann wrote:

> Starting with commit 8d4a4300854f3971502e81dacd930704cb88f606 (x86:
> cleanup PAT cpu validation) the PAT CPU feature flag is not cleared
> anymore. Now the error message
> 
>   "PAT enabled, but CPU feature cleared"
> 
> in pat_init() is misleading.

No, it's correct. This is to be read as "The PAT feature is enabled in 
the kernel but the CPU claims to not have PAT". The message is not a 
leftover from the old flag-clearing setup or anything; it was introduced 
in the patch that disabled that.

> Furthermore the current code does not check for existence of the PAT
> CPU feature flag if a CPU is whitelisted in validate_pat_support.

Which is okay-ish, or at least by design it seems. The paranoia check in 
pat.c will catch this case.

The current setup is okay really. The only thing it still wants is a 
commandline whitelist switch but that needs a somewhat different setup 
as validate_pat_support() is too early for __setup() or early_param().

Rene.
