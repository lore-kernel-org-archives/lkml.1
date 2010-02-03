Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab0BCBca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:32:30 -0500
Received: from sentry-three.sandia.gov ([132.175.109.17]:52697 "EHLO
	sentry-three.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab0BCBc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:32:28 -0500
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 20:32:28 EST
X-WSS-ID: 0KX8SAA-08-3L8-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: "Kevin Pedretti" <ktpedre@sandia.gov>
To: "David Miller" <davem@davemloft.net>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100202.134251.15604523.davem@davemloft.net>
References: <20100202205845.GE5246@hawkeye.sandia.gov>
 <20100202.134251.15604523.davem@davemloft.net>
Date: Tue, 2 Feb 2010 18:24:02 -0700
Message-ID: <1265160242.15726.20.camel@hawkeye.sandia.gov>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.1
X-TMWD-Spam-Summary: TS=20100203013216; ID=1; SEV=2.3.1;
 DFV=B2010020301; IFV=NA; AIF=B2010020301; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230352E34423638443232302E303044332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2010020301_5.03.0010
X-WSS-ID: 67760D972DG1933603-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you all for the review comments.  I believe most of the issues
have been addressed in the patch just posted.  I apologize if there are
still issues, and certainly appreciate further comments.

David Miller's comments:
1. Use u32, u16, etc.  -> Done.
2. Bad code formating -> Fixed, I believe. Went through everything.
3. Call netif_start_queue() after hw init -> Done.
4. Device only supports IPv4? -> Yes, that's correct. No IPv6 support.
The driver squashes everything but IPv4 in eth2ss().
5. No need for suspend/resume NOPs -> Done.  functions removed.

Randy Dunlap's comments:
1. Remove /** comments -> Done.
2. Odd spacing -> I'm not seeing this. Spacing looks correct to me.
3. Limit while (1) loops somehow -> Done. 
4. Limit while (1) in intr handler -> In practice we've never seen more
than a few packets processed per interrupt.

Ben Hutching's comments:
1. Spacing looks correct -> Thanks. 

Stephen Hemminger's comments:
1. Add ndo_validate_address -> Done
2. May want to use alloc_netdev() -> Didn't do this. Would there be a
substantial advantage to doing this?
3. memset() unnecessary -> removed

Kevin


