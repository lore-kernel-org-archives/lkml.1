Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbZABXLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbZABXLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZABXLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:11:38 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:43307 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZABXLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Sjxn1VfJ81RJMSJOaCEzT+r8e8yNtAkvyYxwhcWLRO8wWnzbD4CqbV8F33i3tBZij+
         0K0i7V+AWFVRX6JpI41hA9xi/2yVU+PBq10yhQIQX7WjfQmkhS/JXyVVLaJ8IC8Wc7St
         3Fy0TgzWPG0qcwcFzD8HeRAKC+dkFVqwAZuZY=
Message-ID: <495E9F22.3080206@gmail.com>
Date: Fri, 02 Jan 2009 15:11:30 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: tux3@tux3.org, Martin Steigerwald <Martin@lichtvoll.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
References: <200812301935.49303.phillips@phunq.net> <495BAED9.3000305@gmail.com> <200901022117.24504.Martin@Lichtvoll.de> <200901021445.37062.phillips@phunq.net>
In-Reply-To: <200901021445.37062.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Friday 02 January 2009 12:17, Martin Steigerwald wrote:
>   
>> Am Mittwoch 31 Dezember 2008 schrieb Justin P. Mattock:
>>     
>>> I guess this is what is confusing to me:
>>> atomic commit, btree-based versioning.
>>>       
>> Ah, the buzz words. ;)
>>
>> The tux3 mailing list contains quite some design notes about these 
>> concepts. I think others can give better answers about these concepts - I 
>> think I understood what it is for, not the implementation details. But 
>> basically "atomic commit" is a strategy to have the filesystem always in 
>> a consistent state
>>     
>
> Right.  Atomic commit is a term that came from the database world and
> was first applied to filesystems in an LKML message from Victor
> Yodaiken back in 1998 as I dimly recall, and I adopted it to describe
> the tree ased atomic update strategy I was developing for Tux2 at the
> time.  Tux3 uses a new logging variant that is supposed to avoid the
> write-twice behaviour of journalling and the recursive copy behavior of
> WAFL, ZFS and Btrfs, so should be pretty good at synchronous write
> loads and generally reduce write traffic.
>
>   
>> and btree-based versioning allows to keep different  
>> versions of a file / directory around. And unlike other filesystem tux3  
>> has this per inode and not for the complete filesystem. At least if I 
>> understand correctly.
>>     
>
> You do.
>
> "Btree-based" and "versioning" are separate buzzwords.  Tux3 is a btree
> of btrees: the inode table is a btree, containing files that are
> btrees.  It was conceived to demonstrate a new method of versioning
> files that puts the versioning information at the btree leaves instead
> of having multiple independently rooted trees sharing subtrees:
>
>    Versioned pointers: a new method of representing snapshots
>    http://lwn.net/Articles/288896/
>
> This approach lends itself to per-object versioning: each data pointer
> and each inode attribute has its own version label.  Making it work
> per file and even per directory is a matter of clever mapping tricks to
> turn global version numbers into per pointer version numbers.
>
> But note that versioning support is still just a nice demo: the focus
> has shifted to Tux3 as general purpose filesystem, with versioning
> seen as a feature to be integrated after the basic Ext3-class
> functionality is solid and reviewed.
>
>   
>> But at least it should clear that tux3 is a filesystem and not a video 
>> game ;).
>>     
>
> It's kind of like a video game where you sneak through IRC channels
> trying to frag bugs with your BFG.
>
> Regards,
>
> Daniel
>
>   
The game that came to mind when I first
heard of tux3(I had to google a bit to find the name)
was tux racer.  :^)
quick question:
what is the state for security file labeling for
SELinux on this filesystem?


regards;

Justin P. Mattock

