Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbXFYHT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbXFYHT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbXFYHTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:19:49 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:37602 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752383AbXFYHTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:19:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=3AW+EQu9ffr1ld8FQIALDiNqzXRZRtcDiBRV3a9QimjUtrwcifVKbEBhHyozOouJg4963o5AFDO+DhN2utXCT4ZPZgl2gJNc+1aMogLp0nBEZwFDxw+mTcINxVAu3BqvDGnWLRHCczy0E2H9ZILYhTeAtRH3RpZjfbja5TkAnXo=  ;
X-YMail-OSG: AK6mT8IVM1niHyTXxKmmhW6JEGCqw3Jps3.S5MnNHiAL0JvbHQXd09ruUy0meB3G34K3RRtWgA--
Message-ID: <467F6C8F.9040400@yahoo.com.au>
Date: Mon, 25 Jun 2007 17:19:43 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
References: <20070624014528.GA17609@wotan.suse.de>	<20070624014613.GB17609@wotan.suse.de> <p73fy4h5q3c.fsf@bingen.suse.de>
In-Reply-To: <p73fy4h5q3c.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> 
> [haven't read everything, just commenting on something that caught my eye]
> 
> 
>>+struct fsblock {
>>+	atomic_t	count;
>>+	union {
>>+		struct {
>>+			unsigned long	flags; /* XXX: flags could be int for better packing */
> 
> 
> int is not supported by many architectures, but works on x86 at least.

Yeah, that would be nice. We could actually use this for buffer_head as well,
but saving 4% there isn't so important as saving 20% for fsblock :)


> Hmm, could define a macro DECLARE_ATOMIC_BITMAP(maxbit) that expands to the smallest
> possible type for each architecture. And a couple of ugly casts for set_bit et.al.
> but those could be also hidden in macros. Should be relatively easy to do.

Cool. It would probably be useful for other things as well.

-- 
SUSE Labs, Novell Inc.
