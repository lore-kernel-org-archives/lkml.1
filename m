Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbYHDTqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbYHDTqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbYHDTqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:46:32 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:21093 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754336AbYHDTqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:46:32 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=pLuw79uImaNf5xlBnVsA:9 a=GHYLgw5RUJK8Z30E1M5FQeheS7AA:4 a=FZWOhrf7iYAA:10
Message-ID: <48975C96.9090401@shaw.ca>
Date: Mon, 04 Aug 2008 13:46:30 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bernd Schubert <bs@q-leap.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: sysrq+t doesn't work for some threads
References: <fa.sh1LseUiXeu++640VETUX2tdFMs@ifi.uio.no>
In-Reply-To: <fa.sh1LseUiXeu++640VETUX2tdFMs@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert wrote:
> Hello,
> 
> I need to debug a lustre problem, where lustre threads take 100% cpu time and 
> also have a memory leak. The problem is, that sysrq+t doesn't work for these 
> threads. It nicely shows all stack traces, just the trouble some threads 
> won't show their traces:
> 
> [69338.858825] ll_mdt_36     R  running task       0 21679      2 (L-TLB)

This means this task is running, you won't get a stack trace for such a 
thread. You'd likely have to stop it somehow. Is this a kernel thread?

> [69338.865689] ll_mdt_37     S 0000000000000000     0 21680      2 (L-TLB)
> [69338.872676]  ffff8102e6d01dd0 0000000000000046 ffffffff88160325 
> 00000000ffffffed
> [69338.880544]  0000000000000000 ffffffff8815e016 000000000000000a 
> ffff810322ef4ea0
> [69338.888318]  ffff81031e7477b0 00003f0797609cef 000000000003434e 
> ffff810322ef5050
> [69338.895957] Call Trace:
> [69338.898787]  [<ffffffff8828cab5>] :ptlrpc:ptlrpc_main+0xa55/0x1ce0
> [69338.905297]  [<ffffffff8020a2f8>] child_rip+0xa/0x12
> 
> 
> But I really need to have the trace of ll_mdt_36, which is one of the 
> troublesome threads. Might this be a problem of the x86_64-mm-unwinder.patch 
> we always apply since it provides much better traces?
> This is with 2.6.22.19.
> 
> Any help would be appreciated.


