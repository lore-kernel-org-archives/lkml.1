Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbXIMOUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbXIMOUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXIMOU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:20:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:19334 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbXIMOUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:20:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RTaXpjfT+3XajPv1EjHpbxPbc1WGMLzmzQdoDBArZ+ThJRmTNL4Ay7U1r51Jl5AExtFzLE9nShNQEnMAMAtM7dwB1l6CXt6S/oDM6qnZAVskNNfZbbIsa2JzFGcnUM+z4L6kwREcxl1T5Yxwr1XYTeLjAfTBr6JiMkCsIhqUksI=
Message-ID: <a4e6962a0709130720o457a3f7ene7977d99720b2d30@mail.gmail.com>
Date: Thu, 13 Sep 2007 09:20:23 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Subject: Re: [PATCH] 9p: attach-per-user
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070913044803.GC2675@ionkov.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070913044803.GC2675@ionkov.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
>
> - allow only one user to access the tree (access=<uid>)
>  Only the user with uid can access the v9fs tree. Other users that attempt
>  to access it will get EPERM error.
>

While access=<uid> and dfltuid=<some-other-uid> creates an interesting
flexibility in the way things can be used, I'm wondering if
access=<uid> dfltuid=DEFAULT_UID is intuitive, it might be nice for
the default behavior to be setting defltuid to the uid specified in
access when that access option is used.  This can be overridden with
the dfltuid option, but I think it makes more sense to attach as the
uid you are restricting access to.

If that's the way we want to go, I think that can be handled in a
separate patch.

I've merged this stuff into my test tree, as soon as regressions pass
and I confirm they compile clean on another architecture I'll push
them into my devel to be picked up by -mm.

                 -eric
