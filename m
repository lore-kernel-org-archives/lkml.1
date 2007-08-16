Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbXHPMuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbXHPMuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXHPMtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:49:52 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:23297 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751663AbXHPMtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:49:52 -0400
X-YMail-OSG: 3SJd9LcVM1m0OtIAPRNc4IaCVbZNFopqPkAd6EeA4Tv5zvniguvAiObW86aOvLsWB0fTnEzpeDpexUL1RpzJh7ypbQ--
X-RocketYMMF: knobi.rm
Date: Thu, 16 Aug 2007 05:49:50 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: RE: [PATCH 00/23] per device dirty throttling -v9
To: linux-kernel@vger.kernel.org
Cc: Peter zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <913305.55547.qm@web32608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Per device dirty throttling patches
>
>These patches aim to improve balance_dirty_pages() and directly
>address three issues:
>1) inter device starvation
>2) stacked device deadlocks
>3) inter process starvation
>
>1 and 2 are a direct result from removing the global dirty
>limit and using per device dirty limits. By giving each device
>its own dirty limit is will no longer starve another device,
>and the cyclic dependancy on the dirty limit is broken.
>
>In order to efficiently distribute the dirty limit across
>the independant devices a floating proportion is used, this
>will allocate a share of the total limit proportional to the
>device's recent activity.
>
>3 is done by also scaling the dirty limit proportional to the
>current task's recent dirty rate.
>
>Changes since -v8:
>- cleanup of the proportion code
>- fix percpu_counter_add(&counter, -(unsigned long))
>- fix per task dirty rate code
>- fwd port to .23-rc2-mm2

Peter,

 any chance to get a rollup against 2.6.22-stable?

 The 2.6.23 series may not be usable for me due to the
nosharedcache changes for NFS (the new default will massively
disturb the user-space automounter).

Cheers
Martin 


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
