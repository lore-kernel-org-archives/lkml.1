Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZGAThm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZGAThm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZGAThf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:37:35 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:43222 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbZGAThe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:37:34 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 15:37:34 EDT
MIME-Version: 1.0
In-Reply-To: <4A4BB898.10909@redhat.com>
References: <20090625090146.6616.9720.sendpatchset@localhost.localdomain>
	 <4A4BA6F8.7090905@redhat.com> <4A4BB898.10909@redhat.com>
Date: Wed, 1 Jul 2009 15:29:31 -0400
Message-ID: <7e0fb38c0907011229h328c8c48i55df5e234b7d367d@mail.gmail.com>
Subject: Re: [Patch] allow file truncations when both suid and write 
	permissions set
From: Eric Paris <eparis@parisplace.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Eugene Teo <eteo@redhat.com>,
       viro@zeniv.linux.org.uk, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 3:27 PM, Eric Sandeen<sandeen@redhat.com> wrote:
> Eric Sandeen wrote:
>> Amerigo Wang wrote:
>>> When suid is set and the non-owner user has write permission,
>>> any writing into this file should be allowed and suid should be
>>> removed after that.
>>>
>>> However, current kernel only allows writing without truncations,
>>> when we do truncations on that file, we get EPERM. This is a bug.
>
> ...
>
>> So I think the main problem here is simply that we didn't set
>> ATTR_FORCE, right...
>>
>> Seems a little odd to |= with ret, -then- check if it's non-0.  Maybe:
>>
>>       /* Remove suid/sgid on truncate too */
>> -     newattrs.ia_valid |= should_remove_suid(dentry);
>> +     ret = should_remove_suid(dentry);
>> +     if (ret)
>> +             newattrs.ia_valid |= (ret | ATTR_FORCE);
>>
>
> On second thought, and after talking w/ eparis, I think this probably
> needs a security_inode_killpriv() too... it seems like it might be best
> to change file_remove_suid(*file) to dentry_remove_suid(*dentry) and
> just call that from do_truncate()?
>
> -Eric

All of this stuff seems horribly complex....   I'm trying to wrap my
head around everything going on here as well....

-Eric (Paris)
