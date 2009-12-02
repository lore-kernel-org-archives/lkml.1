Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbZLBLLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbZLBLLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZLBLLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:11:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42918 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZLBLLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:11:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=neirYQwXPEQpDJ/SiujFYOVosat5spC21yUe3porKjjkmkezL80OhdKTuYuEHdPiE+
         0aZioIQSC+vagfloyJbHs1wo7O5TmInOj9hPJhSTaSMlScuuIIczGwzkWUlxNWX5iJ4G
         T+GUHTkgY9iXf6ZT2JBfvn5SNFGmiqnzrboG4=
Message-ID: <4B164B51.6040203@tuffmail.co.uk>
Date: Wed, 02 Dec 2009 11:11:13 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Bisected: s2disk (uswsusp only) hangs just before poweroff
References: <4B1575AC.6080904@tuffmail.co.uk> <20091201214529.GA1457@csn.ul.ie>
In-Reply-To: <20091201214529.GA1457@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Tue, Dec 01, 2009 at 07:59:40PM +0000, Alan Jenkins wrote:
>   
>> Hi
>>
>> Suspend to disk is (sometimes) hanging for me in 2.6.32-rc.  I finally  
>> got around to bisecting it, which blamed the following commit by Mel:
>>
>> 5f8dcc2 "page-allocator: split per-cpu list into one-list-per-migrate-type"
>>
>> I was able to confirm this by reverting the commit, which fixed the  
>> hang.  I had to revert one other commit first to avoid a conflict:
>>
>> a6f9edd "page-allocator: maintain rolling count of pages to free from  
>> the PCP"
>>
>>     
>
> Which RC kernel? Specifically, are the commits
>
> cc4a6851466039a8a688c843962a05689059ff3b always wake kswapd when restarting an allocation attempt
> 9d0ed60fe9cd1fbf57f755cd27a23ae9114d7210 Do not allow interrupts to use ALLOC_HARDER
>
> applied?
>
> The latter one in particular might make a difference if s2disk is
> pushing the system far below the watermarks. I don't suppose you know
> where it's hanging? i.e. is it hanging in the allocator itself?
>   

After enabling "suspend loglevel = 8" in uswsusp.conf (grr), I saw a 
pair of hung task backtraces.

<http://picasaweb.google.com/Alan.Christopher.Jenkins/Screenshots#5410594126006567282>


> would you mind trying the following patch?
> Unfortunately, it's totally untested. The intention of the patch is to
> use other PCP lists if the desired one cannot be refilled.
>
> Thanks.
>   

Sure, will do.

Thanks
Alan
