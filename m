Return-Path: <linux-kernel-owner+w=401wt.eu-S2992594AbXDDFSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992594AbXDDFSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992631AbXDDFSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:18:33 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992594AbXDDFSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:18:32 -0400
Message-ID: <461334B5.7070607@zytor.com>
Date: Tue, 03 Apr 2007 22:16:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com> <4612F1F0.5070209@zytor.com> <4612F2BF.7080704@goop.org> <4612F394.6040105@zytor.com> <4613330C.1020701@cosmosbay.com>
In-Reply-To: <4613330C.1020701@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> 
> There is one thing that always worried me.
> 
> Intel & AMD manuals make clear that mixing data and program in the same 
> page is bad for performance.
> 
> In particular, x86_64 vsyscall put jiffies and other 
> vsyscall_gtod_data_t right in the midle of code. That is certainly not 
> wise.
> 
> A probably sane implementation should use two pages, one for code, one 
> for data.
> 

Mutable data should be separated from code.  I think any current CPU 
will do fine as long as they are in separate 128-byte chunks, but they 
need at least that much separation.

Readonly data does not need to be separated from code.

	-hpa
