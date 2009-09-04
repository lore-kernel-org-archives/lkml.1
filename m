Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZIDShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZIDShn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbZIDShl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:37:41 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:58200 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbZIDShk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LJTuSjwpOfPQ5WzGES+gdYEyGdMfit7Gj50uZTbhIyoTAKsoYtIVLyAxdzlOrg7vOT
         Cx/gcJk7H8APSlFW6F0nU8QCb+S7TlwFgvWGLVwAt6FdZwrsogT86Ca1htLcmyT4VX00
         n4IfMS8yrDNxZrrU6xKuC6L2RBMdqh52Q9O7I=
MIME-Version: 1.0
In-Reply-To: <8db1092f0909040710t5c048e93j3fb5adc9e7f1cf6a@mail.gmail.com>
References: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com>
	 <200909030907.02321.oliver@neukum.org>
	 <20090903160536.GA24050@kroah.com>
	 <200909041223.22835.oliver@neukum.org>
	 <8db1092f0909040710t5c048e93j3fb5adc9e7f1cf6a@mail.gmail.com>
Date: Fri, 4 Sep 2009 20:30:13 +0200
Message-ID: <8db1092f0909041130p2733f7ebs5ee8211c48bab861@mail.gmail.com>
Subject: Re: [2.6.31-rc8] Problem with detect USB devices
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, ebiederm@aristanetworks.com,
       eparis@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/4 Maciej Rutecki <maciej.rutecki@gmail.com>:
> 2009/9/4 Oliver Neukum <oliver@neukum.org>:
>
>>
>> Maciej,
>>
>> can you run a git bisection?
>>


0db501bd0610ee0c0aca84d927f90bcccd09e2bd is first bad commit
commit 0db501bd0610ee0c0aca84d927f90bcccd09e2bd
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Aug 27 03:20:04 2009 -0700

    inotify: Ensure we alwasy write the terminating NULL.

    Before the rewrite copy_event_to_user always wrote a terqminating '\0'
    byte to user space after the filename.  Since the rewrite that
    terminating byte was skipped if your filename is exactly a multiple of
    event_size.  Ouch!

    So add one byte to name_size before we round up and use clear_user to
    set userspace to zero like /dev/zero does instead of copying the
    strange nul_inotify_event.  I can't quite convince myself len_to_zero
    will never exceed 16 and even if it doesn't clear_user should be more
    efficient and a more accurate reflection of what the code is trying to
    do.

    Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
    Signed-off-by: Eric Paris <eparis@redhat.com>

:040000 040000 ae8bc8bebfd205cde1f7b7689f60a2ada08b1e24
7be919a71e3e27510ec38f95664a5e770ce82ad8 M      fs

Unfortunately I cannot revert it (to make sure):
root@gumis:/usr/src/git/linux-2.6# git revert
0db501bd0610ee0c0aca84d927f90bcccd09e2bd
Automatic revert failed.  After resolving the conflicts,
mark the corrected paths with 'git add <paths>' or 'git rm <paths>'
and commit the result.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
