Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZHFBQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZHFBQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbZHFBQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:16:07 -0400
Received: from [222.73.24.84] ([222.73.24.84]:61252 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZHFBQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:16:06 -0400
Message-ID: <4A7A2E73.7030403@cn.fujitsu.com>
Date: Thu, 06 Aug 2009 09:14:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 4/5] tracing/filters: Provide basic regex support
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-5-git-send-email-fweisbec@gmail.com> <4A76782E.4030803@cn.fujitsu.com> <20090805224709.GH5025@nowhere>
In-Reply-To: <20090805224709.GH5025@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Aug 03, 2009 at 01:39:58PM +0800, Li Zefan wrote:
>> Frederic Weisbecker wrote:
>>> This patch provides basic support for regular expressions in filters.
>>> The common filter file doesn't support any regex but a new
>>> filter_regex file is created for each subsystem/event.
>>>
>>> It supports the following types of regexp:
>>>
>>> - *match_beginning
>>> - *match_middle*
>>> - match_end*
>>> - !don't match
>>>
>> I don't see why adding "filter_regex" is necessary, why not just make
>> "filter" support regex?
> 
> I did that because I feared about people beeing unable to filter using
> * as a real character inside a filter string.
> If we are using only one file, we are forced to get the '*' interpreted.
> That would also break the ABI.
> 

I think we don't maintain stable ABI for debugfs and we've been changing
the "ABI" in debugfs/tracing/, but of course we shouldn't change it
without good reasons.

One alternative is to use '"' to prevent '*' to be translated, but seems
using "filter_regex" is more convenient, so I agree with this patch.

