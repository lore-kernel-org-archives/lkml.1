Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbXDSW3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbXDSW3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXDSW3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:29:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47027 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbXDSW3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:29:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH 1/2] Fix PF_NOFREEZE and freezeable race
Date: Thu, 19 Apr 2007 23:39:29 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <20070419120234.GA17069@in.ibm.com>
In-Reply-To: <20070419120234.GA17069@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704192339.30783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, 19 April 2007 14:02, Gautham R Shenoy wrote:
> This patch fixes the race pointed out by Oleg Nesterov.
> 
> * Freezer marks a thread as freezeable. 
> * The thread now marks itself PF_NOFREEZE causing it to
>   freeze on calling try_to_freeze(). Thus the task is frozen, even though
>   it doesn't want to.
> * Subsequent thaw_processes() will also fail to thaw the task since it is 
>   marked PF_NOFREEZE.
> 
> Avoid this problem by checking the current task's PF_NOFREEZE status in the 
> refrigerator before marking current as frozen.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

Looks good, although I'm not sure if we don't need to call recalc_sigpending()
for tasks that turn out to be PF_NOFREEZE.

Greetings,
Rafael
