Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYCQBoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYCQBoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYCQBnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:43:52 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:35600 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYCQBnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:43:51 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2008 21:43:50 EDT
Date: Mon, 17 Mar 2008 02:25:13 +0100
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com
Subject: Re: dst cache overflow
Message-ID: <20080317012513.GA3139@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
	linux-kernel@vger.kernel.org, dada1@cosmosbay.com
References: <20071214172945.GA10809@yamamaya.is-a-geek.org> <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au> <20071215100857.GA29839@yamamaya.is-a-geek.org> <20071216073533.GA2706@gondor.apana.org.au> <20071216083828.GA512@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216083828.GA512@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

just a reminder, the server is now running 2.6.24 and the leak is
still there.  I noticed there is a slab leak debug option and turned
it on, results should be visible in a few days I guess.

Offenders: Slabs TCPv6, size_2048 and size_512 grow over time.

I also noticed that the machine stops responding to pings after some
time, which seems to coincide with a slight increase in leak speed.

Interstingly IPv4 pings give out first, IPv6 pings continue to work a bit
longer, but eventually fail too. (Because sixxs starts sending 'your
tunnel is down!' mails I actually wrote a userspace pingd as a
workaround...)

/proc/net/snmp seems to indicate the kernel thinks it is still
sending ping replies.

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
