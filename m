Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbZIVPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbZIVPqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbZIVPqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:46:49 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:39868 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbZIVPqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hxGVPn17ZusZAK1c5oO9u1SBblmodb5R557qnS/ues1IMqV58UxeKOLBs9wBml+Gas
         A/bZ9WPuweXy9eiHl1jGs+wIopp84gqswFWDVtiEBci55g+VPP490YWg1G5p9hXxpi8X
         cuBAcIlHi5r7H7f2Cl3e515n3dSw4iOq1/0iI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0909221133380.15595@dr-wily.mit.edu>
References: <1252292753-11792-1-git-send-email-tabbott@ksplice.com> 
	<8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com> 
	<alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu> <20090916202655.GA17153@merkur.ravnborg.org> 
	<8bd0f97a0909161337v6edbe204wfd83b4c3118b3a27@mail.gmail.com> 
	<alpine.DEB.1.10.0909221035180.15595@dr-wily.mit.edu> <8bd0f97a0909220830w7435ee32h3ec8f667e2b46d79@mail.gmail.com> 
	<alpine.DEB.1.10.0909221133380.15595@dr-wily.mit.edu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 22 Sep 2009 11:46:32 -0400
Message-ID: <8bd0f97a0909220846h338291fbwf1290d7a55443bbb@mail.gmail.com>
Subject: Re: [PATCH] blackfin: Cleanup linker script using new linker script 
	macros.
To: Tim Abbott <tabbott@ksplice.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 11:39, Tim Abbott wrote:
> On Tue, 22 Sep 2009, Mike Frysinger wrote:
>> On Tue, Sep 22, 2009 at 11:29, Tim Abbott wrote:
>> > On Wed, 16 Sep 2009, Mike Frysinger wrote:
>> >> On Wed, Sep 16, 2009 at 16:26, Sam Ravnborg wrote:
>> >> > On Wed, Sep 16, 2009 at 11:58:01AM -0400, Tim Abbott wrote:
>> >> >> OK.  I guess we should plan to modify the INIT_DATA_SECTION macro to add
>> >> >> another argument specifying an alignment level for .init.ramfs.  It'd be
>> >> >> inconvenient to add that right now since there are a lot of patches in
>> >> >> linux-next or otherwise in flight that introduce uses of
>> >> >> INIT_DATA_SECTION, and those patches would all be broken by changing this
>> >> >> now.  Once the dust settles on that for this release, I'll submit a patch
>> >> >> adding said argument to INIT_DATA_SECTION.
>> >> >
>> >> > But this is all discarded during runtime so the added alignment has no cost in the end - no?
>> >>
>> >> once things are booted, there should be no difference.  but
>> >> storage/boot costs increase (you have to store/extract/copy that extra
>> >> data).  you know how miserly we embedded people like to be ;).
>> >
>> > OK, so how do you want to do this?  The options I see are:
>> > (1) we merge this patch now, and add the new alignment argument for -rc2
>> > (2) we add the alignment argument sometime after -rc1 and then merge this
>> > for -rc2
>>
>> doing it in two steps is OK by me and sounds like it'd be easier for you
>
> Both options involve two steps -- but as (1) is obviously easier for me, I
> assume that's what you were referring to.  Thanks.
>
> So are you going to send this to Linus?  I'd be happy to do so, but I'd
> need your ack.

if you apply the .text_l1 update (.init.ramfs -> .exit.data), then you
can add my s-o-b.  otherwise the original patch as posted is broken.
-mike
