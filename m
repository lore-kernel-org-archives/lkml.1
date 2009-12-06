Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbZLFIkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbZLFIkC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:40:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZLFIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 03:39:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59075 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbZLFIjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 03:39:54 -0500
Date: Sun, 6 Dec 2009 08:39:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, stewb@linux-foundation.org
Subject: Re: [RFC 0/5] pathconf(3) with _PC_LINK_MAX
Message-ID: <20091206083958.GC14381@ZenIV.linux.org.uk>
References: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 04:58:58PM +0900, J. R. Okajima wrote:
> The pathconf(_PC_LINK_MAX) cannot get the correct value, since linux
> kernel doesn't provide such interface. And the current implementation in
> GLibc issues statfs(2) first and then returns the predefined value
> (EXT2_LINK_MAX, etc) based upoin the filesystem type. But GLibc doesn't
> support all filesystem types. ie. when the target filesystem is unknown
> to pathconf(3), it will return LINUX_LINK_MAX (127).
> For GLibc, there is no way except implementing this poor method.
> 
> This patch makes statfs(2) return the correct value via struct
> statfs.f_spare[0].

Um...  Why do we need that, again?  Note that there is no way whatsoever
for predicting whether link(2) will fail due to having too many existing
links before you attempt the call - links can be created or removed between
stat(2) and link(2).  So any uses of that value are heuristical.

Can you actually show any use cases of that thing?  Preferably - in existing
code, but even a theoretical one would be interesting.
