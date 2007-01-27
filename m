Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbXA0MFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbXA0MFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 07:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXA0MFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 07:05:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXA0MFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 07:05:37 -0500
Subject: Re: Hidden SSID's
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <45BACB71.2080107@lwfinger.net>
References: <45BACB71.2080107@lwfinger.net>
Content-Type: text/plain
Date: Sat, 27 Jan 2007 07:08:09 -0500
Message-Id: <1169899689.25670.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-01-26 at 21:48 -0600, Larry Finger wrote:
> Is there a convention regarding the information that a wireless MAC layer should provide when
> reporting scan data from an AP with a hidden SSID?
> 
> In ieee80211, the software inserts the string "<hidden>" for such an AP, which seems to give
> wpa_supplicant fits because it rejects the SSID before even looking at the encryption data. Is this
> the normal convention?

No.  It's wrong.  It is not normal convention.  The one and only
_correct_ way of reporting a hidden SSID is to not report the SSID at
all.  The only item that needs to be reported with WEXT is the BSSID,
and the client app assumes that if the SSID is not received for a given
scan result, that the driver doesn't have an SSID for that BSSID.

I really, really don't know why ieee80211 uses <hidden>, but it's a pain
in the ass and should NOT be done for d80211.  I don't know if we can
ever remove it from ieee80211 though for backwards compat reasons.

Dan

> Thanks,
> 
> Larry
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

