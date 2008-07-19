Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYGSMcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYGSMcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYGSMbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:31:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:48092 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbYGSMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding:from;
        b=xD72O44WXM+Wn5gMNq/OIOpBUEzz2y3u+gsX2M4pSNemp/hpjyrOYU4KNDpQaSvVuK
         9HJCKPDpJ0Txhh7NcGHO3S917txovOswp8owe5bO2xfYtc2ty31IhWvWSig2VS/WHsXS
         SVc1CeytlstTp7NhSQqEv+pbKSF5P82f40cJw=
Message-ID: <4881DEB2.8030508@bellsouth.net>
Date: Sat, 19 Jul 2008 07:31:46 -0500
Reply-To: jacliburn@bellsouth.net
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ian Jeffray <ian@jeffray.co.uk>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sendfile() broken with 2.6.26 + Apache 2 ?
References: <487CD7A7.2080800@jeffray.co.uk>
In-Reply-To: <487CD7A7.2080800@jeffray.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: "J. K. Cliburn" <jcliburn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Jeffray wrote:
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

Can you please enable verbose logging

echo 8 > /proc/sys/kernel/printk
ethtool -s eth0 msglvl 0xffff

and see if the driver issues any error messages as the file is transferred?
