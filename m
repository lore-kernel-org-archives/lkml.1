Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbZJaNhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbZJaNhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 09:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932351AbZJaNhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 09:37:38 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:34874 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766AbZJaNhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 09:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=YnwXnZKtZdikKYfG32vfKGL6Z7xy0JbojNq1YW1u+hhbeWUMP3QaJvRhpUyVYl8ayG
         29t5SMvTsSdXPEzlAlw2RZ5Aqf3ojQrxBboLYrcz8IYyqLsI9QJS4JfkQiAbANVwzIpU
         4dpKa91vE0TtI+6JOCV7uF/pBWLOajHOYsRbM=
Date: Sat, 31 Oct 2009 09:37:33 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-laptop
To: Johannes Berg <johannes@sipsolutions.net>
cc: Parag Warudkar <parag.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: OOPS in cfg80211_conn_work
In-Reply-To: <1256970899.3555.86.camel@johannes.local>
Message-ID: <alpine.DEB.2.00.0910310936110.5317@parag-laptop>
References: <f7848160910291617q2b168089l5ce489d2f47ebe96@mail.gmail.com> <1256885343.3555.0.camel@johannes.local> <alpine.DEB.2.00.0910300652350.2223@parag-laptop> <1256903425.3555.47.camel@johannes.local> <f7848160910301622t2cf43b5bo5ffeda03ec2cdbfe@mail.gmail.com>
 <1256970899.3555.86.camel@johannes.local>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Oct 2009, Johannes Berg wrote:
> 
> iw event -t -f > /tmp/log

Here it goes - this is while trying couple times to reproduce the issue.

Parag

1256995923.900741: wlan0 (phy #0): deauth 00:21:6a:1e:33:1a -> 00:1d:7e:93:3a:58 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS [frame: c0 00 00 00 00 1d 7e 93 3a 58 00 21 6a 1e 33 1a 00 1d 7e 93 3a 58 00 00 03 00]
1256995923.900918: wlan0 (phy #0): disconnected (local request)
1256995923.900953: wlan0 (phy #0): deauth 00:21:6a:1e:33:1a -> 00:16:01:d6:6f:12 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS [frame: c0 00 00 00 00 16 01 d6 6f 12 00 21 6a 1e 33 1a 00 16 01 d6 6f 12 00 00 03 00]
1256995923.901000: wlan0 (phy #0): failed to connect to 00:16:01:d6:6f:12, status: 1: Unspecified failure
1256995923.901861: wlan0 (phy #0): scan started
1256995923.918218: wlan0 (phy #0): failed to connect, status: 1: Unspecified failure
1256995923.918270: wlan0 (phy #0): scan finished: 2452, "f2\x0d\xb71X\xa3Z%]\x05\x17X\xe9^\xd4\xab\xb2\xcd\xc6\x9b\xb4T\x11\x0e\x82tA!=\xdc\x87"
1256995933.941448: wlan0 (phy #0): scan started
1256995937.245751: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825, ""
1256995937.247315: wlan0 (phy #0): scan started
1256995937.247366: wlan0 (phy #0): deauth 00:21:6a:1e:33:1a -> 00:16:01:d6:6f:12 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS [frame: c0 00 00 00 00 16 01 d6 6f 12 00 21 6a 1e 33 1a 00 16 01 d6 6f 12 00 00 03 00]
1256995937.247417: wlan0 (phy #0): failed to connect to 00:16:01:d6:6f:12, status: 1: Unspecified failure
1256995937.287319: wlan0 (phy #0): scan finished: 2452, "f2\x0d\xb71X\xa3Z%]\x05\x17X\xe9^\xd4\xab\xb2\xcd\xc6\x9b\xb4T\x11\x0e\x82tA!=\xdc\x87"
1256995937.293899: wlan0 (phy #0): auth 00:1d:7e:93:3a:58 -> 00:21:6a:1e:33:1a status: 0: Successful [frame: b0 00 3a 01 00 21 6a 1e 33 1a 00 1d 7e 93 3a 58 00 1d 7e 93 3a 58 10 f0 00 00 02 00 00 00]
1256995937.298275: wlan0 (phy #0): assoc 00:1d:7e:93:3a:58 -> 00:21:6a:1e:33:1a status: 0: Successful [frame: 10 00 3a 01 00 21 6a 1e 33 1a 00 1d 7e 93 3a 58 00 1d 7e 93 3a 58 20 f0 11 04 00 00 02 c0 01 04 82 84 8b 96 32 08 8c 12 98 24 b0 48 60 6c dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 07 00 0c 43 01 00 00 00]
1256995937.298391: wlan0 (phy #0): connected to 00:1d:7e:93:3a:58
1256995941.863589: wlan0 (phy #0): deauth 00:21:6a:1e:33:1a -> 00:1d:7e:93:3a:58 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS [frame: c0 00 00 00 00 1d 7e 93 3a 58 00 21 6a 1e 33 1a 00 1d 7e 93 3a 58 00 00 03 00]
1256995941.863706: wlan0 (phy #0): disconnected (local request)
1256995941.863744: wlan0 (phy #0): deauth 00:21:6a:1e:33:1a -> 00:16:01:d6:6f:12 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS [frame: c0 00 00 00 00 16 01 d6 6f 12 00 21 6a 1e 33 1a 00 16 01 d6 6f 12 00 00 03 00]
1256995941.863791: wlan0 (phy #0): failed to connect to 00:16:01:d6:6f:12, status: 1: Unspecified failure
1256995941.864860: wlan0 (phy #0): scan started
1256995941.883549: wlan0 (phy #0): failed to connect, status: 1: Unspecified failure
1256995941.883658: wlan0 (phy #0): scan finished: 2452, "p\xe9>\xa1A\xe1\xfcg>\x01~\x97\xea\xdck\x96\x8f8\*\xec\xb0;\xfb2\xaf<T\xec\x18\xdb\"
1256995951.192371: wlan0 (phy #0): scan started
1256995954.482288: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825, "pbwloft2"
1256995954.483920: wlan0 (phy #0): scan started
1256995954.483976: wlan0 (phy #0): deauth 00:21:6a:1e:33:1a -> 00:16:01:d6:6f:12 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS [frame: c0 00 00 00 00 16 01 d6 6f 12 00 21 6a 1e 33 1a 00 16 01 d6 6f 12 00 00 03 00]
1256995954.484027: wlan0 (phy #0): failed to connect to 00:16:01:d6:6f:12, status: 1: Unspecified fa
