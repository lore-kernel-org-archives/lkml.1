Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZJ1M61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZJ1M61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 08:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZJ1M60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 08:58:26 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:45867 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbZJ1M6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 08:58:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=ISO-8859-1
X-IronPort-AV: E=Sophos;i="4.44,639,1249250400";   d="scan'208";a="31502626"
Message-id: <4AE83FE4.1050309@nets.rwth-aachen.de>
Date: Wed, 28 Oct 2009 13:58:12 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andreas Petlund <apetlund@simula.no>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       ilpo.jarvinen@helsinki.fi, davem@davemloft.net
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
References: <4AE72079.4030504@simula.no> <4AE7262B.1060703@gmail.com>
In-reply-to: <4AE7262B.1060703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet schrieb:
> Andreas Petlund a écrit :
>> This patch will make TCP use only linear timeouts if the stream is thin. This will help to avoid the very high latencies that thin stream suffer because of exponential backoff. This mechanism is only active if enabled by iocontrol or syscontrol and the stream is identified as thin.
>>
> 
> Wont this reduce the session timeout to something very small, ie 15 retransmits, way under the minute ?

The session timeout no longer depends on the actual number of retransmits. Instead its a time interval,
which is roughly equivalent to the time a TCP, performing exponential backoff would need to perform
15 retransmits.

However, addressing the proposal:
I wonder how one can seriously suggest to just skip congestion response during timeout-based
loss recovery? I believe that in a heavily congested scenarios, this would lead to a goodput
goodput disaster... Not to mention that in a heavily congested scenario, suddenly every flow
will become "thin", so this will even amplify the problems. Or did I miss something?

Best regards,
Arnd
