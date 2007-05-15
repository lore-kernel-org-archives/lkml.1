Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXEOIoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXEOIoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbXEOIor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:44:47 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:64072 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbXEOIoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DKZADDYjqwWwBbe374Tl5LqJ/96gw+oaqEVOm16Pu7TXkSNYDm4PTzjZaQPokcZXYcps4ujkUpslw2VMtTfGri89rWbpE0Zoy7NsYqKMj419qyiTvF/O2inQRyRT4BobSJc2Uhx9QtPwabW7dgpxtnkG48JyosHgoSPxPZReutw=
Date: Tue, 15 May 2007 16:50:16 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de, akpm@osdl.org
Subject: Re: __must_check (stir the pot :-))
Message-ID: <20070515085016.GB3838@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de, akpm@osdl.org
References: <20070515173146.505952d1.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515173146.505952d1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 05:31:46PM +1000, Stephen Rothwell wrote:
>So I am looking at "fixing" some of the warning produced by __must_check
>but then I see (things like):
>
>drivers/base/core.c: In function 'device_add':
>drivers/base/core.c:714: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
>drivers/base/core.c:719: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
>drivers/base/core.c:722: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
>drivers/base/core.c:728: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
>drivers/base/core.c: In function 'device_rename':
>drivers/base/core.c:1187: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
>drivers/base/core.c:1197: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
>
>and things like this in drivers/base/sys.c:
>
>int sysdev_create_file(struct sys_device * s, struct sysdev_attribute * a)
>{
>        return sysfs_create_file(&s->kobj, &a->attr);
>}
>
>where sysfs_create_file() is marked __must_check and sysdev_create_file()
>isn't.
>
>So the questions come to mind:  Do we really care if our core
>infrastructure doesn't?  Can we care if the core infrastructure doesn't
>propogate the error returns?
>
>Flame away, I am prepared to ignore all opinions :-)


Hi!

I had noticed these warnings yet and had tried to fix them. But these ones are not relatively easy to fix, since they are nested in some complex contexts.

Can we leave this job to Greg? (Add some CCs below.)

CC: gregkh@suse.de
CC: akpm@osdl.org


Regards!

WANG Cong

