Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZH1Qdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZH1Qdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZH1Qdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:33:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZH1Qdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:33:40 -0400
Message-ID: <4A9806D9.5050409@redhat.com>
Date: Fri, 28 Aug 2009 09:33:29 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
References: <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org>
In-Reply-To: <20090828161745.GA8755@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2009 09:17 AM, Christoph Hellwig wrote:
> I'll put it on my todo list.

Any ABI change like this takes a long time to trickle down.

If this is agreed to be the correct approach then adding the O_* 
definitions earlier is better.  Even if it isn't yet implemented.  Then, 
once the kernel side is implemented, programs are ready to use it.  I 
cannot jump the gun and define the flags myself first.


>   - O_RSYNC basically means we need to commit atime updates before a
>     read returns, right?

No, that's not it.

O_RSYNC on its own just means the data is successfully transferred to 
the calling process (always the case).

O_RSYNC|O_DSYNC means that if a read request hits data that is currently 
in a cache and not yet on the medium, then the write to medium is 
successful before the read succeeds.

O_RSYNC|O_SYNC means the same plus the integrity of file meta 
information (access time etc).

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
