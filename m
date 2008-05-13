Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYEMGAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYEMGAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbYEMGAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:00:30 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:21425 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472AbYEMGA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:00:29 -0400
X-IronPort-AV: E=Sophos;i="4.27,477,1204520400"; 
   d="scan'208";a="68189239"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/3] Blackfin Sports UART Driver: fix bug - the bug caused by sport overrun, use timer to flip the tty buffer in order to return from rx ISR quickly
Date: Tue, 13 May 2008 14:02:29 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA01F2F0C9@chinexm1.ad.analog.com>
In-Reply-To: <20080512104843.5b6fb486@core>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/3] Blackfin Sports UART Driver: fix bug - the bug caused by sport overrun, use timer to flip the tty buffer in order to return from rx ISR quickly
Thread-Index: Aci0FsuD3Yz+D9JBS+C8r5Wrme9G7gAqASog
References: <1210565409-3655-1-git-send-email-cooloney@kernel.org><1210565409-3655-3-git-send-email-cooloney@kernel.org> <20080512104843.5b6fb486@core>
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bryan Wu" <cooloney@kernel.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 May 2008 06:00:27.0008 (UTC) FILETIME=[A41B0800:01C8B4BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will check it later.

Thanks a lot!
Cliff Cai

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Monday, May 12, 2008 5:49 PM
To: Bryan Wu
Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org; Cliff Cai;
Bryan Wu
Subject: Re: [PATCH 2/3] Blackfin Sports UART Driver: fix bug - the bug
caused by sport overrun, use timer to flip the tty buffer in order to
return from rx ISR quickly


Can you explain what the timer is for ? If you are trying to push the
tty processing out of the interrupt handler then surely schedule_work
would be sufficient. Also if you don't have tty->low_latency set the tty
layer will already do the actual processing work each timer event not in
the IRQ.
