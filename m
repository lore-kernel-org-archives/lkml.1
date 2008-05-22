Return-Path: <linux-kernel-owner+w=401wt.eu-S935123AbYEVIZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123AbYEVIZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbYEVIY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:24:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57989 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751187AbYEVIYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:24:55 -0400
Date: Thu, 22 May 2008 03:24:56 -0500
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove unnecessary memmove() in cgroup_path()
Message-Id: <20080522032456.21b805a4.pj@sgi.com>
In-Reply-To: <20080522030324.2b650f93.pj@sgi.com>
References: <48352127.20804@cn.fujitsu.com>
	<20080522030324.2b650f93.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more question ... how does the kernel text size (size vmlinux)
change with this patch?

It may well be that the kernel gets a few bytes -larger-, rather than
smaller, due to the extra instructions involved in manipulating the
more indirect buffer pointer and in tracking the value of that pointer
on cgroup_path() entry separately from the value on return.

If that's the case, then the net performance impact of this patch might
be negative, depending on how one measures it.  Given the increasingly
high costs of cache misses on modern CPU architectures, it is often
better to execute a few additional instructions that are likely already
in the cache (as 'memmove()' might be) than to increase the kernel text
size with rarely executed code lines that will (1) miss the cache more
often, even though (2) they consume fewer CPU cycles to execute.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
