Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZBUHfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZBUHfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 02:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZBUHfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 02:35:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:55032 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZBUHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 02:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=utx1b3kA4xLSLKNycKpq/1rIHcnDAiSJOTDeNPvrz0CWzaH6IHvwmikakRUpY30ATv
         mMl9jyQDKNlm59nOci6Vgjz7/VDW0y7xATX/OvisRmSt0b56l+Y+EonpAZ+TEtpmFg2r
         0jhTkxdsw66MOhOxNxaPH0xJM8ZvZKWO/ADXo=
MIME-Version: 1.0
In-Reply-To: <20090220175900.GA18522@mini-me.lan>
References: <20090214141411.GD26628@mini-me.lan>
	 <1234833003-19631-1-git-send-email-bdonlan@gmail.com>
	 <3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
	 <20090220175900.GA18522@mini-me.lan>
Date: Sat, 21 Feb 2009 02:35:02 -0500
Message-ID: <3e8340490902202335i2b01cd63gd685efeab64ad338@mail.gmail.com>
Subject: Re: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory 
	traversal through deleted inode
From: Bryan Donlan <bdonlan@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Bryan Donlan <bdonlan@gmail.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 12:59 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Feb 20, 2009 at 12:53:39PM -0500, Bryan Donlan wrote:
>> On Mon, Feb 16, 2009 at 8:10 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>>
>> > +               if (unlikely(IS_ERR(inode))) {
>> > +                       if (PTR_ERR(inode) == -ESTALE) {
>> > +                               ext3_error(dir->i_sb, "ext2_lookup",
>> > +                                               "deleted inode referenced: %lu",
>> > +                                               ino);
>> > +                               return ERR_PTR(-EIO);
>> > +                       } else {
>> > +                               return ERR_CAST(inode);
>> > +                       }
>> > +               }
>>
>> I just noticed that I forgot to edit the function name in the
>> ext3_error and ext4_error invocations... Would it be better to send a
>> delta to fix this or resubmit the whole thing?
>
> It's already been pulled into akpm's tree as separate patches.  I'll
> fix up the ext4 one by hand; probably better for you to send
> replacement patches for ext3 separately to akpm and ask him to replace.
>
> I'd suggest using __FUNC__ instead of hard-coding the function name, BTW...

akpm's already fixed up his copies. Sorry for the inconvenience there
- I made sure to get the printf format specifiers right but on the
other hand completely missed the comparatively obvious function name
:)

Thanks,

Bryan Donlan
