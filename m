Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXGYFhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXGYFhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbXGYFho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:37:44 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:42525 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751320AbXGYFhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:37:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=LZh/TDI081bYcUyDw8HntQQyN4Mn9oRNBaSzbWw9BB9OnYuHOiysO/YliGl+ze+iNrCc1eYwu/7smTFteb+LJwt/EFR4wJQwY3pnDaE9WAD7HzPFEjMAlkc231YHx/wFDmnRwCav80ympqpk1eLM1oYv46Epad1NZ23yWebynkU=  ;
X-YMail-OSG: 9wTopToVM1no22ocWtQM_VfHwsnj2EhmKyQvRI2xqf0u215k9bB_XBC9NgwrjfTxIXPUDyOAzA--
Message-ID: <46A6E1A1.4010508@yahoo.com.au>
Date: Wed, 25 Jul 2007 15:37:37 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric St-Laurent <ericstl34@sympatico.ca>
CC: Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46A57068.3070701@yahoo.com.au>	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	 <46A58B49.3050508@yahoo.com.au>	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	 <46A6CC56.6040307@yahoo.com.au>  <46A6D7D2.4050708@gmail.com> <1185341449.7105.53.camel@perkele>
In-Reply-To: <1185341449.7105.53.camel@perkele>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric St-Laurent wrote:
> On Wed, 2007-25-07 at 06:55 +0200, Rene Herman wrote:
> 
> 
>>It certainly doesn't run for me ever. Always kind of a "that's not the 
>>point" comment but I just keep wondering whenever I see anyone complain 
>>about updatedb why the _hell_ they are running it in the first place. If 
>>anyone who never uses "locate" for anything simply disable updatedb, the 
>>problem will for a large part be solved.
>>
>>This not just meant as a cheap comment; while I can think of a few similar 
>>loads even on the desktop (scanning a browser cache, a media player indexing 
>>a large amount of media files, ...) I've never heard of problems _other_ 
>>than updatedb. So just junk that crap and be happy.
> 
> 
>>From my POV there's two different problems discussed recently:
> 
> - updatedb type of workloads that add tons of inodes and dentries in the
> slab caches which of course use the pagecache.
> 
> - streaming large files (read or copying) that fill the pagecache with
> useless used-once data
> 
> swap prefetch fix the first case, drop-behind fix the second case.

OK, this is where I start to worry. Swap prefetch AFAIKS doesn't fix
the updatedb problem very well, because if updatedb has caused swapout
then it has filled memory, and swap prefetch doesn't run unless there
is free memory (not to mention that updatedb would have paged out other
files as well).

And drop behind doesn't fix your usual problem where you are downloading
from a server, because that is use-once write(2) data which is the
problem. And this readahead-based drop behind also doesn't help if data
you were reading happened to be a sequence of small files, or otherwise
not in good readahead order.

Not to say that neither fix some problems, but for such conceptually
big changes, it should take a little more effort than a constructed test
case and no consideration of the alternatives to get it merged.

-- 
SUSE Labs, Novell Inc.
