Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZAJWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZAJWJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZAJWJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:09:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZAJWJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:09:08 -0500
Message-ID: <49691C75.2000606@redhat.com>
Date: Sat, 10 Jan 2009 17:08:53 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Scott James Remnant <scott@canonical.com>
CC: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>	 <20090107123457.GB16268@elte.hu>  <20090107171922.GA18000@redhat.com>	 <1231598863.11642.55.camel@quest>  <49690FC9.4010403@redhat.com> <1231622419.11642.197.camel@quest>
In-Reply-To: <1231622419.11642.197.camel@quest>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott James Remnant wrote:
> On Sat, 2009-01-10 at 16:14 -0500, Casey Dahlin wrote:
>
>   
>> From the perspective of waitfd, the only difference between WNOHANG and
>> O_NONBLOCK is which argument you put the flags in. The API should only
>> support one or the other, but internally they would imply the same thing.
>>
>>     
> Well, you get O_NONBLOCK for free by having a file descriptor; and you
> can't turn off people trying to turn it on/off with fcntl() - so you may
> as well just use that, no? :-)
>
> Scott
>   
Its purely an api question. We could easily take the WNOHANG flag and 
just unset it when we get it and set O_NONBLOCK instead. We need 
O_CLOEXEC anyway though, and the only reason to do it would be to get 
rid of the O_ options and take only one type of flag (that and just a 
little more waitid consistency).

--CJD
