Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXDMIwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXDMIwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXDMIwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:52:36 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:32722 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753253AbXDMIwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:52:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=fDj5GNaVt6xKG066g/22sEXk0jVHcqC/uqJKrGU48ws18XCrrqAenrJeJBkcQOmoU4NU8fDHv/UXUNZKhMMamrxP67XGlXVEY4re54VUAO8ffkxCwjH79ZN9qY8YdCQc9pt2Mpji74EycWqGtdV3lIEcd+TzyCx9C+MsAZvHITY=  ;
X-YMail-OSG: OF_feacVM1k1qU1Xw7UKpk7ecFAqIOq8kGNuqdF6PbASigw8c5SKHN429b4V.MiPWB8IreZnyQ--
Message-ID: <461F44BF.9030803@yahoo.com.au>
Date: Fri, 13 Apr 2007 18:52:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andreas Gruenbacher <agruen@suse.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [AppArmor 37/41] AppArmor: Main Part
References: <20070412090809.917795000@suse.de> <20070412090848.752885000@suse.de> <20070412113723.2ec7e4f0@the-village.bc.nu> <200704131048.17846.agruen@suse.de>
In-Reply-To: <200704131048.17846.agruen@suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher wrote:
> On Thursday 12 April 2007 12:37, Alan Cox wrote:
> 
>>>+		if (PTR_ERR(sa->name) == -ENOENT && (check & AA_CHECK_FD))
>>>+			denied_mask = 0;
>>
>>Now there is an interesting question. Is PTR_ERR() safe for kernel
>>pointers on all platforms or just for user ones ?
> 
> 
> It's used for kernel pointers all over the place and mmap also mixes user 
> addresses with -Exxx, so it's definitely supposed to work. I'm not sure how 
> exactly the topmost page is kept from getting mapped.

Yeah, the comments indicate it was first used for dentries.

I wonder if it shouldn't be using the NULL page instead? (ie 0-4095)

-- 
SUSE Labs, Novell Inc.
