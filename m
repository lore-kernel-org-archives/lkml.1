Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965834Ab0B0LKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 06:10:43 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33462 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965569Ab0B0LKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 06:10:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=yEVm8G/89IkLV3KurGPEs1uVliqr0KVVixfxRgv/9GkMsqca5ZnFQEg+vkLyVDssWz
         ABHOK4JnvbIdZS0+spGZvnzeoplv5rQCygc8XFWX4ca3fMLoWLF91rLlm1mk8jwJLpzs
         A8TK6aX6VD/0qYbpTwl5XauProQkV4x1R74w0=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] RFC directio: partial writes support
References: <87iq9lxz3t.fsf@openvz.org>
Date: Sat, 27 Feb 2010 14:10:35 +0300
In-Reply-To: <87iq9lxz3t.fsf@openvz.org> (Dmitry Monakhov's message of "Thu,
	25 Feb 2010 15:45:58 +0300")
Message-ID: <87vddj6ij8.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Can someone please describe me why directio deny partial writes.
> For example if someone try to write 100Mb but file system has less
> data it return ENOSPC in the middle of block allocation.
> All allocated blocks will be truncated (it may be 100Mb -4k) end
> ENOSPC will be returned. As far as i remember direct_io always act
> like this, but i never asked why?
> Why do we have to give up all the progress we made?
> In fact partial writes are possible in case of holes, when we 
> fall back to buffered write. XFS implemented partial writes.
>
> I've done trivial changes and it works like charm. 
> Let's enable partial writes support and allow caller to define
> this behavior.
add Andrew to cc:
