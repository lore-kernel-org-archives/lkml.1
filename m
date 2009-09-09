Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZIIP7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZIIP7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZIIP7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:59:54 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:41287 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZIIP7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J+/oP+JDeYb4368o42mGRnjqpc35c42qDpm1yHyBho6v+EUPIDHllSYOhUGlfJ3IaT
         qXK6oLW+Ds0A4prHes6zwchYn8KCNNHacG1ECofZW3KcZKC1piabV+HLT8tbE5fNbWOW
         MfB+r/pGgCCX/UR0fa0pwEW8Dcu8YWGq3zuVw=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909072227140.15430@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
	 <Pine.LNX.4.64.0909072227140.15430@sister.anvils>
Date: Thu, 10 Sep 2009 00:59:56 +0900
Message-ID: <28c262360909090859l6e94c0eekc38bd2670d7fc79e@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: munlock use follow_page
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hiroaki Wakabayashi <primulaelatior@gmail.com>,
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

On Tue, Sep 8, 2009 at 6:29 AM, Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
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
> Cc: stable@kernel.org
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
It looks better than old Hiroaki's one.

-- 
Kind regards,
Minchan Kim
