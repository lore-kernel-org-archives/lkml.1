Return-Path: <linux-kernel-owner+w=401wt.eu-S1764003AbYECRST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764003AbYECRST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761431AbYECRSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:18:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761237AbYECRSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:18:05 -0400
Date: Sat, 3 May 2008 10:16:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
cc: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
In-Reply-To: <20080503070318.GR8474@1wt.eu>
Message-ID: <alpine.LFD.1.10.0805031014300.5994@woody.linux-foundation.org>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org> <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org> <20080502213146.GD24080@logfs.org>
 <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org> <20080502215833.GG24080@logfs.org> <20080503070318.GR8474@1wt.eu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 May 2008, Willy Tarreau wrote:
> 
> Why not merge it and mark it experimental then ? In fact, this is about
> what you're looking for : reduced merge hassle and more testers.

The real issue for me wrt a filesystem is the on-disk layout.

If we know that on-disk structures need change, we shouldn't merge it. It 
doesn't matter if that can be worked around with some backwards- 
compatibiltiy flag: we should simply not encourage that kind of behaviour. 
It would be much much better to just get a layout that is as final as 
possible and avoid the "there are two different formats, because the first 
format was known to be broken" issue.

Will extensions happen and add features anyway? Probably. But that's 
different from merging something knowing that the on-disk format will 
change.

		Linus
