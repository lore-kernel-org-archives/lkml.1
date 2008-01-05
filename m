Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYAEQ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYAEQ4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYAEQ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 11:56:25 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37704 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbYAEQ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:56:24 -0500
Date: Sat, 5 Jan 2008 18:56:23 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: linux-kernel@vger.kernel.org
Cc: Simon Horman <horms@verge.net.au>, "David S. Miller" <davem@davemloft.net>
Subject: Problems with nfsroot due to ip= cmdline changes
Message-ID: <20080105165623.GA30987@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	"David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently rebased my kernel tree and discovered that my nfsroot setup
no longer worked. Here's the relevat part of my cmdline:

ip=192.168.2.200:192.168.2.185:192.168.2.1:255.255.255.0::eth0:off nfsroot=192.168.2.185:/my_nfsroot,v3,tcp root=/dev/nfs

I discovered that now I had to change the autoconfiguration option to
"on" in order to make nfsroot work. I only want to specify the IP
address manually so I don't really want autoconfiguration. The current
code works since it will not try autoconfiguration when all options are
specified manually but the current behaviour does not really match the
documentation ie. now the autoconf parameter can disable the whole IP
configuration step even though the documentation says it will only
disable autoconfiguration.

Looks like these are the relevant commits:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6c05c3d064dbb83be88cba3189beb5db9d2dfc3
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9cecd07c3f7a818a5865daad8cb5be408508dc99

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
