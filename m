Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZFXKyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZFXKyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZFXKxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:53:54 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:57728 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFXKxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O0Eh0drhh0Tk6qMj7IAxWSzrbtOdCwER8G8PD9RY2UUuCz3zstM3R48vDHwppWemxS
         y6gQBcf9PIEUcv/aGzj94VkxzVaMchho5+m07CUDWPEJ+Y6BBLsdw8JwRojAGBSnToey
         SGk9kQb0xbrcA/zEQo6bRf6JqLwh5C/iWgL8U=
MIME-Version: 1.0
In-Reply-To: <20090624081819.GA10436@elte.hu>
References: <4A3FB09D.9050903@gmail.com> <20090622153431.GA18466@elte.hu>
	 <25e057c00906220847t15425f38maf486c291d1d2468@mail.gmail.com>
	 <4A3FB479.2090902@lsrfire.ath.cx>
	 <7vhby64i8f.fsf@alter.siamese.dyndns.org>
	 <20090624081819.GA10436@elte.hu>
Date: Wed, 24 Jun 2009 12:53:51 +0200
Message-ID: <c07716ae0906240353h67932054w3dc3ba6dbb864dff@mail.gmail.com>
Subject: Re: [PATCH] fread does not return negative on error
From: Christian Couder <christian.couder@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Junio C Hamano <gitster@pobox.com>,
       =?ISO-8859-1?Q?Ren=E9_Scharfe?= <rene.scharfe@lsrfire.ath.cx>,
       roel kluin <roel.kluin@gmail.com>, git@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 24, 2009 at 10:18 AM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Junio C Hamano <gitster@pobox.com> wrote:
>
>> René Scharfe <rene.scharfe@lsrfire.ath.cx> writes:
>>
>> > the following patch is for git.  I just removed the unneeded check for
>> > res == 0 from your version.  Does it look OK?
>>
>> The patch looks good, and both of our in-tree users do error out
>> when the returned value is 0 (imap-send.c checks with "<= 0" which
>> looks a tad amateurish, though) correctly.
>>
>> Funny, there is no caller of this function in the original context
>> this bug originally found, which I think is linux-2.6/tools/perf
>> ;-).
>
> Hehe, yes :-)
>
> Background: when creating tools/perf/ i cherry-picked all the nice
> Git libraries into tools/perf/util/, to give a standard environment
> for all tooling things that might come up in the future.
>
> Some of those are not used yet but it looked more logical to pick up
> whole pieces - some already gained uses. For example config.c is not
> truly used yet, but very much expected to have a role in the future.
>
> ( The only invasive thing i had to do was the s/git_/perf_/ mass
>  rename across all the files - having 'git_' in perf looked
>  quite confusing. )
>
> And our general experience with the Git libraries in
> tools/perf/util/* is: we love them!
>
> For example parse-options.c is a striking improvement compared to
> getopt.h we used before, and all the other facilities are sane and
> straight to the point as well. So in this sense 'perf' is an ...
> interesting cross-discipline 'fork' of Git's generic libraries.
>
> The auto-generation of everything out of Documentation/*.txt is
> another thing we picked up, and that's very nice too.
>
> One bookeeping issue: i found few explicit credits in those files -
> so i noted in the changelog that i took them from Git and i noted
> the specific upstream Git sha1 when i copied them. Would be nice to
> update each file with names to make credit more explicit:

>From http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=tree;f=tools/perf;hb=HEAD
it looks like there may be some other files like builtin-help.c (and
perhaps some files in perf/Documentation/ too though there should be
some AUTHOR information already in them).

Thanks,
Christian.
