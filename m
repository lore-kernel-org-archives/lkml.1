Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbYGRXhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbYGRXhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYGRXhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:37:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbYGRXha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:37:30 -0400
Message-ID: <48812902.5070003@zytor.com>
Date: Fri, 18 Jul 2008 16:36:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH ftrace.git] Immedate Values Optimized Jump Fix
References: <20080717031721.GA24504@Krystal> <20080718161523.GY6875@elte.hu> <20080718183124.GA31768@Krystal> <4880F410.3090804@zytor.com> <20080718211205.GA5423@Krystal>
In-Reply-To: <20080718211205.GA5423@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Hrm, I thought that by following the execution flow to both branches and
> by looking at the code pattern found (load immediate, test, branch) and
> by placing a constraint on the eax register to detect the liveliness
> region of that variable we would be guaranteed that the compiler could
> not re-use this variable outside of the pattern scope.
> 

Nope, and you *cannot* allow such registers to be live *anywhere* the C 
compiler is generating code, even between two asm() statements with 
nothing in between.

	-hpa
