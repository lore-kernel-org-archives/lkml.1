Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYGITsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYGITsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYGITsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:48:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51327 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbYGITse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:48:34 -0400
Date: Wed, 9 Jul 2008 21:47:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies (was:
	Re: [PATCH 00 of 55] xen64: implement 64-bit Xen support)
Message-ID: <20080709194753.GA8224@elte.hu>
References: <patchbomb.1215554782@localhost> <20080709111219.GA24874@elte.hu> <20080709111621.GA2780@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709111621.GA2780@elte.hu>
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


-tip testing found another PM/PM_SLEEP victim:

 arch/x86/kernel/built-in.o: In function `suspend':
 apm_32.c:(.text+0xedb5): undefined reference to `save_processor_state'
 apm_32.c:(.text+0xedd0): undefined reference to `restore_processor_state'

with this config:
 
 http://redhat.com/~mingo/misc/config-Wed_Jul__9_18_53_45_CEST_2008.bad

havent figured out yet what it's about, but the core scenario seems to 
be this combination (and only this combination) of config values:

  # CONFIG_PM is not set
  CONFIG_PM_SLEEP=y
  CONFIG_APM=y
  CONFIG_PARAVIRT=y
  CONFIG_XEN=y

( accordingly, this build failure only hit two testsystems - the others
  were able to do 250 successful builds without ever hitting this. It
  needs to be fixed nevertheless, to keep the tests going. )

	Ingo
