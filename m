Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbYAWAFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbYAWAFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYAWAFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:05:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYAWAFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:05:10 -0500
Date: Wed, 23 Jan 2008 01:04:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: test case for the RODATA config option
Message-ID: <20080123000459.GB16576@elte.hu>
References: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0056]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cool!

could you perhaps also do an add-on:

> +	/* test 1: read the value */
> +	/* test 2: write to the variable; this should fault */
> +	/* test 3: check the value hasn't changed */

           test 4: make it writable again
           test 5: make it NX -> check that it's not executable

and perhaps also check that normal kernel allocations (kmalloc(), etc.) are NX as well? (with the same section trick you use in 
this patch - perhaps try to call a kmalloc()-ed buffer that contains a 
'ret' instruction - if that call faults then the test is OK, if the call 
succeeds then the test failed.)

	Ingo
