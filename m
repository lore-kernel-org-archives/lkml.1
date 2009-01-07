Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZAGQPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZAGQPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbZAGQOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:14:36 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:55945 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758748AbZAGQOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:14:34 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-IronPort-AV: E=Sophos;i="4.37,226,1231110000";   d="scan'208";a="95757726"
Message-id: <4964D4E2.8050602@nets.rwth-aachen.de>
Date: Wed, 07 Jan 2009 17:14:26 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH][TCP]: simplify tcp_mark_lost_retrans()
References: <alpine.DEB.2.00.0901071009000.6102@rhea>
 <Pine.LNX.4.64.0901071229160.27307@wrl-59.cs.helsinki.fi>
In-reply-to: <Pine.LNX.4.64.0901071229160.27307@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen schrieb:
> On Wed, 7 Jan 2009, Arnd Hannemann wrote:
>
>   
>> I noticed
>>     
>
> Good that somebody else is looking TCP code besides me... :-)
>   
Well I try hard... ;-)
>   
>> that in tcp_mark_lost_retrans the for-loop is only entered
>> if tcp_is_fack(tp) evaluates to true:
>>
>>           if (!tcp_is_fack(tp) || !tp->retrans_out ||
>>               !after(received_upto, tp->lost_retrans_low) ||
>>               icsk->icsk_ca_state != TCP_CA_Recovery)
>>                   return;
>>
>> Therefore the following check in the for-loop seems to be redundant,
>> because it always evaluates to true:
>>
>>                      (tcp_is_fack(tp) ||
>>                       !before(received_upto,
>>                               ack_seq + tp->reordering * tp->mss_cache))
>>
>> Did I miss something?
>>     
>
> It was just a left over from the RFC3517 SACK addition which added that 
> !tcp_is_fack(tp) there above. ...It would have been nice to have similar 
> lost rexmit feature without FACK as well but calculating that wasn't 
> trivial (or I didn't find that too trivial) and could end up being 
> extremely expensive in case of large holes. (So I also left it there as 
> sort of reminder).
>   
Perhaps it would be better to let the comments reflect
what you just said and remove the redundant check
anyway to reduce the dead code a newcomer has to understand ;-)
I would have included a patch for the comments, but as you have a
deeper understanding of the code it would probably
be better if you can do it.

Best regards,
Arnd



