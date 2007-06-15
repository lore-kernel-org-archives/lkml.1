Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbXFONgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbXFONgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXFONgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:36:32 -0400
Received: from www19.your-server.de ([213.133.104.19]:2613 "EHLO
	www19.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbXFONgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:36:31 -0400
X-Greylist: delayed 1619 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 09:36:31 EDT
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: LKML <linux-kernel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] PM: Disable usermode helper before hibernation and suspend
Date: Fri, 15 Jun 2007 15:08:52 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200706042325.28965.rjw@sisk.pl> <200706042328.27887.rjw@sisk.pl>
In-Reply-To: <200706042328.27887.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151508.53191.u.luckas@road.de>
X-Authenticated-Sender: webmaster@road.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4. June 2007, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Use a hibernation and suspend notifier to disable the user mode helper
> before a hibernation/suspend and enable it after the operation.
>
Hi Rafael,
I have a couple of questions, regarding this patch ...
> -	if (!khelper_wq)
> +	if (!khelper_wq || usermodehelper_disabled)
>  		return -EBUSY;
1) how about not returning -EBUSY here, if (wait == UMH_NO_WAIT)?
2) how does your patch prevent wait_for_completion(&done) to hang during
   freezing if usermodehelper_pm_callback is called _after_ the above check?

Regards
Uli
