Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbXDZUa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbXDZUa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbXDZUa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:30:56 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34556 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbXDZUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:30:51 -0400
To: jengelh@linux01.gwdg.de
CC: ebiederm@xmission.com, miklos@szeredi.hu, akpm@linux-foundation.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, hpa@zytor.com
In-reply-to: <Pine.LNX.4.61.0704262107130.506@yvahk01.tjqt.qr> (message from
	Jan Engelhardt on Thu, 26 Apr 2007 21:10:04 +0200 (MEST))
Subject: Re: [patch] unprivileged mounts update
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu>
 <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <m1r6q8s735.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.61.0704262107130.506@yvahk01.tjqt.qr>
Message-Id: <E1HhAYu-000361-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 26 Apr 2007 22:27:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Apr 25 2007 11:21, Eric W. Biederman wrote:
> >>
> >> Why did we want to use fsuid, exactly?
> >
> >- Because ruid is completely the wrong thing we want mounts owned
> >  by whomever's permissions we are using to perform the mount.
> 
> Think nfs. I access some nfs file as an unprivileged user. knfsd, by
> nature, would run as euid=0, uid=0, but it needs fsuid=jengelh for
> most permission logic to work as expected.

I don't think knfsd will ever want to call mount(2).

But yeah, I've been convinced, that using fsuid is the right thing to
do.

Miklos
