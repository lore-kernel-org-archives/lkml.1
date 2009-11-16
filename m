Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZKPA5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZKPA5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZKPA5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:57:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58192 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZKPA5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:57:11 -0500
Message-ID: <4B00A335.9070900@cn.fujitsu.com>
Date: Mon, 16 Nov 2009 08:56:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
References: <20091025225342.007138f5@infradead.org>	<4AFA2293.5080803@cn.fujitsu.com> <20091115110043.6cafc221@infradead.org>
In-Reply-To: <20091115110043.6cafc221@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 11 Nov 2009 10:33:55 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>> This will leave __entry->comm, __entry->file and __entry->dev
>> uninitialized in the "else" case..
> 
> I would expect the struct to be zeroed before.... is it?
> (the TP_ stuff is so obscure I find it hard to figure out where it ends
> up)
> 

No, it won't. Ring buffer won't zero the buffer before returning it,
and TP_ stuff won't zero the buffer after getting it.

See static void ftrace_raw_event_##call(proto) in include/event/ftrace.h

