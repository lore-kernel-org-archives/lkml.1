Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZEGDuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZEGDuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZEGDuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:50:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59305 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZEGDuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:50:24 -0400
Message-ID: <4A025AB6.6070109@cn.fujitsu.com>
Date: Thu, 07 May 2009 11:51:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/7] tracing: reset ring buffer when removing modules
 with events
References: <20090507031335.815354104@goodmis.org> <20090507031434.586509269@goodmis.org>
In-Reply-To: <20090507031434.586509269@goodmis.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Li Zefan found that there's a race using the event ids of events and
> modules. When a module is loaded, an event id is incremented. We only
> have 16 bits for event ids (65536) and there is a possible (but highly
> unlikely) race that we could load and unload a module that registers
> events so many times that the event id counter overflows.
> 
> When it overflows, it then restarts and goes looking for available
> ids. An id is available if it was added by a module and released.
> 
> The race is if you have one module add an id, and then is removed.
> Another module loaded can use that same event id. But if the old module
> still had events in the ring buffer, the new module's call back would
> get bogus data.  At best (and most likely) the output would just be
> garbage. But if the module for some reason used pointers (not recommended)
> then this could potentially crash.
> 
> The safest thing to do is just reset the ring buffer if a module that
> registered events is removed.
> 
> [ Impact: prevent unpredictable results of event id overflows ]
> 
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> LKML-Reference: <49FEAFD0.30106@cn.fujitsu.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

