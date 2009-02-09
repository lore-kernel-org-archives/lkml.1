Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZBIATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZBIATn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZBIATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:19:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33294 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZBIATd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:19:33 -0500
Message-ID: <498F767B.9060701@pobox.com>
Date: Sun, 08 Feb 2009 19:19:07 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Hugh Dickins <hugh@veritas.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
References: <200902082253.07438.sshtylyov@ru.mvista.com>	<Pine.LNX.4.64.0902082108290.18661@blonde.anvils>	<498F5A25.90707@ru.mvista.com> <18831.28471.454273.451912@harpo.it.uu.se> <498F72C8.8020204@ru.mvista.com>
In-Reply-To: <498F72C8.8020204@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>   Do you really think that the transfers having lengths non-divisible by 
> 4 make any *significant* percentage even on the ATAPI devices? I think 
> it's you who is really wrong.

The answer depends on workload.  Though rare, workloads do exist that 
involve a lot of oddball querying via weird, vendor-specific SCSI[-ish] 
commands.

Moreover, the likelihood and cost of a branch mispredict are both low in 
this case, IMO.

Or a more human version of the rule:  if you have to have a long email 
thread about unlikely() placement, it is best just to avoid using 
unlikely() in that case at all.  Branch prediction units in modern CPUs 
are damned good anyways, and there is always the likelihood that a 
human-placed unlikely() becomes wrong in the future.

Plus the code is more readable without unlikely(), IMO.

	Jeff



