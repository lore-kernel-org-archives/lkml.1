Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbYCFLTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbYCFLTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbYCFLTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:19:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:8322 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbYCFLTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TB8PgAmy+FtpJHTfppumL78WFN75glWRhBuVZuJae+B51cGOD9DStFuJbDQWwLe39xdCFPC/Nsit4GebW3u7Rsw7PMuS9aMcJSijIIsTNWm0THRP93G8aghkXXeHsEc6JbN0Olbg+FAWhR2pO6Md+l8IInAMrOlt0plFV3VsNM8=
Message-ID: <e9e943910803060319y1f538a68y59bea3fae4b88bb9@mail.gmail.com>
Date: Thu, 6 Mar 2008 11:19:03 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Andreas Dilger" <adilger@sun.com>
Subject: Re: [RFC, PATCH 6/6] ext3: do not write to the disk when mounting a dirty read-only filesystem
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Theodore Tso" <tytso@mit.edu>, sct@redhat.com,
       akpm@linux-foundation.org
In-Reply-To: <20080306071734.GN3616@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
	 <f4577a0cc4262de0fbff02cae3858d2e2edfaaea.1204685366.git.duaneg@dghda.com>
	 <20080306071734.GN3616@webber.adilger.int>
X-Google-Sender-Auth: d4f8fac965ee5b9c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2008, Andreas Dilger <adilger@sun.com> wrote:
> On Mar 06, 2008  01:59 +0000, Duane Griffin wrote:
>  > NOTE: For now I'm simply preventing filesystems requiring recovery from being
>  > remounted read-write. This breaks booting with an uncleanly mounted root
>  > filesystem!
>
> I was going to ask about this - not being able to remount rw is a serious
> problem because many users have only the root filesystem and this
> limitation basically prevents this patch from being landable.

Yep, I agree. I wanted to post this as an RFC now to get feedback on
the overall approach. I'll try and get remount support in there ASAP
and post another version.

>  I'd suggest if the filesystem is going to be remounted read/write that
>  the journal mapping be discarded and the journal replayed.  Depending
>  on how you do the mapping it may be necessary to invalidate all of the
>  pages in the cache so that they don't reference the blocks in the journal.

That was along the lines I was thinking of, too. Thanks for mentioning
invalidating the page cache -- I'll make sure that doesn't get
overlooked.

>  Cheers, Andreas

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
