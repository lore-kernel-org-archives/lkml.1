Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZCCHAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZCCHAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbZCCHA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:00:29 -0500
Received: from serv04.lahn.de ([213.239.197.57]:40243 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbZCCHA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:00:28 -0500
Date: Tue, 3 Mar 2009 08:00:25 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: /proc/sys/net/ip*/conf/all/* does not actually affect
	interfaces
Message-ID: <20090303070025.GA5042@pmhahn.de>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20090302122718.GA3906@piper.oerlikon.madduck.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302122718.GA3906@piper.oerlikon.madduck.net>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Mon, Mar 02, 2009 at 01:27:18PM +0100, martin f krafft wrote:
> I was unpleasantly surprised last night that a rogue machine managed
> to alter the IPv6 default route of one of my servers, despite my
> sysctl configuration, which disables RA for "all" interfaces during
> the boot sequence. It also changes the "default" values:
...
> Yet, net.ipv6.conf.eth0.* values were unchanged, and routing
> advertisements honoured.
> 
> This also applies to files in ipv4/, e.g. accept_redirects
...

As far as I researched for IPv4 some time ago, the "default" value gets
copied to newly created interfaces only once.
"all" on the other hand allways gets applied in addition to the current
setting, but it depends on the exact setting, if its ORed, ANDed, or
whatevered:
	log_martians         OR
	accept_redirects     AND
	forwarding           ?
	mc_forwarding        AND
	medium_id
	proxy_arp            OR
	shared_media         OR
	secure_redirects     OR
	send_redirects       OR
	bootp_relay          AND
	accept_source_route  AND
	rp_filter            AND
	arp_filter           OR
	arp_announce         MAX
	arp_ignore           MAX
	arp_accept
	app_solicit
	disable_policy
	disable_xfrm
	tag
(see include/linux/inetdevice.h:83 for IN_DEV_{AND,OR,MAX}CONF)

Putting a new value in "all" doesn't change the value you read from
"$interface", but it only gets computed and used internally.

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
