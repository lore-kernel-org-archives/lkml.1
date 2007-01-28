Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXA1WSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXA1WSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbXA1WSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:18:07 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:45019 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932498AbXA1WSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:18:06 -0500
Message-ID: <45BD2119.2000209@lwfinger.net>
Date: Sun, 28 Jan 2007 16:18:01 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul Marks <pmarks@purdue.edu>
Subject: Re: Hidden SSID's
References: <45BACB71.2080107@lwfinger.net> <1169899689.25670.3.camel@localhost.localdomain>
In-Reply-To: <1169899689.25670.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Fri, 2007-01-26 at 21:48 -0600, Larry Finger wrote:
>> Is there a convention regarding the information that a wireless MAC layer should provide when
>> reporting scan data from an AP with a hidden SSID?
>>
>> In ieee80211, the software inserts the string "<hidden>" for such an AP, which seems to give
>> wpa_supplicant fits because it rejects the SSID before even looking at the encryption data. Is this
>> the normal convention?
> 
> No.  It's wrong.  It is not normal convention.  The one and only
> _correct_ way of reporting a hidden SSID is to not report the SSID at
> all.  The only item that needs to be reported with WEXT is the BSSID,
> and the client app assumes that if the SSID is not received for a given
> scan result, that the driver doesn't have an SSID for that BSSID.
> 
> I really, really don't know why ieee80211 uses <hidden>, but it's a pain
> in the ass and should NOT be done for d80211.  I don't know if we can
> ever remove it from ieee80211 though for backwards compat reasons.

Is there something funny about Cisco APs with hidden SSID? I made a patch for ieee80211 and softmac
that works on my AP when its SSID is hidden. It also works for Paul Marks on his personal AP, but
fails for the Cisco units at Purdue. His interface is a 4311 and there may be a signal strength
issue, but we are not sure.

My patch fixes ieee80211 without breaking the previous behavior.

Larry
