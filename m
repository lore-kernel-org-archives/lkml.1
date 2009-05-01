Return-Path: <linux-kernel-owner+w=401wt.eu-S1765277AbZEAUTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765277AbZEAUTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761618AbZEAUSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:18:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50593 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbZEAUSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:18:52 -0400
Message-ID: <49FB58F7.8080109@redhat.com>
Date: Fri, 01 May 2009 13:17:59 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export softirq_to_name symbol
References: <20090501193022.GB3111@redhat.com> <20090501195015.GA31694@infradead.org> <49FB5686.8020908@redhat.com> <20090501201028.GA2084@infradead.org>
In-Reply-To: <20090501201028.GA2084@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2009 01:10 PM, Christoph Hellwig wrote:
> On Fri, May 01, 2009 at 01:07:34PM -0700, Josh Stone wrote:
>> I'm adding SystemTap support for the format strings in the TRACE_EVENT
>> macros.  The softirq's TP_fast_assign uses softirq_to_name, and so that
>> array is needed to prepare the softirq's trace string.
>>
>> So, there's no explicit reference to the symbol in SystemTap -- it's
>> just indirectly referenced by the tracepoint declaration.
> 
> TP_fast_assign should only be called by core code, it's the piece that
> copies the trace into the ring buffer.  If systemtap copies events into
> the ring buffer from modular code something is deeply wrong in it's
> design.

More precisely, it's the piece of code that copies the trace into an
__entry pointer.  In my case, __entry has nothing to do with the ring
buffer.

Josh
