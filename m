Return-Path: <linux-kernel-owner+w=401wt.eu-S933749AbYD1L7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbYD1L7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763297AbYD1L73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:59:29 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:26381
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYD1L73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:59:29 -0400
Message-ID: <4815BC1E.6020805@qumranet.com>
Date: Mon, 28 Apr 2008 14:59:26 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
       Soeren Sandmann <sandmann@daimi.au.dk>, linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk> <a36005b50804272143g68dc5f3ax848e9548a3d14ed7@mail.gmail.com> <20080428115321.GD30840@mit.edu>
In-Reply-To: <20080428115321.GD30840@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
>> Aside from what has already been proposed there is also the
>> readdirplus() route.  Unfortunately the people behind this and related
>> proposals vanished after the last discussions.  I was  hoping they
>> come back with a revised proposal but perhaps not.  Maybe it's time to
>> pick up the ball myself.
>>
>> As a reminder, readdirplus() is an extended readdir() which also
>> returns (a subset of) the stat information for the file at the same
>> time.  The subset part is needed to account for the different
>> information contained in the inodes.  For most applications the subset
>> should be sufficient and therefore all that's needed is a single
>> iteration over the directory.
>>     
>
> I'm not sure this would help in the cold cache case, which is what
> Soeren originally complained about.[1] The problem is whaever
> information the user might need won't be store in the directory, so
> the filesystem would end having to stat the file anyway, incurring a
> disk seek, which was what the user was complaining about.  A
> readdirplus() would save a whole bunch of system calls if the inode
> was already cached, yes, but I'm not sure that's it would be worth the
> effort given how small Linux's system call overhead would be.  But in
> the cold cache case, you end up seeking all over the disk, and the
> only thing you can do is to try to keep the inodes close to each
> other, and to have either readdir() or the caller of readdir() sort
> all of the returned directory entries by inode number to avoid seeking
> all over the disk.
>   

A readdirplus() could sort the inodes according to the filesystem's 
layout, and additionally issue the stats in parallel, so if you have 
multiple spindles you get significant additional speedup.

-- 
error compiling committee.c: too many arguments to function

