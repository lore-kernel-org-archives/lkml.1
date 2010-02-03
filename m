Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0BCQmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:42:08 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:37675 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab0BCQmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:42:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nHqNOjfUji7S/rLaYhwAtngghNTKOKTZUPfglymEXrUyww9tVx+FTskyWIXTlbgkpG
         cY98q5FmtXb/UzGRLg8uBH/UdGD2OyBJYBBI6jWoF2/XWSVIF3JUzRwKPD339joEknum
         0sYkrsAStspIA+IMREzy3O814TWXAgdvDAGbo=
MIME-Version: 1.0
In-Reply-To: <1265213945.24386.2.camel@gandalf.stny.rr.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-4-git-send-email-dvhltc@us.ibm.com>
	 <520f0cf11002030805q35029925u36f544f7d37faedb@mail.gmail.com>
	 <1265213851.24386.1.camel@gandalf.stny.rr.com>
	 <1265213945.24386.2.camel@gandalf.stny.rr.com>
Date: Wed, 3 Feb 2010 17:42:00 +0100
Message-ID: <520f0cf11002030842m6fd73d48j547551169bbc4f6e@mail.gmail.com>
Subject: Re: [PATCH 3/3] kernel-shark: fix unitialized handle compile warnings
From: John Kacur <jkacur@gmail.com>
To: rostedt@goodmis.org
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 3, 2010 at 5:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2010-02-03 at 11:17 -0500, Steven Rostedt wrote:
>> andle)
>> > > -               handle = tracecmd_open(input_file);
>> > > +       handle = tracecmd_open(input_file);
>> > >
>> > > -       info->handle = handle;
>> > > +       if (handle)
>> > > +               info->handle = handle;
>> > >
>> > >        /* --- Main window --- */
>> > >
>> > > --
>> >
>> > This looks correct, but I'm wondering if it is safe to continue if the
>> > call to tracecmd_open fails?
>>
>> Actually this patch is wrong. The real code should be:
>>
>> -     if (handle)
>> +     if (input_file)
>
> Looking at the context, this isn't enough. We should have had:
>
>        if (input_file)
>                info->handle = tracecmd_open(input_file);
>        else
>                info->handle = NULL;
>
> -- Steve
>

Okay, are you going to push it to your repo for us? I would offer to
push it through mine if it would save you time, but it's probably
quicker if you just handle it.
