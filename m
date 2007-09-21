Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbXIUEf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbXIUEf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 00:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXIUEfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 00:35:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41643 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbXIUEfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 00:35:14 -0400
In-Reply-To: <20070921022335.GA2849@router.lepton.home>
To: lepton <ytht.net@gmail.com>
Cc: lkm <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       netdev-owner@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH RESEND] 2.6.22.6 networking [ipv4]: fix wrong destination when
 reply packetes
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFC759A0A2.B923AD69-ON8825735D.0017012F-8825735D.00191D21@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Thu, 20 Sep 2007 21:35:09 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 7.0.2FP2HF51 | June 19, 2007) at
 09/20/2007 22:35:12,
	Serialize complete at 09/20/2007 22:35:12
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure why it's using rt_src here, but there are relevant cases that
your description doesn't cover. For example, what happens if  the source
is not set in the original packet?  Does NAT affect this?

You quote RFC text for ICMP echo and the case where the receiving machine
is the final destination, but you're modifying code that is used for all 
ICMP
types and used for ICMP errors generated when acting as an intermediate
router.

In ordinary cases, and certainly with ICMP echo when the source is set in
the original packet and no rewriting is going on (and the address is not 
spoofed),
using the original source as the destination is fine. But have you tested 
or
considered the other cases?

                                                +-DLS

