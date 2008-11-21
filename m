Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYKURhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYKURhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYKURhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:37:23 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:21629 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYKURhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:37:22 -0500
Message-ID: <4926F1AC.7090301@oracle.com>
Date: Fri, 21 Nov 2008 09:36:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, trond.myklebust@fys.uio.no,
       viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 24/45] CacheFiles: Add a hook to write a single page of
 data to an inode [ver #41]
References: <20081121002317.69e4fd11.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144343.10667.530.stgit@warthog.procyon.org.uk> <3843.1227271421@redhat.com>
In-Reply-To: <3843.1227271421@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4926F1AF.019A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> Sigh.  I don't normally comment on busted comment layout, but Ingo does
>> so I'm allowed to ;) See recent discussion around the kmemleak patches.
> 
> Sigh.  Three points for you to consider:
> 
>  (1) The prevailing comment style in struct address_space_operations does not
>      have comment delimiters on their own lines.  This has the advantage that
>      it doesn't unnecessarily waste two lines per comment.  I will advocate
>      that style for banner comments for top-level constructs, but for internal
>      comments it's generally a poor compromise.

I would have said that the prevailing comment style in struct
address_space_operations is sketchy or limited or lacking.

I want useful comments.  I don't give a hoot whether they are in kernel-doc
format or /* or //.  I'll even take them in a separate file if they are
more about theory of operation (overview) instead of directly related
to a struct or a function's operations, although some people want comments
only in source files because that is more likely to be updated when
needed.  I agree with that sentiment, but I wouldn't limit people to
having comments only in source files.  I just want comments or doc files
(which you usually provide plenty of).


>      The following comment on braces applies also to comments:
> 
> 	Also, note that this brace-placement also minimizes the number of empty
> 	(or almost empty) lines, without any loss of readability.  Thus, as the
> 	supply of new-lines on your screen is not a renewable resource (think
> 	25-line terminal screens here), you have more empty lines to put
> 	comments on.
> 
>  (2) Randy Dunlap should be beaten for his contribution to CodingStyle.  Next
>      time I have the opportunity, I'll do just that, and this time I'll see
>      about using one of my own racquets rather than one of his:-P

Bring it on.  and -ENOPATCH.

I don't own Documentation/CodingStyle. I'm just willing to send patches for it.
You (or anyone) can do the same.


>  (3) It's so much easier to write style guides than to properly document one's
>      code.

Easy to write a style guide, but difficult to get consensus on it.

If you don't document your own code, who will do it?  Probably nobody.


> </rant>
> 
>>> +/**
>>> + * generic_file_buffered_write_one_page - Write a single page of data to an
>>> + *	inode
>> kerneldoc doesn't permit line breaks in this context (unless it got
>> fixed recently)

No, it's not fixed.

> So you advocate a line exceeding 80 chars?

Either that or break the first line (function name & short description) up like:

/**
 * fubar - generally scrog and muck the system [based on an armed forces acronym for guess what]
 */

Change that to:

/**
 * fubar - scrog and muck up the system
 *
 * fubar (the name) is believed to come from an armed forces acronym
 * for you_know_what.
 */


> I contend that kerneldoc is a bad idea in many ways: it encourages people to
> be lazy and to not write proper interface documentation.

I can't/don't force you or anyone to write proper documentation, and the
maintainers who could do that don't do it.

But basically (see above), I just want documentation.  It's form is
not a big deal to me.  The good thing about kernel-doc is that it
provides some consistency.  Have you ever heard of look and feel?
Well, documentation can have consistent look and feel too, and it should.

Do we make exceptions?  Sure, we do.  Just look at Documentation/lguest/.


-- 
~Randy
