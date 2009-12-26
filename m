Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZLZOd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZLZOd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 09:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZLZOdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 09:33:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55779 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZLZOdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 09:33:25 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B361EAC.2090605@s5r6.in-berlin.de>
Date: Sat, 26 Dec 2009 15:33:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: linux-kernel@vger.kernel.org, Clemens Ladisch <cladisch@fastmail.net>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/5] firewire: fix use of multiple AV/C devices, allow
 multiple FCP listeners
References: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de> <tkrat.2eca556d1afddd17@s5r6.in-berlin.de> <4B35CACF.2000302@joow.be> <4B35FB02.1040602@s5r6.in-berlin.de> <4B360E42.80208@joow.be> <4B361A23.8090009@s5r6.in-berlin.de>
In-Reply-To: <4B361A23.8090009@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> BTW, what about AV/C RESERVE?  According to the spec, it means that a
> controller gets exclusive FCP access to a target.  At this point, a
> node-wide FCP serializer will have to decide on a policy:

(because the spec does not have a concept of reservation IDs.  It
stupidly takes node IDs for what should be reservation IDs even though
it distinguishes between the concepts of 'controller' and 'node'.)

> The simpler policy would be to remain oblivious of RESERVE.  The more
> difficult to implement policy would be to keep track of reservations
> and only allow a single controller process (or user, or...) to perform
> subsequent transactions for the duration of a reservation.

Err, no, forget that.  A reservation prevents only control commands, but
AFAIU not even all control commands because subunit specifications may
enumerate control commands that are still allowed during a reservation.
So the serializer would have to have knowledge of subunit specs.  That
would quickly get out of hand.

> (I for one would keep it simple.)
-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/
