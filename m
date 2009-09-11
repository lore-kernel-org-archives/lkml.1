Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZIKLMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZIKLMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZIKLMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:12:49 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:33674 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZIKLMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:12:49 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 07:12:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C3bLTXaQQ8NG1LqjymLCD3u/9W+c3C3aBmzQKLw9MgosLkSHfg00/lZvqBXAVEWRyv
         MoyQXXIwAUw6lgOE8bi0dy7xIXbhXdracbWcxWtZJhn+SPVRPHJDUiTSfRmHys300/yz
         aV0Hm524gRznCqOWQ6xU2WSobLU3q5ZvT6JXk=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909072227140.15430@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
	 <Pine.LNX.4.64.0909072227140.15430@sister.anvils>
Date: Fri, 11 Sep 2009 20:07:13 +0900
Message-ID: <82e12e5f0909110407h178ab6e0hbd6ac9e204738ae7@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: munlock use follow_page
From: Hiroaki Wakabayashi <primulaelatior@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/8 Hugh Dickins <hugh.dickins@tiscali.co.uk>:
> Hiroaki Wakabayashi points out that when mlock() has been interrupted
> by SIGKILL, the subsequent munlock() takes unnecessarily long because
> its use of __get_user_pages() insists on faulting in all the pages
> which mlock() never reached.
>
> It's worse than slowness if mlock() is terminated by Out Of Memory kill:
> the munlock_vma_pages_all() in exit_mmap() insists on faulting in all the
> pages which mlock() could not find memory for; so innocent bystanders are
> killed too, and perhaps the system hangs.
>
> __get_user_pages() does a lot that's silly for munlock(): so remove the
> munlock option from __mlock_vma_pages_range(), and use a simple loop of
> follow_page()s in munlock_vma_pages_range() instead; ignoring absent
> pages, and not marking present pages as accessed or dirty.
>
> (Change munlock() to only go so far as mlock() reached?  That does not
> work out, given the convention that mlock() claims complete success even
> when it has to give up early - in part so that an underlying file can be
> extended later, and those pages locked which earlier would give SIGBUS.)
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Reviewed-by: Hiroaki Wakabayashi <primulaelatior@gmail.com>

It very simple and so cool! I have learned something.

--
Thanks,
Hiroaki Wakabayashi
