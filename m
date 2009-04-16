Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZDPAxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZDPAxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZDPAx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:53:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZDPAx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:53:26 -0400
Message-ID: <49E681B5.8070505@cn.fujitsu.com>
Date: Thu, 16 Apr 2009 08:54:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
References: <1239610670.6660.49.camel@tropicana> <20090414205635.GA5968@nowhere> <1239769945.7852.21.camel@tropicana> <20090415162151.GH5989@nowhere>
In-Reply-To: <20090415162151.GH5989@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
>>> Also, is filter_add_pred() supposed to be available for in-kernel
>>> uses by other tracers or something?
>> No, the current callers were the only ones I'd planned on (it's not
>> static because code in trace_events.c needs to call it).  But, do you
>> see a use for it by other tracers?
> 
> 
> 
> May be in the future, it's possible that a tracer might want to
> set filters by itself.
> But I don't think it has to be fixed now because there are nothing
> like that for now.
> 
> So, no problem :-)
> 

If we restricted the mutex in trace_events_filters.c only, all the
extern functions can be called without lock, and this is what I did
in my previous patch.

>  
>>> If this is planned, the locking could be even deeper than my comments.

