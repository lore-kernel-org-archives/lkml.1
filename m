Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZA2SSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZA2SSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZA2SSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:18:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:48258 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZA2SSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:18:38 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Jan 2009 10:18:36 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] epoll remove debugging code
In-Reply-To: <20090129001251.7a39d957.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901291017550.15448@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271253010.20262@alien.or.mcafeemobile.com> <20090129001251.7a39d957.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Andrew Morton wrote:

> On Tue, 27 Jan 2009 12:54:58 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > static int ep_eventpoll_release(struct inode *inode, struct file *file)
> >  {
> > -	struct eventpoll *ep = file->private_data;
> > -
> > -	if (ep)
> > -		ep_free(ep);
> > +	if (file->private_data)
> > +		ep_free((struct eventpoll *) file->private_data);
> >  
> 
> The old version was better, IMO.
> 
> You could just do
> 
> 	if (file->private_data)
> 		ep_free(file->private_data);
> 
> but personally, I do like to see the purported type mentioned in there
> somewhere.  But preferably not in a typecast.

I thought you liked less lines of code :) It's OK with me if you want it 
back the way it was.


- Davide


