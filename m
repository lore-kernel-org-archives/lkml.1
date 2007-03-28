Return-Path: <linux-kernel-owner+w=401wt.eu-S965760AbXC1USY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965760AbXC1USY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965763AbXC1USY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:18:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:16569 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965760AbXC1USX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:18:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=ZHk6phd3N+GpAbQHM3SBLydCowkB+iMq/cxm+zeSO70TCPl9sX7jBUDfYf9hSR4+S
	UCTmc9Nw4vSxo7m2p4v+g==
Message-ID: <460ACCD8.2030006@google.com>
Date: Wed, 28 Mar 2007 13:15:20 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>	<1173718208.11945.54.camel@localhost.localdomain>	<20070312235452.GB11578@MAIL.13thfloor.at> <m1veh5sbwy.fsf@ebiederm.dsl.xmission.com> <45F67C2D.7020303@yahoo.com.au>
In-Reply-To: <45F67C2D.7020303@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Eric W. Biederman wrote:
>> First touch page ownership does not guarantee give me anything useful
>> for knowing if I can run my application or not.  Because of page
>> sharing my application might run inside the rss limit only because
>> I got lucky and happened to share a lot of pages with another running
>> application.  If the next I run and it isn't running my application
>> will fail.  That is ridiculous.
>
> Let's be practical here, what you're asking is basically impossible.
>
> Unless by deterministic you mean that it never enters the a non
> trivial syscall, in which case, you just want to know about maximum
> RSS of the process, which we already account).

    If we used Beancounters as Pavel and Kirill mentioned, that would 
keep track of each container that has referenced a page, not just the 
first container. It sounds like beancounters can return a usage count 
where each page is divided by the number of referencing containers (e.g. 
1/3rd if 3 containers share a page). Presumably it could also return a 
full count of 1 to each container.

    If we look at data in the latter form, i.e. each container must pay 
fully for each page used, then Eric could use that to determine real 
usage needs of the container. However we could also use the fractional 
count in order to do things such as charging the container for its 
actual usage. i.e. full count for setting guarantees, fractional for 
actual usage.
    -- Ethan

