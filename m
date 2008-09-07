Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYIGJLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYIGJLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYIGJL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:11:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54043 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYIGJL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:11:28 -0400
Date: Sun, 7 Sep 2008 11:11:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH 3 of 3] x86: clean up memory corruption check and add
	more kernel parameters
Message-ID: <20080907091112.GA5574@elte.hu>
References: <patchbomb.1220777491@localhost> <72081a970effa1a32861.1220777494@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72081a970effa1a32861.1220777494@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> +	memory_corruption_check=0/1 [X86]

could you please add a second .config parameter as well:

  CONFIG_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y

which turns this parameter 1 without having to specify it on the boot 
command line. That way -tip's randconfig testing can check this on a 
couple of boxes and the WARN() will be detected automatically.

Also, i'd suggest to make the defaults of the scanning parameters be as 
widely enabled as reasonable - we want to see how much real problems 
this can catch.

> +config X86_CHECK_BIOS_CORRUPTION
> +        bool "Check for low memory corruption"
> +	default y

please make it default-disabled.

Looks good otherwise.

	Ingo
