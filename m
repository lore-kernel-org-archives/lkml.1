Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbYGaQPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbYGaQPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYGaQPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:15:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34446 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750907AbYGaQPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:15:25 -0400
Date: Thu, 31 Jul 2008 11:15:22 -0500
From: Paul Jackson <pj@sgi.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removes extra checking in kernel/cpuset.c
Message-Id: <20080731111522.6417f750.pj@sgi.com>
In-Reply-To: <b9df5fa10807310846g27913d82icf2a82e77992ba9f@mail.gmail.com>
References: <b9df5fa10807310846g27913d82icf2a82e77992ba9f@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib wrote:
> Hello guys, this patch removes an extra checking over 'cs' in
> functions 'guarantee_online_cpus' and 'guarantee_online_mems'.
> ...
> -	while (cs && !cpus_intersects(cs->cpus_allowed, cpu_online_map))
> -		cs = cs->parent;
> -	if (cs)
> +	if (cs) {
> +		while (!cpus_intersects(cs->cpus_allowed, cpu_online_map))
> +			cs = cs->parent;

I don't think that works - "cs->parent" can be NULL, and will be NULL
if cs is the root cpuset.

So we must check for non-NULL cs each step of the way back up the
cpuset tree.

I must NAQ this patch.

Holler if you think I'm missing something.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
