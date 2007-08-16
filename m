Return-Path: <linux-kernel-owner+w=401wt.eu-S934147AbXHPAPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbXHPAPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbXHPAPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:15:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38786 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbXHPAPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:15:22 -0400
Message-ID: <46C39715.6030602@zytor.com>
Date: Wed, 15 Aug 2007 17:15:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: do get_rtc_time() correctly
References: <46C35284.1080003@reed.com>
In-Reply-To: <46C35284.1080003@reed.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> 
> The idea in the comment at the top seems to suggest that the author
> thought that the UIP flag indicates an update is in progress at that
> very instant, so one needs to synchronize with the "falling edge" of
> that flag to ensure that one can read the RTC state without instability
> in its buffered value.   That is not the way the UIP flag is defined to
> work. 
> The UIP flag is =1 during a period PRIOR to the actual update, starting
> 224 usec before the update, and ending when the update is complete.   It
> is done that way (which might seem odd) so that if you read UIP=0, you
> have a 224 usec window, EVEN IF the UIP were to become =1 just after you
> read it.
> 

That's not why it synchronizes with the UIP flag.

The purpose is to figure out where the RTC thinks the beginning of the
second is.

One can argue about the utility of that (since it's uncertain whether
setting the RTC will cause the beginning of the second to be updated),
but that was supposedly the reason for it 15 years ago.

	-hpa
