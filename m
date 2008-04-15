Return-Path: <linux-kernel-owner+w=401wt.eu-S1764716AbYDOMzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764716AbYDOMzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYDOMzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:55:01 -0400
Received: from s200aog16.obsmtp.com ([207.126.144.130]:39564 "EHLO
	s200aog16.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYDOMzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:55:00 -0400
Message-ID: <4804A58E.5070104@st.com>
Date: Tue, 15 Apr 2008 14:54:38 +0200
From: Richard MUSIL <richard.musil@st.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Richard Musil <richard.musil@st.com>, Greg KH <greg@kroah.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: Problem with accessing stable git over http
References: <47EA26E4.8060602@st.com> <20080404050718.GE23796@1wt.eu> <47F5E701.6020706@st.com>
In-Reply-To: <47F5E701.6020706@st.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to give an update on the topic. I tried to clone stable 2.6.24.y
branch and got a bit more info then on fetch:

> rmusil@prglx09 ~ $ git clone http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git linux-2.6.24.y
> Initialized empty Git repository in /home/rmusil/linux-2.6.24.y/.git/
> Cannot get remote repository information.
> Perhaps git-update-server-info needs to be run there?
> rmusil@prglx09 ~ $

This is from machine which is behind proxy, but I tried it from another
one, which has direct access and got exactly the same output.
Is it possible that perhaps git-update-server-info should be run there?
Who is responsible for the repository maintenance?
So far it looks like the http access is simply not set up on the repo,
even though it is advertised on project web page.

Greg, could you help me with this?

Richard

On 4.4.2008 10:29, Richard Musil wrote:
> On 4.4.2008 7:07, Willy Tarreau wrote:
>> On Wed, Mar 26, 2008 at 11:35:16AM +0100, Richard MUSIL wrote:
>>> For some reason I cannot access stable kernel git branches over http
>>> since version 2.6.23.y.
>>>
>>> HTTP access is working for 2.6.22.y
>>> (http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git)
>>> - I can fetch from it. It is also working for Linus' dev branch
>>> (http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git)
>>> which I clone.
>>> But for stable 2.6.23.y and 2.6.24.y, when I try fetch, I get in particular:
>>>
>>> HTTP GET
>>> http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git/info/refs
>>> HTTP/1.1
>>> HTTP HTTP/1.1 404 Not Found (text/html)
>>>
>>> I am behind proxy and firewall and I cannot use git protocol.
>>>
>>> Does anyone know, what might be a problem? It kind of makes the sources
>>> unreachable for me :(.
>> what version of git are you using ? Those files indeed do not exist in
>> either repository, so it would be good to find why git tries to fetch
>> them.
> 
> I am usually using latest version compiled on gentoo from ~x86
> (currently it is 1.5.4.5).
> 
> Interestingly those files exist for linux-2.6.22.y, i.e. accessing
> http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git/info/refs
> gives something and that is probably why I can fetch from 2.6.22.y branch.
> 
> Why git tries to access it is something beyond my understanding, I guess
> it is the way http access works.
> 
> But I wonder, why the similar file is not present on 2.6.23.y and
> 2.6.24.y branch. My git config for project looks like this:
> 
>> [core]
>>         repositoryformatversion = 0
>>         filemode = true
>>         bare = false
>>         logallrefupdates = true
>> [remote "origin"]
>>         url = http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>         fetch = +refs/heads/*:refs/remotes/origin/*
>> [branch "master"]
>>         remote = origin
>>         merge = refs/heads/master
>> [remote "linux-2.6.22.y"]
>>         url = http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
>>         fetch = +refs/heads/*:refs/remotes/linux-2.6.22.y/*
>> [remote "linux-2.6.24.y"]
>>         url = http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
>>         fetch = +refs/heads/*:refs/remotes/linux-2.6.24.y/*
> 
> So there is clearly discrepancy between those two on the server, but
> whether this is a bug or intentional I do not know.
> 
> Richard
> 
