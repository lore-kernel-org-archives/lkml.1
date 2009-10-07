Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZJGPgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZJGPgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZJGPgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZJGPgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:36:09 -0400
Message-ID: <4ACCB52D.3020104@redhat.com>
Date: Wed, 07 Oct 2009 08:35:09 -0700
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, mhiramat@redhat.com
Subject: Re: [PATCH 0/4] jump label patches
References: <cover.1253831945.git.jbaron@redhat.com>	<20091006053915.D9D0928@magilla.sf.frob.com>	<4ACBD1BF.30201@redhat.com> <20091007001436.B5FE9A8C@magilla.sf.frob.com>
In-Reply-To: <20091007001436.B5FE9A8C@magilla.sf.frob.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 05:14 PM, Roland McGrath wrote:
> Kernel builds usually use -Os.  Is there anything else we can do now (4.4)
> to influence this placement (while keeping the unlikely target block inside
> a scope, i.e. macro, with the asm goto)?

I think -Os includes -freorder-blocks as well.

> 	      if (0) yes: maybe = 1;

Anything with "if (0)" in it (even with __builtin_expect) is going to be 
folded away too early to be useful.

I can't think of any way to manipulate block placement from the source 
level at this time that doesn't add more code along the fast path, 
obviating the asm goto.


r~
