Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbXEQQOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbXEQQOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 12:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbXEQQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 12:14:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:9234 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbXEQQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 12:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V5oOl8KnEdZZMKGqkkKa4NMPtIoSVEe+Db/z3vfX9NO2epotin23RzZ+72xqgRoSPE9/e9jQQmkUJT/wRx23OCTX/t1qsBps0AVnCFaj8UoANqqFyxNFa/i2ccSHWgyVHGtW3CnXtRparf0F4X98iOpx73hNEK/f7VpsXp8dn/I=
Message-ID: <a36005b50705170914i17bd853bj638f5098c4e7d788@mail.gmail.com>
Date: Thu, 17 May 2007 09:14:06 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH] uselib: add missing MNT_NOEXEC check
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070517135526.GA28213@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070517135526.GA28213@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Christoph Hellwig <hch@lst.de> wrote:
> We don't allow loading ELF shared library from noexec points so the
> same should apply to sys_uselib aswell.

Correct.  But...

>         error = -EINVAL;
> +       if (nd.mnt->mnt_flags & MNT_NOEXEC)
> +               goto exit;

... the error here should be EACCES.  Aside from that you get an ACK from me.
