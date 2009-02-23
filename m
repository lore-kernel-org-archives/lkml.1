Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZBWWoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZBWWoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZBWWny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:43:54 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:48092 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbZBWWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:43:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mGgriTrAekpI4Noc8mjSndlLl8zofOR4CJcK6Branp+g/TB1GRyuLdpLS+bHClHlqN
         LDhjAoXoc0cZQNedCxdqEl7rpvBdkvxNwopGLvszUHNxrtwl8E6sGTF9lMThaXre4tym
         NzK6b5aaK/eux2DUhutF0w5tiXT7ru2AS0AmE=
Message-ID: <49A326A4.8090103@gmail.com>
Date: Mon, 23 Feb 2009 23:43:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com>
In-Reply-To: <49A321BA.2040500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.2.2009 23:22, Jiri Slaby wrote:
> We should hit (unlikely(ret == -EINPROGRESS)) test
> everytime.

I get on a AR2413
XX 000 128c0054 cb980203
XX 001 00000000 00000000
XX 000 128c0054 cfb80003
XX 001 00000000 00000000
XX 000 00001420 00000001
ath5k phy5: unsupported jumbo
XX 001 126c001c 80600003
XX 002 00000000 00000000
XX 000 127d8079 44ca0003
XX 001 00000000 00000000
XX 000 128d8079 54cc0003
(count, status_0, status_1)
so it means, it sets done flag even for more flag descs and thus we 
handle it well in this particular case.
