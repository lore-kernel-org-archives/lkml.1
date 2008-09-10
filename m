Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYIJDbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYIJDbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYIJDbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:31:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYIJDbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:31:23 -0400
Message-ID: <48C73EB8.8020405@zytor.com>
Date: Tue, 09 Sep 2008 20:27:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: heukelum@fastmail.fm
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Subject: Re: [RFC/PATCH] i386: handle all exceptions with interrupts off initially
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
In-Reply-To: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

heukelum@fastmail.fm wrote:
> From: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> x86_64 handles all exceptions with interrupts off initially, this
> bisectable patch set does the same for i386, in (very) small steps.
> If this is acceptable, it would make further unification of traps_32.c
> and traps_64.c a lot easier. If it is not... why?
> 

The only reason not to is that one generally doesn't want to disable 
interrupts unless necessary (bad for latency.)  On 64 bits there are 
stack switches which make disabling interrupts mandatory.  The only 
pitfall is if there is any code which is likely to take time, but I 
highly doubt it.

In other words, it's not something we want to do "just because", but to 
the extent that it provides real benefit, it makes sense.

	-hpa
