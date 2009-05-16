Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbZEPJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbZEPJnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbZEPJmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:42:32 -0400
Received: from mail.lang.hm ([64.81.33.126]:33573 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879AbZEPJma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:42:30 -0400
Date: Sat, 16 May 2009 02:42:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Theodore Tso <tytso@mit.edu>
cc: Timo Sirainen <tss@iki.fi>, Josef Bacik <josef@toxicpanda.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ext3/ext4 directories don't shrink after deleting lots of
 files
In-Reply-To: <20090515105815.GD6816@mit.edu>
Message-ID: <alpine.DEB.1.10.0905160241020.26653@asgard>
References: <1242338523.6933.664.camel@timo-desktop> <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com> <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi> <20090515105815.GD6816@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Theodore Tso wrote:

> On Thu, May 14, 2009 at 08:45:38PM -0400, Timo Sirainen wrote:
>>
>> I was rather thinking something that I could run while the system was
>> fully operational. Otherwise just moving the files to a temp directory +
>> rmdir() + rename() would have been fine too.
>>
>> I just tested that xfs, jfs and reiserfs all shrink the directories
>> immediately. Is it more difficult to implement for ext* or has no one
>> else found this to be a problem?
>
> It's probably fairest to say no one has thought it worth the effort.
> It would require some fancy games to swap out block locations in the
> extent trees (life would be easier with non-extent-using inodes), and
> in the case of htree, we would have to keep track of the index block
> so we could remove it from the htree index.  So it's all doable, if a
> bit tricky in terms of the technical details; it's just that the
> people who could do it have been busy enough with other things.
>
> It's hasn't been considered high priority because most of the time
> directories don't go from holding thousands of files down to a small
> handful.

I see it on a fairly regular basis on mail servers. in sendng a large 
queue builds up due to a remote system being down, but then after the 
remote system recovers, all access to that directory is slow, hurting 
everything else on the system.

David Lang
