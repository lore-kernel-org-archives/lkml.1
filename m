Return-Path: <linux-kernel-owner+w=401wt.eu-S1030339AbXCFSxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339AbXCFSxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966004AbXCFSxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:53:23 -0500
Received: from terminus.zytor.com ([192.83.249.54]:59832 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966008AbXCFSxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:53:20 -0500
Message-ID: <45EDB82F.8030803@zytor.com>
Date: Tue, 06 Mar 2007 10:51:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() [try #2]
References: <45EDB568.1090008@zytor.com>  <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com> <11476.1173206866@redhat.com>
In-Reply-To: <11476.1173206866@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Why not just make it ((n) < 1 ? 0 : ...) and make it well-defined for
>> n == 0?
> 
> Because log2(0) is -INF or mathematically undefined or something isn't it?

Yes, but it's a *rounding up* function.  In this case, it makes sense to 
round up 0 to 1.  This is, in fact, a common way to handle requests for 
zero-byte allocation in order to be able to return a unique address for 
each one, so it's not a spurious thing.

	-hpa
