Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbYEAPZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbYEAPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759186AbYEAPZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:25:13 -0400
Received: from main.gmane.org ([80.91.229.2]:41752 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680AbYEAPZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:25:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jim Schutt <jaschut@sandia.gov>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 15:19:03 +0000 (UTC)
Message-ID: <loom.20080501T144943-457@post.gmane.org>
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302136.58005.rjw@sisk.pl>	<20080430131537.1f7a0914.akpm@linux-foundation.org>	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>	<20080430135405.ddc42075.akpm@linux-foundation.org>	<4818E7E3.7080705@gmail.com> <20080430151007.0ace4fa2.akpm@linux-foundation.org> <4818FAF2.9020207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 134.253.26.12 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.12) Gecko/20071018 Red Hat/1.5.0.12-0.7.el4 Firefox/1.5.0.12 pango-text)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev <dmitri.vorobiev <at> gmail.com> writes:

> 
> Andrew Morton пишет:
> 

> >> The network setup in our
> >> organization is such that I can use git only over http from that server.
> > 
> > Don't know what to do about that, sorry.  An off-site git->http proxy might
> > work, but I doubt if anyone has written the code.

Maybe your organization's http proxy will let you
tunnel the git protocol through it?

GIT_PROXY_COMMAND as described in 
http://www.gelato.unsw.edu.au/archives/git/0605/20509.html
works for me, except I substitue "nc" for "socket" in the
proxy script.

I.e.:

export GIT_PROXY_COMMAND=/usr/local/bin/proxy-cmd.sh

where proxy-cmd.sh is:

#! /bin/bash
(echo "CONNECT $1:$2 HTTP/1.0"; echo; cat ) | \
    nc my.proxy.com proxy_port | (read a; read a; cat )

In .git/config there's also

gitproxy = /usr/local/bin/proxy-cmd.sh

-- Jim


