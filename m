Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbXIMNiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbXIMNiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbXIMNiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:38:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:64751 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbXIMNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hEERCh3ZlHrBVhl29Gjq36gANRZyGv1IXAVMBHxYENukRh2Aw5RFCch/6RM+d4jvyE9pBSdblQYU2RjoS6w3+OZm/99inRK74i9v0AjQqcg6vuLvLXQey1oUyLt+EAzoAsIlwqYB/Dqo82SlFGKcVEByG3jzvisQzVCYXJYvuF8=
Message-ID: <a4e6962a0709130638v384c2708y76167d4e92cbac56@mail.gmail.com>
Date: Thu, 13 Sep 2007 08:38:06 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Subject: Re: [PATCH] 9p: rename uid and gid parameters
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070913044718.GB2675@ionkov.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070913044718.GB2675@ionkov.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
> Change the names of 'uid' and 'gid' parameters to the more appropriate
> 'dfltuid' and 'dfltgid'.
>

...

>         strcpy(v9ses->name, V9FS_DEFUSER);
>         strcpy(v9ses->remotename, V9FS_DEFANAME);
> +       v9ses->dfltuid = V9FS_DEFUID;
> +       v9ses->dfltgid = V9FS_DEFGID;
>
...
> +#define V9FS_DEFUID    (0)
> +#define V9FS_DEFGID    (0)

I'm not sure if there is a good solution here, but I'm uncomfortable
with using uid=0 as the default.  I'm not sure if there is a default
uid for nobody, but anything is probably better than 0.  Looks like
nfsnobody is 65534, we could use that - even if only as a marker for
the server to map it to nobody on the target system?  What do you
think?

Particularly with attach-per-user, we probably need to look at
interacting with idmapd or create our own variant real soon.

              -eric
