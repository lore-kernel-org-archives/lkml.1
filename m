Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYESMYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYESMYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYESMYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:24:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:31094 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYESMYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i1SSjb7L0Y2KnXJyAU0349W8r/FYQVwqeLLGAtm+/n014SCT8QrjQVaOWfj9hFbj7mkvkl3EpVibgi21Nb0YBv8uNpx5VbZ+OKQ1cGtIMX6P+/xsT1EXjQNJA5cZH7Rived5V6QzDgH01qjlCxaq6PFFF6vsGzKTBpCe8m4utww=
Message-ID: <cfd18e0f0805190524w7d0e5a47s42cb2c469c26a262@mail.gmail.com>
Date: Mon, 19 May 2008 14:24:37 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] utimensat() non-conformances and fixes -- version 2
Cc: drepper@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <E1Jy20a-0007pv-Ij@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <482F38A1.9070704@gmail.com>
	 <E1Jy20a-0007pv-Ij@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

On Mon, May 19, 2008 at 11:50 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Regarding your suggestions above, are you meaning something like the
>> patch below?
>
> Yes.
>
>> The patch is a little less pretty than I'd like because of the need to
>> return EACCES or EPERM depending on whether (times == NULL).  In
>> particular, these lines in utimes.c:
>>
>> +     if (!times && error == -EPERM)
>> +             error = -EACCES;
>>
>> seem a little fragile (but maybe I worry too much).
>
> It's not only fragile, it's ugly as sin.  I'd rather do it this way:
>
> - initialize error to zero
> - if no write access then set error, and the ATTR_TIMES_UPDATE(*) flag
> - set error2 from result of notify_change()
> - if error is zero then return error2, otherwise return error
>
> (*) I've been mulling over the name and perhaps ATTR_OWNER_CHECK would
> be better, or something that implies that it's not really about
> updating the times, but about checking the owner.

This all makes sense, but...

> Also could you do the patch against the
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups
>
> tree, which does big structural cleanups to do_utimes?

You keep moving the goalposts here...  First, it was provide an
obvious correct fix (for the non-conformances); then: can you cleanup
the owner checks; then: can you rewrite against my git tree...  My
time at the moment is fairly limited, and I have a problem: currently,
I'm not a git user.  That'll change soon, but I don't have the time to
change it now.  Can I just download a snapshot tarball of your git
changes somehwere?  Alternatively, when do you expect your changes to
make it into an rc?

Cheers,

Michael
