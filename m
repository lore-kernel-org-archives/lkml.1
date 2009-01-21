Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbZAUPSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbZAUPSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbZAUPSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:18:41 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64061 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbZAUPSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:18:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=i38LSVB9yuSbdGAsUlPimCHZg+dVsirSQopeIqVr2al1CyLCH0N8vv9wocz1opKMlP
         VnZsISMxnFBkGT3BwxEcjZKAU/WQhgU7FyD4tZOe5Pm+dC19oWfi1JjCXEiBcJ0q3YbQ
         9F5JrydnHcKHxNytFpcSOU+WenKY/b6J4Ippk=
MIME-Version: 1.0
In-Reply-To: <20090121145513.GH31253@mit.edu>
References: <576cb9750901210619u3d2abfdclb818f0946f7bc663@mail.gmail.com>
	 <20090121145513.GH31253@mit.edu>
Date: Wed, 21 Jan 2009 16:18:35 +0100
Message-ID: <576cb9750901210718u32aa98ecy87e7298a0f3444f@mail.gmail.com>
Subject: Re: ext4 no space left
From: Victor Pelt <victor.pelt@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Victor Pelt <victor.pelt@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i set the number mounted counter to 31, which forced fsck to run on
the next reboot. I rebooted, fsck didn't show any erros, but i still
got the no space left error when i tried to copy files to the
partition.

i'll try the latest git kernel though.

On Wed, Jan 21, 2009 at 3:55 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Jan 21, 2009 at 03:19:28PM +0100, Victor Pelt wrote:
>> Hey,
>>
>> i tried to switch my root partition to ext4 (from reiserfs) but i ran
>> into problems when copying over all the data that it says 'no space
>> left on the device'
>> i'm running 2.6.28-gentoo-r1 (based on 2.6.28.1 if i'm not mistaken)
>>
>> rootfs                 5044188   4310972    476980  91% /  <= file
>> system that is 'full'
>>
>> i like to use that last 470MB if possible
>>
>> fsck didn't help (tried that)
>
> If this is the problem I think it is, it's fixed in patches that were
> merged for 2.6.29 (in -rc1), and you can work around it via umounting
> and remounting the filesystem (or in case of the root filesystem,
> rebooting).
>
> However, when you said "fsck didn't help", what exactly did you mean
> by that?  That fsck didn't show any problems, when you ran it while
> the filesystem was mounted?  Did you actually reboot and force an
> fsck, and then found that you were still getting ENOSPC errors?
>
> I assume you have tried writing as root, and that quotas are disabled?
>
>                                         - Ted
>
> P.S.  If it is the problem I think it is, upgrading 2.6.29-rcX should
> fix the problem, as would using the ext4-stable branch in the ext4 git
> tree, or applying the patches in the for-stable branch of the ext4 git
> tree:
>
>    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
>
