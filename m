Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbZBCXJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbZBCXJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZBCXJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:09:39 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37296 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZBCXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:09:38 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 3 Feb 2009 15:09:36 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jonathan Corbet <corbet@lwn.net>, mpm@selenic.com, dada1@cosmosbay.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, oleg@redhat.com, viro@ZenIV.linux.org.uk,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, hch@lst.de,
       linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
In-Reply-To: <20090203145346.8df40277.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902031508280.23050@alien.or.mcafeemobile.com>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org> <4988BD4E.8080206@cosmosbay.com> <20090203140543.6e915f97.akpm@linux-foundation.org>
 <1233699722.3243.127.camel@calx> <20090203153740.363d0a04@bike.lwn.net> <20090203145346.8df40277.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Andrew Morton wrote:

> Well.  We _could_ whack part of this nut with my usual hammer: protect
> f_flags with file->f_dentry->d_inode->i_lock.  IIRC there was some
> objection to that - performance?

If you meant it for epoll, that uses a single shared inode, that'd turn to 
be a global lock.


- Davide


