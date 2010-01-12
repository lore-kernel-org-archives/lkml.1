Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621Ab0ALRLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab0ALRLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245Ab0ALRLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:11:38 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:32584 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0ALRLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p80m07KWS70hMwyRKjS2Qckj+fFgyyH3SIK+F2hFfMLC07qPncphKQnfN+CwN7HYIf
         c4YOBZ1fzYGcMh1LUL0xZOtm5XaQnBl6JfU+NQiRftL6f5vfMJCWzYcQtLcZPizhcEio
         JTaY7YIG4sn3wJt4qVMS0j3mACrvjDlT6RZlY=
Message-ID: <4B4CAD45.5080606@gmail.com>
Date: Tue, 12 Jan 2010 12:11:33 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] tcp: harmonize tcp_vx_rcv header length assumptions
References: <4B49D001.4000302@gmail.com> <4B4C4962.8040207@gmail.com> <4B4C52EA.6070705@gmail.com>
In-Reply-To: <4B4C52EA.6070705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Seems fine, but :
> 
> 1) What means the "Transformed ?" you wrote several times ?
> 
The only reason that I've been able to figure out for having the
skb->len test in those places is the preceding xfrm4_policy_check()
or xfrm6_policy_check() must be able to shrink the skb->len?

When I did the original transform stuff in other code circa 1995, I'd
envisioned IP length or link layer (PPP) length shrinking (removing
padding after block ciphers) -- and apparently this implementation
extended that concept to transport layer, too.

Personally, I'd prefer that a single test be placed in the appropriate
spot in the xfrm* functions, instead.  Anybody know where?
