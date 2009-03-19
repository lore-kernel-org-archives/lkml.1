Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZCSEtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZCSEtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 00:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZCSEtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 00:49:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:7700 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZCSEtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 00:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QqDaInefvNLlI9DtjJWy75Mw3sM5aVxA71kkyHzV1vFGDQ6xDTnSGeRFr4gN0wg/+F
         UiPgPaD9ULsxHyOADV90WdBafw/WcDviI41TFX4wd+ASHi2qNyGaAy+oP5vtTkdG8i0Z
         fGqOCHNJ0KrAb9XKBtyQGPnTlwZi34bca99Mk=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com>
	 <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
	 <1237140665.24621.2.camel@johannes.local>
	 <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain>
	 <1237143683.24621.7.camel@johannes.local>
	 <20090315202603.GA9077@elte.hu>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <1237317742.31814.28.camel@johannes.local>
	 <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
Date: Thu, 19 Mar 2009 12:49:30 +0800
Message-ID: <b6a2187b0903182149x77e416ecuf73be2970173c601@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:58 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> I've tracked down to the sequence of iwconfig that causes it to fail.
> This loop does not work at all without John's patch , but will work
> 100% when patched.
> This loop only works 8 of 10 times with/without the patch.

Ignore the above loop thing. The cause seems to be this one instead.


# this needs patch to work ...
iwconfig wlan0 mode Managed
ifconfig wlan0 up
iwconfig wlan0 essid xxx
iwconfig wlan0 key restricted xxx
iwconfig wlan0 ap auto channel auto


# this works with patch ...
iwconfig wlan0 mode Managed essid xxx key restricted xxx
ifconfig wlan0 up
iwconfig wlan0 ap auto channel auto

It looks the placement of "ifconfig" matters. But works on 2.6.28-rc3.


Thanks,
Jeff.
