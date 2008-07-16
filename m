Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYGPFn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYGPFn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYGPFnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:43:49 -0400
Received: from neuf-infra-smtp-out-sp604003av.neufgp.fr ([84.96.92.124]:58006
	"EHLO neuf-infra-smtp-out-sp604003av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbYGPFns convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:43:48 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2008 01:43:48 EDT
Message-ID: <487D893A.5080207@cosmosbay.com>
Date: Wed, 16 Jul 2008 07:38:02 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ian Jeffray <ian@jeffray.co.uk>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: sendfile() broken with 2.6.26 + Apache 2 ?
References: <487CD7A7.2080800@jeffray.co.uk>
In-Reply-To: <487CD7A7.2080800@jeffray.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to netdev where this report might find better answers

Ian Jeffray a écrit :
> All,
> 
> I moved from kernel 2.6.25.4 to 2.6.26 yesterday and observed that
> large files sent via Apache2 are partially corrupt.
> 
> This appears to be linked to sendfile() -- disabling the use of
> sendfile in the apache config (EnableSendfile Off) allows it to
> function as normal.
> 
> My system is a simple Core2Duo running Debian lenny/sid; nothing
> special, and I have never observed problems like this before.
> 
> The problem feels certainly related to sendfile() since the data
> reads correctly from disc in other programs, and via CIFS etc.
> 
> The corruption happens part-way in to the file... I've no exact
> figure but it would seem like maybe 32KB -- I'm seeing broken
> PNGs served from Apache, where the top few dozen lines decode
> correctly, and the rest is garbage.
> 
> I've made basically no configuration changes between 2.6.25.4 and
> 2.6.26 and have explicitly tried both enabling and disabling the
> new PAT support to no effect.
> 
> This is completely repeatable and reproducible.
> 
> Is anyone else seeing this broken behaviour?
> 


What kind of network adapter are you using ? (lspci | grep -i ether)

If you disable TCP segmentation offload on this NIC (ethtool -K eth0 tso off) , is this problem still present ?




