Return-Path: <linux-kernel-owner+w=401wt.eu-S1762252AbYB1UmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762252AbYB1UmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbYB1UmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:42:13 -0500
Received: from 1wt.eu ([62.212.114.60]:2204 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378AbYB1UmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:42:13 -0500
Date: Thu, 28 Feb 2008 21:41:47 +0100
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nebojsa Miljanovic <neb@alcatel-lucent.com>, linux-kernel@vger.kernel.org,
       "Kittlitz, Edward (Ned)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William (Bart)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
Message-ID: <20080228204146.GE8953@1wt.eu>
References: <47C6FA2A.5030302@alcatel-lucent.com> <20080228201926.558c4e7c@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228201926.558c4e7c@core>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 08:19:26PM +0000, Alan Cox wrote:
> > Currently, Linux does not allow reuse of same local port for both TCP server and
> > TCP client. I understand that there may be a need to prevent two servers from
> 
> Think about what happens for simultaneous connect (that obscure little
> corner of the tcp/ip spec). Now think about what it means for security.
>
> ALan

exactly. That's why I think that requiring the server to explicitly allow
socket reuse is mandatory. On another side of the problem, I really think
that we should make the simultaneous connect configurable. I've been patching
all of my own 2.4 kernels for a while to add a config option to turn it off
because there is a real security issue with this on. At least for mainline,
it should be a sysctl. No stateful firewall I know supports the feature, so
legitimate uses of this feature are likely very very small.

Willy
