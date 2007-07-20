Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXGTFIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXGTFIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXGTFIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:08:04 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:37660 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750886AbXGTFIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:08:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=XvJ6Glm5236eGFSySwTDb/zPjEOUrUKiWvTb7jEjCq5wwu/sbh/Ue15BPknYugzqG16eV/eG35c14IG5BTiwbmlDHZqJ/L1ymAEfj5oUkv+gFqZRWGi2wz6lgoNG0IJ5jfM2jYcYmEncSsLZei7pD96IyKQ8SU8orGX4aVNvTkI=  ;
X-YMail-OSG: xQfiVF0VM1lPJ2uvKXRUWxLrd2pdlKPe.uxyDscRjxXX3kT2Cy43o03avsQ43H9GUA2YRuJSNQ--
Message-ID: <46A0432C.8090207@yahoo.com.au>
Date: Fri, 20 Jul 2007 15:07:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock (cmpxchg8b)
References: <200707191154.642492000@suse.de> <20070719095459.E60AD14E11@wotan.suse.de> <1184863904.6458.17.camel@dhcp193.mvista.com> <20070720031105.GA8237@Krystal> <20070720034757.GA9093@Krystal> <20070720041839.GA11217@Krystal>
In-Reply-To: <20070720041839.GA11217@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:

> I tried it with and without the LOCK prefix on my Pentium 4.
> 
> Locked cmpxchg8b : 90 cycles
> Non locked cmpxchg8b: 30 cycles
> sti: 166 cycles
> cli: 159 cycles
> 
> So, hrm, even if we use the locked version, it is still much faster than
> the sti/cli. I am thoughtful about the comment in asm-i386/system.h:

Curious: what does it look like if the memory is not in cache? I
found that cmpxchg is relatively slower than other rmw instructions
in that case.

-- 
SUSE Labs, Novell Inc.
