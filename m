Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZLAXxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZLAXxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbZLAXxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:53:10 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:65203 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZLAXxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n5anm1nn5k0W7yGTe7G/T2ahdgk1KU5+KoJVEkvjpudqc2Q9VSb9/F+xHrNkJaX7xu
         zreRaYfxOAbeRa1ClUgrcFF2X6mVihnj4ANn/RgxmDreVttOLdZiHXVJ8H+RJQ5cHKFw
         WSdSm2lWb6s+Rj0VjBDhQaCvbGb+BNuRuNjSk=
MIME-Version: 1.0
In-Reply-To: <1258723764-4399-1-git-send-email-jglisse@redhat.com>
References: <1258723764-4399-1-git-send-email-jglisse@redhat.com>
Date: Wed, 2 Dec 2009 09:53:15 +1000
Message-ID: <21d7e9970912011553v391fa720j140a8c5ea3f3c06@mail.gmail.com>
Subject: Re:
From: Dave Airlie <airlied@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: dri-devel@lists.sf.net, LKML <linux-kernel@vger.kernel.org>,
       Thomas Hellstrom <thellstrom@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 11:29 PM, Jerome Glisse <jglisse@redhat.com> wrote:
> This patch series add ttm range validation function. Aim is to
> include this in 2.6.33 so i have time to iron out issue, comments.

I missed these first time around,

Thomas if you have any opinions on the TTM stuff please see if you
can take a look.

> ttm:
> I duplicated a bunch of ttm functions but now i think, best would
> be to add range to all function and use free list if range cover
> all the manager space. Doing so we might also be able to simplify
> mem_space alocation into a simpler function like ttm_bo_mem_space_range
>
> radeon:
> The second patch is a rework/cleanup of radeon object, it solves
> few issues along the way (i can't remember them now after fews
> days testing the patches). Biggest change is that we now rely
> on BO being validated before doing any change to radeon bo structure.
> As with any big patch i might introduce regressions, so far after
> testing on AGP:R1XX,R2XX,R3XX,R6XX PCIE:R3XX,R4XX,R5XX,R6XX,R7XX
> and RS480,RS690 i didn't found anythings obvious (test being X +
> glxgears + compiz(on hw which support it) + suspend/resume).

I'll try and take a look at this here it doesn't seem to depend on the first
patch so I can push it separate if needed.

Dave.

>
> Last patch is smaller, it just use the interface introduced by
> the first patch.
>
>
