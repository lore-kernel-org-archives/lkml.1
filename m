Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXHXPhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXHXPhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbXHXPhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:37:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208AbXHXPhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:37:21 -0400
Message-ID: <46CEFB1F.5080503@redhat.com>
Date: Fri, 24 Aug 2007 11:37:03 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: Ric Wheeler <ric@emc.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, John Stoffel <john@stoffel.org>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com> <18123.13314.43009.263383@stoffel.org> <20070821192556.GB27995@fieldses.org> <46CEF49A.2050105@emc.com>
In-Reply-To: <46CEF49A.2050105@emc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> J. Bruce Fields wrote:
>> On Tue, Aug 21, 2007 at 02:50:42PM -0400, John Stoffel wrote:
>>  
>>> Not in my experience.  We use NetApps as our backing NFS servers, so
>>> maybe my experience isn't totally relevant.  But with a mix of Linux
>>> and Solaris clients, we've never had problems with soft,intr on our
>>> NFS clients.
>>>
>>> We also don't see file corruption, mysterious executables failing to
>>> run, etc. 
>>> Now maybe those issues are raised when you have a Linux NFS server
>>> with Solaris clients.  But in my book, reliable NFS servers are key,
>>> and if they are reliable, 'soft,intr' works just fine.
>>>     
>>
>> The NFS server alone can't prevent the problems Peter Staubach refers
>> to.  Their frequency also depends on the network and the way you're
>> using the filesystem.  (A sufficiently paranoid application accessing
>> the filesystem could function correctly despite the problems caused by
>> soft mounts, but the degree of paranoia required probably isn't common.)
>>   
> Would it be sufficient to insure that that application always issues 
> an fsync() before closing any recently written/updated file? Is there 
> some other subtle paranoid techniques that should be used?

I suspect that this is not sufficient.  The application should
be prepared to rewrite data if it can determine what data did
not get written.  Using fsync will tell the application when
data was not written to the server correctly, but not which
part of the data.

Perhaps O_SYNC or fsync following each write, but either one of
these options will also cause a large performance degradation.

The right solution is the use of TCP and hard mounting.

       ps
