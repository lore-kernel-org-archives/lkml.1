Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYFBQ3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYFBQ3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYFBQ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:29:39 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:41783 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYFBQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Go5D3/MZTnkjrPO0qEuX0diY23wl+nBnPE54+A9EhO7aoU2/qZeIw1xAj8pYxE/DgHo8b33FdVg7gXysqkKdDsXXlVPUpG+OmPcekmSL3/zhz3mT8us+s5SZzfeQNju4JFG6GKbKelxlrJ27jlwpHA73RENzSJKVzep918F0Juc=
Message-ID: <9d732d950806020929v1ece55ecobabc418425c1e044@mail.gmail.com>
Date: Tue, 3 Jun 2008 01:29:33 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [patch 01/15] security: pass path to inode_create
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080602155152.GA18257@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080602060144.GA11564@infradead.org>
	 <20080602091341.GA8011@infradead.org>
	 <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu>
	 <20080602093630.GA25254@infradead.org>
	 <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu>
	 <20080602104203.GA21898@infradead.org>
	 <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu>
	 <20080602150517.GB22400@2ka.mipt.ru>
	 <9d732d950806020831h1b8aeabag9cb6db8e16bac971@mail.gmail.com>
	 <20080602155152.GA18257@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/3 Evgeniy Polyakov <johnpol@2ka.mipt.ru>:
> On Tue, Jun 03, 2008 at 12:31:14AM +0900, Toshiharu Harada (haradats@gmail.com) wrote:
>> > This is a really interesting flame, can you proceed,
>> > we will run for cola and peanuts :)
>>
>> Let me quote a message by Chris Wright from LSM ml:
>> "You cannot discover the path used to access an inode without knowing
>> both the dentry and the vfsmount objects. "
>
> Depending on what path you really want. If you want it related to bind
> mount, you can (trivially). And even full path with vfsmount with
> additional work.
>
> Without any single additional patch on top of security system.
>
> It maybe a bit slower, more complex, duplicate, whatever...
> Active security was never a fast solution and was never a compromiss
> between those who like it and who do not.
>
> Technically you can be inside created limits and formally do not change
> security model, but in practice implement you lovely path based security
> checks.
>
>> Another one by Stephen Smalley:
>> "Pathname-based security considered harmful.  You want to control access
>> to an object, not a name, and the name-to-object mapping is neither
>> one-to-one nor immutable."
>
> For those who care exactly about path, they do not want to have security
> checks for object, which was there. As addition, selinux
> maintainer/architector opinion is a bit biassed :)

This is a very important point.

The world of Linux consists of the two pieces, userland and kernel.
Objects have names and inodes. Information flow control need to be
handled using inodes (labels), but pathnames need to be
controlled because objects are represented by names in userland.
Both pieces work together. Vfsmount is a missing piece.

AppArmor and TOMOYO Linux are not claiming they are better MAC for Linux.
(that's how I understood Stephen's words. I am agreed)
So people don't have to eliminate pathname-based MACs.

>> Can you guess when they were posted?
>> The answer is December 2003. :)
>> Do we need more time? I don't think so.
>
> Apparently we do :)
Okay, I'll go and get my coke. ;)

>> I'm viewing Miklos' patches as *enhancements* not only for AppArmor (and
>> other pathname-based LSM modules). Everyone can make use of
>> information and lose nothing.  Am I too simple minded?
>
> What I wanted to say, is that people who do want to implement theirs
> idea, will find a way to do it without breaking other approach.
> With additional changes, with more complex approach, more code and
> possibly some duplication/optimization/whatever.
100% agreed.

> So, if people continue to kick theirs head to the wall, they want
> exactly that flame, that void talks and so on :)

-- 
Toshiharu Harada
haradats@gmail.com
