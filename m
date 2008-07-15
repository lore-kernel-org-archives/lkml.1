Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbYGOCk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbYGOCk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYGOCiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:38:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30418 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762076AbYGOCiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:38:17 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5338"; a="4710515"
Message-ID: <487C0D83.8050106@qualcomm.com>
Date: Mon, 14 Jul 2008 19:37:55 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
References: <487B05CE.1050508@jp.fujitsu.com> <200807141351.25092.borntraeger@de.ibm.com> <200807142234.40700.rusty@rustcorp.com.au> <487BA152.1070102@goop.org> <20080714212026.GA6705@osiris.boeblingen.de.ibm.com> <487C0A74.4070903@jp.fujitsu.com>
In-Reply-To: <487C0A74.4070903@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hidetoshi Seto wrote:
> Heiko Carstens wrote:
>> Hmm.. probably a stupid question: but what could happen that a real cpu
>> (not virtual) becomes unresponsive so that it won't schedule a MAX_RT_PRIO-1
>> prioritized task for 5 seconds?
> 
> The original problem (once I heard and easily reproduced) was there was an
> another MAX_RT_PRIO-1 task and the task was spinning in itself by a bug.
> (Now this would not be a problem since RLIMIT_RTTIME will work for it, but
> I cannot deny that there are some situations which cannot set the limit.)
Yep. As I described in the prev email in my case it's a legitimate thing. Some
of the CPU cores are running wireless basestation schedulers and the deadlines
are way too tight for them to sleep (it's "cpu as a dedicated engine" kind of
thing, they are properly isolated and stuff).

In this case actually RT limit is the first thing that I disable :).
I'd rather have stop_machine fail and tell the user that something is wrong.
In which case they can simply stop the basestation app that is running when
convinient. ie It give control back to the user rather than wedging the box or
killing the app.

Max
