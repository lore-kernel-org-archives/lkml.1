Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbXIMOve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbXIMOve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbXIMOvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:51:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:49781 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbXIMOvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MnkEP1QkTIfgJNXtoKqUWZyUeqGtENMSReA2ILZvi+We7F5EH89qKOWxHs0YqCuVvYjqH8MG3lz1g1ypfdhwjgo7nYHa7WXWKUg7pcuHmN+gV6nK3TC6W9rspu3X0ZWza6o0L0iMNlFuYrtSSQQI+uoNNGVyhcOWbkb64l5Cp7M=
Message-ID: <f158dc670709130751s2f6046beje5401ec6c56051dd@mail.gmail.com>
Date: Thu, 13 Sep 2007 08:51:21 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [PATCH] 9p: rename uid and gid parameters
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <a4e6962a0709130638v384c2708y76167d4e92cbac56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070913044718.GB2675@ionkov.net>
	 <a4e6962a0709130638v384c2708y76167d4e92cbac56@mail.gmail.com>
X-Google-Sender-Auth: 446c38e28937dc47
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zero was the value that was used before, even though it wasn't defined
explicitly. I just defined a macro so we can see and eventually change
it to something better. I don't know if there is a good default value.
Is nfsnobody the same on all Linux distributions?

Thanks,
    Lucho

On 9/13/07, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On 9/12/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
> > Change the names of 'uid' and 'gid' parameters to the more appropriate
> > 'dfltuid' and 'dfltgid'.
> >
>
> ...
>
> >         strcpy(v9ses->name, V9FS_DEFUSER);
> >         strcpy(v9ses->remotename, V9FS_DEFANAME);
> > +       v9ses->dfltuid = V9FS_DEFUID;
> > +       v9ses->dfltgid = V9FS_DEFGID;
> >
> ...
> > +#define V9FS_DEFUID    (0)
> > +#define V9FS_DEFGID    (0)
>
> I'm not sure if there is a good solution here, but I'm uncomfortable
> with using uid=0 as the default.  I'm not sure if there is a default
> uid for nobody, but anything is probably better than 0.  Looks like
> nfsnobody is 65534, we could use that - even if only as a marker for
> the server to map it to nobody on the target system?  What do you
> think?
>
> Particularly with attach-per-user, we probably need to look at
> interacting with idmapd or create our own variant real soon.
>
>               -eric
>
