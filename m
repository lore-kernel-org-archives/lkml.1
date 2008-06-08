Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbYFHLCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbYFHLCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbYFHLBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:01:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:35037 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbYFHLBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pmXkmnO8WGheshETk71MKIL6pyQdt/THHc1gbeYSBABiJ9AqQkY+jfD8yetoD3Xsig
         ryIh6HeMfdy6k2Ve/zeRJ3llbHcvKEqAwYrPbt9I5w/xvOnWaMrS0NCfzojnLd2F8NZG
         N9cOBj/vpMK4zIWltSOkNVVgxE4+Z/rwZMW/w=
Date: Sun, 8 Jun 2008 13:01:06 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] v4l: saa7134: fix multiple clients access (and
	oops)
Message-ID: <20080608110103.GA5856@joi>
References: <20080607224835.GA25025@joi> <20080608063104.GA5608@joi> <20080608073255.67b8233c@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608073255.67b8233c@gaivota>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 07:32:55AM -0300, Mauro Carvalho Chehab wrote:
> On Sun, 8 Jun 2008 08:31:07 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > On Sun, Jun 08, 2008 at 12:48:35AM +0200, Marcin Slusarz wrote:
> > > (...)
> > 
> > This patch is stupid. Please ignore.
> 
> Patch ignored. Yet, it seemed ok to my eyes. We shouldn't stop/deallocate
> resources if there is still someone using the module.

But when there's at least one user, dev->empress_users will be bigger than 0,
so second call to ts_open will return -EBUSY.
And it lead to conclusion, that there's only one possible user...

Marcin
