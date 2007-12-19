Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbXLST0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbXLST0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXLSTZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:25:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:16306 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbXLSTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=L8S6IL2ZSLdHmdPgMtxNmehHNe07+efqxsxICADpDzhN44BYx1jOi9zocj0jM1q/hDiv/zr8HdEBblX0XmsC4/xmX99/Gdvog+Ldp3nQTBA1mPhH4yemj1P5eHXoOJh48gcA/awqJqWIFacmzKMaByLZAIQ4UsZj3J2ie2tVlW4=
Date: Wed, 19 Dec 2007 20:27:20 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 5/6] udf: fix signedness issue
Message-ID: <20071219192707.GA18305@joi>
References: <20071216021556.GF26986@joi> <20071217163216.GI6979@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071217163216.GI6979@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 05:32:17PM +0100, Jan Kara wrote:
> > sparse generated:
> > fs/udf/namei.c:896:15: originally declared here
> > fs/udf/namei.c:1147:41: warning: incorrect type in argument 3 (different signedness)
> > fs/udf/namei.c:1147:41:    expected int *offset
> > fs/udf/namei.c:1147:41:    got unsigned int *<noident>
> > fs/udf/namei.c:1152:78: warning: incorrect type in argument 3 (different signedness)
> > fs/udf/namei.c:1152:78:    expected int *offset
> > fs/udf/namei.c:1152:78:    got unsigned int *<noident>
> >
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
>   I don't think this is right. udf_get_fileident() should take "unsigned
> int *" as an offset, not just "int". This means changing struct
> udf_fileident_bh to use unsigned int too but that is better anyway.
>   And BTW the type shouldn't be uint32_t but really unsigned int in
> udf_rename (int needn't have 32 bits on all archs (although I think it
> has currently)).
That would be hard. Look what is happening with soffset and eoffset
eg in udf_fileident_read() - these fields are used as signed ints.

Marcin
