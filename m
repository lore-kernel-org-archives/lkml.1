Return-Path: <linux-kernel-owner+w=401wt.eu-S1946801AbXBJAXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946801AbXBJAXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946803AbXBJAXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:23:33 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:45944 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946801AbXBJAXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:23:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nmho1zhHSjQv40eJFqtz6CWD+Xk2kadR7UIgXHamdanw2qtfcZ1PkyM7hv5D7nf5y39b7ECS9GmDYrLlqAc8DjL7gy64TQ9g7iVtX28bxKBJvUF86fcDAR48m9njV3UpF5ubgVA8JgznSIpEXTiYSDoDnB41UJvoKCM4qmb3ebw=
Message-ID: <ee9e417a0702091623t1ccf55b8wb05b64b9c51474a6@mail.gmail.com>
Date: Fri, 9 Feb 2007 19:23:31 -0500
From: "Russ Cox" <rsc@swtch.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix quadratic behavior of shrink_dcache_parent()
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070209160055.bbd20c9f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HFdnm-0006DB-00@dorka.pomaz.szeredi.hu>
	 <20070209160055.bbd20c9f.akpm@linux-foundation.org>
X-Google-Sender-Auth: 8d365207a51bc89d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> "The file system mounted on /tmp/z in the example contains 2^50
> directories".   heh.
>
> I do wonder how realistic this problem is in real life.

That's a fair concern, although I was trying this as part
of evaluating how much someone could hose a system
if we let them mount arbitrary FUSE servers.  And the
answer is: they could make it completely unusable,
requiring reboot.

I ran a later test that printed how deep it got into
the file tree and it was only a few hundred thousand
if I recall correctly.  A determined attacker might even
manage to do this in a normal file system.

But sure, it's not a common case.  ;-)

Russ
