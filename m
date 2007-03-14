Return-Path: <linux-kernel-owner+w=401wt.eu-S1030332AbXCNGHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332AbXCNGHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 02:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965196AbXCNGHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 02:07:20 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:46917 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbXCNGHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 02:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QX1d00tCms5K3NVYPRkDZvT+3iHkKzvaZ9noAbgJo92i7q7ZKOT1p5F5QnEUXAlNKEW+LkifT7RAHQIxIzKdLCMk6z/gbFzkURoW9fggMV7MeIniA6QYna8p5VSzPCcvIWEOIccQ1VjRGqnsQFxb9uakDZgu3UL3as1bmqyk9To=
Message-ID: <45F7910C.6060502@gmail.com>
Date: Wed, 14 Mar 2007 15:07:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aGlldSBCw6lyYXJk?= <Mathieu.Berard@crans.org>
CC: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [3/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015036.GH3441@stusta.de> <45EE9E39.3010800@garzik.org> <45F20541.9090208@crans.org> <45F53B60.8020908@gmail.com> <45F69989.70702@crans.org> <45F69C02.2020206@gmail.com> <45F71003.4030003@crans.org>
In-Reply-To: <45F71003.4030003@crans.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mathieu Bérard wrote:
> [   15.031823] ata1.00: taskfile_load_raw: (0x1f1-1f7): hex: 10 03 00 00
> 00 a0 ef

Okay, this is interesting.  This is Enable Device-Initiated Interface
Power State Transitions.  So, after this command is executed the device
will try to transit to partial/slumber SATA PHY power states at its
discretion, which is all cool and dandy in theory but depending on
controller and drive firmware can cause all sorts of problems.

The NCQ problem you're seeing probably is some side effect of device
initiated link PS.  Can't tell whether the controller or the drive's
firmware is problem without further info.  Due to blacklisting, NCQ
won't be turned on your drive in future kernels and link PS doesn't seem
to cause any problem no non-NCQ, so your case is taken care of here but
this leaves me a bit worried about what _GTF feeds us.

I don't think we can reliably filter out command TFs as it might even
contain vendor-specific commands but it might be better to always log
TFs executed for _GTF such that we at least know what's going on with
the drive.

Thanks.

-- 
tejun
