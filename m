Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZEaCPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZEaCPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 22:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZEaCPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 22:15:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58252 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbZEaCPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 22:15:44 -0400
Message-ID: <4A21E816.4050203@redhat.com>
Date: Sat, 30 May 2009 22:14:46 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: "Larry H." <research@subreption.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Use kzfree in mac80211 key handling to enforce data	sanitization
References: <20090531015801.GB8941@oblivion.subreption.com>
In-Reply-To: <20090531015801.GB8941@oblivion.subreption.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry H. wrote:
> [PATCH] Use kzfree in mac80211 key handling to enforce data sanitization
> 
> This patch replaces the kfree() calls within the mac80211 WEP RC4 key
> handling and ieee80211 management APIs with kzfree(), to enforce
> sanitization of the key buffer contents.
> 
> This prevents the keys from persisting on memory, potentially
> leaking to other kernel users after re-allocation of the memory by
> the LIFO allocators, or in coldboot attack scenarios. Information can be
> leaked as well due to use of uninitialized variables, or other bugs.
> 
> This patch doesn't affect fastpaths.

This seems to be essentially what Ingo proposed.

Clearing out a buffer that held a wifi key on free
makes sense, even for systems that are not in
paranoid mode.

> Signed-off-by: Larry Highsmith <research@subreption.com>

Acked-by: Rik van Riiel <riel@redhat.com>

-- 
All rights reversed.
