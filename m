Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbXG2IjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbXG2IjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 04:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760301AbXG2IjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 04:39:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41243 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760294AbXG2IjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 04:39:12 -0400
Date: Sun, 29 Jul 2007 10:39:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Willy Tarreau <w@1wt.eu>
cc: "Darryl L. Miles" <darryl-mailinglists@netbauds.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: TCP SACK issue, hung connection, tcpdump included
In-Reply-To: <20070729064511.GA18718@1wt.eu>
Message-ID: <Pine.LNX.4.64.0707291033420.9488@fbirervta.pbzchgretzou.qr>
References: <46AC2CBE.5010500@netbauds.net> <20070729064511.GA18718@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 29 2007 08:45, Willy Tarreau wrote:
>On Sun, Jul 29, 2007 at 06:59:26AM +0100, Darryl L. Miles wrote:
>> CLIENT = Linux 2.6.20.1-smp [Customer build]
>> SERVER = Linux 2.6.9-55.ELsmp [Red Hat Enterprise Linux AS release 4 
>> (Nahant Update 5)]
>> 
>> The problems start around time index 09:21:39.860302 when the CLIENT issues 
>> a TCP packet with SACK option set (seemingly for a data segment which has 
>> already been seen) from that point on the connection hangs.
>
>Where was the capture taken ? on CLIENT or on SERVER (I suspect client from
>the timers) ? A possible, but very unlikely reason would be an MTU limitation
>somewhere, because the segment which never gets correctly ACKed is also the
>largest one in this trace.[...]

I had something similar (and most strangely enough, it only seemed to happen
when the source and/or destination address was outside a given subnet). It
boiled down to that some switch acted really strange and God knows why. A
tcpdump on *both* sides (server+client) each showed that the *other* peer sent
a FIN/RST. Well in the end I settled with setting sys.net.ipv4.tcp_sack=0,
no idea if the broken switch got replaced in the meantime.
Well, just letting you know that it is not limited to computers.


	Jan
-- 
