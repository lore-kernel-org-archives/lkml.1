Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0CDU6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:58:01 -0500
Received: from smtp-out.google.com ([216.239.33.17]:25843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab0CDU57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:57:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=hW5wG6JzrUo6vccB21e5yk0VIFwDO58Saz/+dvDtNo7rrIXOo00ZG4XR3p+o6ZlGO
	quuUapcK6W/og3EwL7GBA==
MIME-Version: 1.0
In-Reply-To: <1267734205.16716.4.camel@laptop>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.451251096@chello.nl>
	 <bd4cb8901003031357x9c13c96h3899ab0459a34b0e@mail.gmail.com>
	 <1267693107.25158.149.camel@laptop>
	 <bd4cb8901003040954n5b05e139wa24f8e50789421ac@mail.gmail.com>
	 <1267726733.25158.219.camel@laptop> <1267734205.16716.4.camel@laptop>
Date: Thu, 4 Mar 2010 12:57:55 -0800
Message-ID: <bd4cb8901003041257l2ef59117kcd9c65b237283086@mail.gmail.com>
Subject: Re: [RFC][PATCH 08/11] perf, x86: Implement simple LBR support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 12:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-03-04 at 19:18 +0100, Peter Zijlstra wrote:
>> What is currently implemented is that we loose history at the point a
>> new task schedules in an LBR using event.
>>
> This also matches CPU errata AX14, AJ52 and AAK109 which states that a
> task switch may produce faulty LBR state, so clearing history after a
> task switch seems the best thing to do.
>
>
You would save the LBR before the task switch and restore after the
task switch, so I don't see how you would be impacted by this. You
would not pick up the bogus LBR content.

Given that you seem to be interested only in LBR at the user level.
I think what you have right now should work. But I don't like a design
that precludes supporting LBR config regardless of the fact the MSR
is shared or not, because that is preventing some interesting
measurements.
