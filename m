Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZHGVV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZHGVV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZHGVV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:21:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53517 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZHGVVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:21:55 -0400
Subject: Re: Libertas: Association request to the driver failed
From: Dan Williams <dcbw@redhat.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090807191156.GS19257@buzzloop.caiaq.de>
References: <20090807191156.GS19257@buzzloop.caiaq.de>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 16:21:37 -0500
Message-Id: <1249680097.26088.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 21:11 +0200, Daniel Mack wrote:
> Since a recent merge of the wireless tree to Linus' master, my SDIO
> connected libertas module fails to connect to our WLAN.
> 
> 'iwlist scanning' works fine, but wpa_supplicant keeps on spitting out
> the following message:
> 
>   CTRL-EVENT-SCAN-RESULTS 
>   Trying to associate with 00:04:0e:4b:c7:b3 (SSID='caiaq' freq=2437 MHz)
>   Association request to the driver failed
> 
> Haven't done any bisect or deeper inspection of recent changes yet. Can
> anyone point me in some direction maybe? The change must have been
> introduced between -rc3 and -rc5. My userspace did not change since
> then.

That error actually means nothing and I believe the log message has been
removed in recent supplicant versions.  It simply means that the driver
doesn't support some of the random ioctls that the supplicant tries, but
most of the time, that's not a problem.

What you can do for the time being is increase the association timeout
(which gets lowered to like 5 seconds if that message is printed because
the driver returned -1 from wpa_drv_associate()), and see if the card
does in fact associate after 10 or 15 seconds.  That is a useful point
of debugging information.

Dan


