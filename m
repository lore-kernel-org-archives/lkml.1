Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYJTRZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYJTRZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbYJTRYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:24:18 -0400
Received: from ns0.motion-twin.com ([213.186.50.39]:58238 "EHLO
	mail.motion-twin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbYJTRYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:24:17 -0400
Message-ID: <48FCBEBE.700@motion-twin.com>
Date: Mon, 20 Oct 2008 19:24:14 +0200
From: Nicolas Cannasse <ncannasse@motion-twin.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: davids@webmaster.com
CC: swivel@shells.gnugeneration.com, linux-kernel@vger.kernel.org
Subject: Re: poll() blocked / packets not received ?
References: <MDEHLPKNGKAHNMBLJOLKAEJCAIAD.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEJCAIAD.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz a écrit :
>> At least I will have nice sleep tonight.
> 
> Note that this solved your symptom, not your problem. You actually have two
> problems:
> 
> 1) You rely on TCP to detect a lost connection even by a side that will
> never transmit any data. TCP simply does not do this. If you are not trying
> to send data, you are not assured that a lost connection will be detected.
> (You either need a timeout, or you need to send or dribble some data,
> depending on the protocl.)
> 
> 2) You hold a lock on a shared resource while you wait for a reply over a
> network. If this is a low-level "block and wait indefinitely" lock, this
> will cause many threads to line up behind a slow/stuck thread. The right fix
> depends on your circumstances, but you need to use a synchronization
> primitive that is suitable. (You need to be able to use multiple connections
> or defer operations without holding a thread.)

I agree with both points, but I can't modify the MySQL protocol to 
implement that.

For (1) I can't add the timeout since I have no way to differentiate 
between a lost connection and a request that takes time to execute. I'll 
maybe check if the protocol allow pings while waiting for the request 
result, but I'm not sure it does.

For (2) the shared resources is on the database side, not on the server 
side. It's the transaction that have some rows locked. I have no 
solution for that.

Best,
Nicolas
