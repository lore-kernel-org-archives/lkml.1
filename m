Return-Path: <linux-kernel-owner+w=401wt.eu-S2992651AbXDDFq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992651AbXDDFq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992655AbXDDFq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:46:57 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:54753 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992651AbXDDFq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:46:57 -0400
Message-ID: <46133BBC.5000303@cosmosbay.com>
Date: Wed, 04 Apr 2007 07:46:36 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com> <4612F1F0.5070209@zytor.com> <4612F2BF.7080704@goop.org> <4612F394.6040105@zytor.com> <4613330C.1020701@cosmosbay.com> <461334B5.7070607@zytor.com> <46133609.9060402@goop.org> <46133A5F.5000100@zytor.com>
In-Reply-To: <46133A5F.5000100@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 04 Apr 2007 07:46:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin a écrit :
> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> Mutable data should be separated from code.  I think any current CPU
>>> will do fine as long as they are in separate 128-byte chunks, but they
>>> need at least that much separation.
>> P4 manual says that if one processor modifies data within 2k of another
>> processor executing code, it will trash the entire trace cache.
> 
> Yuck.  Didn't realize the P4 was that sensitive.  OK, so at the least we 
> need a half-page of separation.

Yes but vsyscall API currently defines 4 entry points :

vsyscall0 (vgettimeofday) = ADDR
vsyscall1 (vtime)    = ADDR+1024
vsyscall2 (vgetcpu) = ADDR+2048
vsyscall3 (vxxxxx)  = ADDR+3072

