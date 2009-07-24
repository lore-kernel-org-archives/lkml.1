Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZGXFqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZGXFqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 01:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZGXFqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 01:46:23 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:48864 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZGXFqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 01:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iaK9GbyZu8vyDUnyDqAaaQQC5tMDvTC4zcBRP5uHQ1UMSbBbdrah+3TgwIzc1N/qJ0
         tcpK+jP/RYLGrIOeHnFXC9DwP80/q+3ayfO6KknBY/q+Nxfh9qrtA0GNWCJBsOCqjozW
         hSAOPD8fWzACAzE4OLXSDQ7Clx04zViMjJMQk=
Message-ID: <4A694AA9.2070009@gmail.com>
Date: Thu, 23 Jul 2009 22:46:17 -0700
From: "Moussa A. Ba" <moussa.a.ba@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       akpm@linux-foundation.org, adobriyan@gmail.com, mel@csn.ul.ie,
       yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com
Subject: Re: [PATCH 0/1] pagemap clear_refs: modify to specify anon or mapped
 vma clearing
References: <4A6930F5.3090008@gmail.com> <1248409807.24185.18.camel@calx>
In-Reply-To: <1248409807.24185.18.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Thu, 2009-07-23 at 20:56 -0700, Moussa A. Ba wrote:
>> This patch makes the clear_refs proc interface a bit more versatile. It 
>> adds support for clearing either anonymous, file mapped pages or both.
>>
>> echo 1 > /proc/pid/clear_refs clears ANON pages
>> echo 2 > /proc/pid/clear_refs clears file mapped pages
>> echo 3 > /proc/pid/clear_refs clears all pages
>>
>> Selectively clearing pages has a measurable impact on performance as it 
>> decreases the number of page walks.  We have been using this interface 
>> and this adds flexibility to the user space application implementing the 
>> reference clearing.
> 
> [adding David, the original instigator of clear_refs)
> 
> First, don't send 0 of 1 messages, especially for a single patch. It
> makes Andrew curse and makes him more likely to consider other
> employment possibilities. Instead incorporate highly useful info like
> the above into your patch instead, preferably as docs and commit
> descriptions.
> 
> Second, depending on how we've documented the behavior of this file,
> this looks like it might break existing tools that are currently writing
> '1' but expecting the behavior of '3'?
> 

Thank you for the kind advice, I was afraid of that...  In regards to 
the behavior of 1 vs 3, this had indeed occurred to us, and it was a 
tossup.  I was hoping to get feedback first before deciding which way to 
go.  However, it does seem like a better idea to go with the default 
behavior when writing '1' and the special behaviors for 2 and 3.


