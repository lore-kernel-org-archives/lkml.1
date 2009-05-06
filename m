Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZEFW74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZEFW74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZEFW7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:59:47 -0400
Received: from mail.crca.org.au ([67.207.131.56]:40283 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZEFW7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:59:47 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [RFC][PATCH 1/5] PM/Freezer: Disable OOM killer when tasks are
 frozen
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905070041.04787.rjw@sisk.pl>
References: <200905070040.08561.rjw@sisk.pl>
	 <200905070041.04787.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 07 May 2009 09:00:43 +1000
Message-Id: <1241650843.19600.124.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2009-05-07 at 00:41 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The OOM killer is not really going to work while tasks are frozen, so
> we can just give up calling it in that case.
> 
> This will allow us to safely use memory allocations for decreasing
> the number of saveable pages in the hibernation core code instead of
> using any artificial memory shriking mechanisms for this purpose.

Should we disable the warning that the nopage path gives if tasks are
frozen? I'm in two minds - if you get problems as a result, it might
help to diagnose them. On the other hand, you don't want tons of
warnings due to the hibernation code trying to allocate memory it can't
get. In TuxOnIce, I currently do all allocations with __GFP_NOWARN.

Regards,

Nigel

