Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZKKR1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZKKR1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbZKKR1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:27:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:18486 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbZKKR1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:27:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,724,1249282800"; 
   d="scan'208";a="512841471"
Message-ID: <4AFAF3F5.3070409@intel.com>
Date: Wed, 11 Nov 2009 09:27:17 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
References: <20091025225342.007138f5@infradead.org> <20091111020108.GA11423@localhost> <20091110223456.01ef355f@infradead.org> <4AFA6AEF.5060306@garzik.org> <20091111074542.GB25132@elte.hu>
In-Reply-To: <20091111074542.GB25132@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> On 11/11/2009 01:34 AM, Arjan van de Ven wrote:
>>> Wu Fengguang<fengguang.wu@intel.com>  wrote:
>>>> Maybe this is enough for POWERTOP, however for general use, the dirty
>>>> type(data/metadata) and inode number may be valuable to some users?
>>> what can a user do with an inode number????
>> Inode numbers have always been visible to userspace...  IIRC, tar(1) 
>> uses the st_ino member of struct stat to detect hard links in certain 
>> cases.  ls(1) displays inode numbers with -i, find(1) looks for them 
>> with -inum, ...
> 
> Without an inode->vfs-name lookup/matching service it's of limited 
> utility though to developers and users. So inode numbers are fine (as 
> nicely unique physical identifiers)- as long as corresponding vfs name 
> string is available too.

agreed, this is the second problem I've stumbled upon (readahead was the first)
that could use something like this.

you can't reliably use inode numbers unless you actually know all of them at the
time that the tracepoint is generated: they could be deleted, modified etc. An
inode number is nice, but the filename and blockdev info would be superior for
both problems we're trying to solve.

Auke


