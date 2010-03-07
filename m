Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab0CGFr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 00:47:59 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55824 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab0CGFr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 00:47:57 -0500
To: sam@synack.fr
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, hadi@cyberus.ca, kaber@trash.net,
       zbr@ioremap.net, nhorman@tuxdriver.com, root@localdomain.pl,
       linux-security-module@vger.kernel.org, serue@us.ibm.com
Subject: Re: [RFC v2 00/10] snet: Security for NETwork syscalls
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1267561394-13626-1-git-send-email-sam@synack.fr>
	<201003030156.o231udx1023055@www262.sakura.ne.jp>
	<m2zl2lpa4d.fsf@ssh.synack.fr>
In-Reply-To: <m2zl2lpa4d.fsf@ssh.synack.fr>
Message-Id: <201003071447.IAH35984.OJVFLOtQFFOSHM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 7 Mar 2010 14:47:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samir Bellabes wrote:
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:
> 
> > Regarding [RFC v2 02/10] Revert "lsm: Remove the socket_post_accept() hook"
> > @@ -1538,6 +1538,8 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
> >  	fd_install(newfd, newfile);
> >  	err = newfd;
> >  
> > +	security_socket_post_accept(sock, newsock);
> > +
> >  out_put:
> >  	fput_light(sock->file, fput_needed);
> >  out:
> >
> > Please move security_socket_post_accept() to before fd_install().
> > Otherwise, other threads which share fd tables can use
> > security-informations-not-yet-updated accept()ed sockets.
> 
> Tetsuo, what about this patch ?
> 
Looks OK to me. Thanks.
