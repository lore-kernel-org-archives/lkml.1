Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZLJTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZLJTen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZLJTel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:34:41 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:23912 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbZLJTek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:34:40 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADTcIEurRN+K/2dsb2JhbADAepcWhCsE
X-IronPort-AV: E=Sophos;i="4.47,376,1257120000"; 
   d="scan'208";a="117631253"
From: Roland Dreier <rdreier@cisco.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk>
	<20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>
	<67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>
	<20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org>
	<4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk>
	<20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org>
	<20091210192659.GV8742@kernel.dk>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Dec 2009 11:34:45 -0800
In-Reply-To: <20091210192659.GV8742@kernel.dk> (Jens Axboe's message of "Thu,
	10 Dec 2009 20:26:59 +0100")
Message-ID: <ada638emxm2.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Dec 2009 19:34:46.0353 (UTC) FILETIME=[D47B6C10:01CA79CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Roland, are you filing a report for this?

Yes, I'll try to track this down.

 > I can test other patches if you have good ideas, otherwise I suggest we
 > revert the commit.

I'll definitely try to get the BIOS fixed but I do also think that the
kernel shouldn't panic on bad info from the BIOS -- we used to be able
to run fine with what the BIOS gave us.  BIOSes are always going to be
crap, and we can print nasty messages in those cases, but the kernel
shouldn't panic unless things are really hopeless.

The benefit of the commit in question seemed to be code cleanup and
reducing use of bootmem -- which I don't think is enough benefit to
justify increasing fragility at runtime.

 - R.
