Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYEaJDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYEaJDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 05:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYEaJDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 05:03:06 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:2028 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750710AbYEaJDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 05:03:05 -0400
Message-ID: <4841143E.5080003@myri.com>
Date: Sat, 31 May 2008 11:02:54 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: howto use ioremap_wc?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We're looking at using ioremap_wc() in myri10ge. No drivers seem to be
using it yet, so I'd like to get some clarification regarding ioremap_wc
failures, MTRR and so on.

What we currently do is mtrr_add() and then ioremap. Depending on the
mtrr_add() success, we use the "wc_fifo" or regular PIO with fences to
submit requests to the NIC. How are we supposed to switch this to
ioremap_wc?

Are we sure that if the arch supports _wc, it does not return success
when the underlying plain ioremap worked but setting up _wc() failed? If
so, why does it revert to ioremap_nocache when PAT isn't enabled?

Can we keep the mtrr_add() in the regular path? Or are we supposed to
drop it when the arch provides ioremap_wc and it did not fail?

thanks,
Brice

