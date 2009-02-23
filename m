Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZBWCfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZBWCfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 21:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZBWCfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 21:35:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:48853 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZBWCfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 21:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fy9OelgCI1YimoEJka3GCak2EQ+lnV6lwLc1A8rx0DoYz/7BPzcCPgO1DkgyhIk5Rq
         NLnG4Ixa+6go1mbzGB+VKaf4LIT14htD9BgIw4kUFZo/l9WN510j5pKlgs+KcOoO+Iwl
         fZtYedJToIdA8JDHugp+Oc1eBhdsQHQAtXs5I=
MIME-Version: 1.0
In-Reply-To: <20090222181052.36763a2d@tupile.poochiereds.net>
References: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local>
	 <524f69650902201721l1c7f0d34p4708980a90d7fc8f@mail.gmail.com>
	 <alpine.OSX.2.00.0902222137080.7676@horst-reiterers-macbook-air.local>
	 <524f69650902221303h37feb366k3d89a07bfd100ea3@mail.gmail.com>
	 <alpine.OSX.2.00.0902222206360.7676@horst-reiterers-macbook-air.local>
	 <20090222173446.2da6b182@tupile.poochiereds.net>
	 <20090222181052.36763a2d@tupile.poochiereds.net>
Date: Sun, 22 Feb 2009 20:35:19 -0600
Message-ID: <524f69650902221835x551da9f3yb6750f723f33b1d5@mail.gmail.com>
Subject: Re: [linux-cifs-client] Re: [PATCH] fs/cifs: send SMB_COM_FLUSH in 
	cifs_fsync
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Horst Reiterer <horst.reiterer@gmail.com>,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 8:10 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Sun, 22 Feb 2009 17:34:46 -0800
> Jeff Layton <jlayton@redhat.com> wrote:
>
>> On Sun, 22 Feb 2009 22:12:11 +0100 (CET)
>> Horst Reiterer <horst.reiterer@gmail.com> wrote:
>>
>> > On Sun, 22 Feb 2009, Steve French wrote:
>> > > Suggestions on what to call such a new mount option?  How about
>> > > "nostrictfsync"  ?
>> >
>> > Sound good, should be self-explanatory for Samba users and those familiar
>> > with the fsync concept.
>> >
>> > Horst.
>>
>> My suggestion would be to not add a new option until someone requests
>> it/complains about it. We already have a lot of unneeded/unused mount
>> options, and I think this will just be adding one to the pile.
>>
>> My $.02...
>>
>
> ...and to lend further strength to this argument, we're not doing this
> at close(), but rather at fsync(). posix is pretty clear about what's
> supposed to happen at fsync:
>
> "The fsync() function shall request that all data for the open file
> descriptor named by fildes is to be transferred to the storage device
> associated with the file described by fildes."
>
> ...if you don't want to take the performance penalty then don't use
> fsync(). If you're using fsync, then you care about data integrity
> and adding a mount option to disable it is rather pointless.

There is a lot of history here (especially in the man page of
smb.conf) on dumb things apps do in this area.  I don't object to
allowing users to turn strict sync behavior off.   There are some apps
who presumably consider getting data to the server (which we already
do in fsync) "stable enough" storage (clients are not battery backed
up, with redundant, highly available hardware as some servers are).
I agree that the default should be to write the data to the metal on
the server (even though this can be very, very expensive) for fsync

-- 
Thanks,

Steve
