Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZIFEpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZIFEpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 00:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZIFEp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 00:45:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbZIFEp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 00:45:28 -0400
Date: Sun, 6 Sep 2009 06:44:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10 update 2x] PM: Measure suspend and resume times for
	individual devices
Message-ID: <20090906044440.GA29963@elte.hu>
References: <Pine.LNX.4.44L0.0908292043500.26533-100000@netrider.rowland.org> <200909041642.03774.rjw@sisk.pl> <20090904191205.GA28408@elte.hu> <200909042356.59024.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909042356.59024.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Rafael, the code looks a lot more natural IMHO.

this bit:

> +#ifdef DEBUG
> +static void dbg_get_time(struct timeval *start)
> +{
> +	do_gettimeofday(start);
> +}

is a plain wrapper over gettimeofday so you might want to inline 
it. (although GCC will do it too most of the time)

	Ingo
