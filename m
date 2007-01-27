Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbXA0P3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbXA0P3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 10:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXA0P3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 10:29:33 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:62644 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbXA0P3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 10:29:32 -0500
Message-ID: <45BB6FD4.4010907@lwfinger.net>
Date: Sat, 27 Jan 2007 09:29:24 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
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

The situation might not be too bad. The routine in ieee80211 has two direct callers, ipw2100 and
ipw2200, and is called through ieee80211softmac by bcm43xx and zd1211rw. I'll contact the
maintainers and see if we can reach an agreement regarding removal of the bad info.

Thanks for your response.

Larry
