Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZLZOON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZLZOON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 09:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZLZOOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 09:14:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55690 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZLZOOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 09:14:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B361A23.8090009@s5r6.in-berlin.de>
Date: Sat, 26 Dec 2009 15:13:55 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: linux-kernel@vger.kernel.org, Clemens Ladisch <cladisch@fastmail.net>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/5] firewire: fix use of multiple AV/C devices, allow
 multiple FCP listeners
References: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de> <tkrat.2eca556d1afddd17@s5r6.in-berlin.de> <4B35CACF.2000302@joow.be> <4B35FB02.1040602@s5r6.in-berlin.de> <4B360E42.80208@joow.be>
In-Reply-To: <4B360E42.80208@joow.be>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pieter Palmers wrote:
[lack of system-wide FCP transaction serialization]
> This is not a 'practical' problem because most people (learn to) leave
> enough time between starting jackd and starting the mixer. This makes
> things usable, but I don't really consider this to be a satisfactory
> solution.

Ah, so this is yet another of those software flaws which are not talked
about because people take the workaround as something inevitable.

>>> I think this can only be implemented by tracking which AVC commands have
>>> been sent to what device, regardless of the userspace application (or
>>> kernel driver) that sent them, and disallowing any transactions that
>>> result in scenarios such as the above.

BTW, what about AV/C RESERVE?  According to the spec, it means that a
controller gets exclusive FCP access to a target.  At this point, a
node-wide FCP serializer will have to decide on a policy:  The simpler
policy would be to remain oblivious of RESERVE.  The more difficult to
implement policy would be to keep track of reservations and only allow a
single controller process (or user, or...) to perform subsequent
transactions for the duration of a reservation.  (I for one would keep
it simple.)
-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/
