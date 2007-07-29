Return-Path: <linux-kernel-owner+w=401wt.eu-S1765784AbXG2PbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765784AbXG2PbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762617AbXG2Pav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:30:51 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:45868
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763028AbXG2Pau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:30:50 -0400
Date: Sun, 29 Jul 2007 08:30:49 -0700
From: Phil Oester <kernel@linuxace.com>
To: "Darryl L. Miles" <darryl-mailinglists@netbauds.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TCP SACK issue, hung connection, tcpdump included
Message-ID: <20070729153049.GA13309@linuxace.com>
References: <46AC2CBE.5010500@netbauds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AC2CBE.5010500@netbauds.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 06:59:26AM +0100, Darryl L. Miles wrote:
> The problems start around time index 09:21:39.860302 when the CLIENT issues 
> a TCP packet with SACK option set (seemingly for a data segment which has 
> already been seen) from that point on the connection hangs.

I'd say most likely scenario is the SERVER is behind a Cisco Pix firewall,
which has known bugs in handling packets with sack option.  By default the Cisco
has sequence number randomization enabled, but it's a half-assed implementation
which doesn't bother adjusting the sequence numbers inside sack options.

This has been reported to Cisco, and they don't seem to care.  As a workaround,
you can do this:

	echo 0 > /proc/sys/net/ipv4/tcp_sack

and it will probably fix it up.  It'd be really nice, however, to have a per-route
option for sack, similar to how we can clamp window scaling per route.  Something
like the below

	ip r a <host> <gw> <nosack>

Phil
