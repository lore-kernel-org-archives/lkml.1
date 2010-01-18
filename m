Return-Path: <linux-kernel-owner+w=401wt.eu-S1751715Ab0ARBcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab0ARBcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380Ab0ARBcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:32:54 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:40424 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0ARBcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 20:32:53 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
       <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos
References: <20100115013954.311049665@intel.com>
	<20100115014422.959401729@intel.com>
	<87bpgurz00.fsf@devron.myhome.or.jp>
	<20100118091527.7a0e2c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwnrcz.fsf@devron.myhome.or.jp>
Date: Mon, 18 Jan 2010 10:32:49 +0900
In-Reply-To: <87y6jwnrcz.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 18 Jan 2010 10:17:48 +0900")
Message-ID: <873a24mc3i.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>>> Um... How do lseek() work? It sounds like to violate error code range.
>>
>> This is for read-write. As far as I know, 
>>   - generic_file_llseek,
>>   - default_llseek
>>   - no_llseek
>>
>> doesn't call this function. 
>
> It seems to allow to set negative value to ->f_pos, right? So, lseek()
> returns (uses) it?

BTW, another concern by negative "pos" value is, the following like code

	pos >> shift_bits

it will break the above. So, I think it should be checked if not yet.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
