Return-Path: <linux-kernel-owner+w=401wt.eu-S1761404AbXEQGjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404AbXEQGjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEQGjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:39:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50129 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752277AbXEQGjl (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:39:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@sgi.com>
To: Bernardo Innocenti <bernie@codewiz.org>
cc: Jordan Crouse <jordan.crouse@amd.com>, kdb@oss.sgi.com,
       linux-kernel@vger.kernel.org, devel@laptop.org
Subject: Re: kdb: add rdmsr and wrmsr commands for i386 
In-reply-to: Your message of "Thu, 17 May 2007 02:36:21 -0400."
             <464BF7E5.4080105@codewiz.org> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 17 May 2007 16:39:35 +1000
Message-ID: <7803.1179383975@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernardo Innocenti (on Thu, 17 May 2007 02:36:21 -0400) wrote:
>Keith Owens wrote:
>
>> Before using MSR, you must first check that the cpu supports the
>> instruction, rd/wrmsr cause an oops on 486 or earlier.  Also using an
>> invalid msr number causes an oops, so use rd/wrmsr_safe().
>
>I didn't bother implementing those checks because kdb recovers
>nicely from GPF anyway.

Yes and no.  Yes, kdb will recover from a GPF.  No, because if the
system was already running correctly (i.e. manual entry into kdb), then
taking a GPF and not recovering will flag the rest of the system as
corrupt and can kill a running system.  I try to avoid adding spurious
system corruption.

>It's the valid MSR writes that could
>cause unrecoveable problems! :)

Tell me about it :-(

