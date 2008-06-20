Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYFTLhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYFTLhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYFTLh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:37:29 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:39283 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYFTLh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l490XOC+xiU7A5PlodMLfn6FBt5jEzy22JEm9o0DiyfYF4GbYvgTQNf75YAUTZuaqM
         fL0HBGsUsA/fgtK0XvXl40eB1QtUu2JR20Diiyr2uhQ/3NlEZz8BRk8RhlX62mztbWbc
         uRho3xg/hVfXw5NfAgGUko9RisYlukhpPXRy4=
Message-ID: <d1af83620806200437p7c3817d8i381a99f92f47fd4f@mail.gmail.com>
Date: Fri, 20 Jun 2008 08:37:07 -0300
From: "Kevin Winchester" <kjwinchester@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Bisecting tip/auto-x86-next?
Cc: "Ingo Molnar" <mingo@redhat.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <20080620101722.GD17692@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485AFC9B.7090502@gmail.com> <20080620101722.GD17692@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 7:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
>
>> Hi,
>>
>> I am trying to track down a problem I reported here:
>>
>> http://lkml.org/lkml/2008/6/11/431
>
>  [ GART related bootup crash. ]

It isn't actually a crash - X comes up fine, just without direct
rendering (which really kills KDE4 performance).

>
>> None or you were cc'd on the original report because I had no idea of
>> the source of the issue.  However, I have now narrowed down the
>> problem to the auto-x86-next tree.  Thus I did something like:
>>
>> $ git bisect start
>> $ git bisect good linus/master
>> $ git bisect bad tip/auto-x86-next
>
> ok, in that case you can use tip's topical structure and probably bisect
> purely x86/gart, which has all x86 gart changes.
>
> I.e. do something like this:
>
>  git-checkout tip/x86/gart
>
> build and boot that kernel, if it fails and mainline works then do:
>
>  git-bisect reset
>  git-bisect start
>  git-bisect good linus/master
>  git-bisect bad tip/x86/gart
>
> this should drastically reduce the number of bisection steps needed, to
> 3 or 4 iterations.
>

Thanks - I'll give this a try tonight.  As to your other emails:

> hm, could you send me the config that triggered this?

I will do so tonight when I am home again.  It is a UP AMD64 box with
a VIA chipset, if that helps.

> btw., you can probably ignore this one safely. Also please tell me at
> which commit ID you were at when you triggered this warning.

Good to know - I will get the commit ID tonight as well, although
wouldn't following the same bisection sequence that I did give you the
same bisection point?  I guess that would assume that linus/master and
auto-x86-next haven't changed much since last night, which might not
be correct.

Thanks,

-- 
Kevin Winchester
