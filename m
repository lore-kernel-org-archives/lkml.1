Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbZA1OOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbZA1OOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZA1ONz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:13:55 -0500
Received: from vena.lwn.net ([206.168.112.25]:34009 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZA1ONy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:13:54 -0500
Date: Wed, 28 Jan 2009 07:13:51 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090128071351.3643800e@bike.lwn.net>
In-Reply-To: <20090128042337.GA15060@redhat.com>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122203248.GA20159@infradead.org>
	<20090123045646.GK15750@one.firstfloor.org>
	<20090127165504.53ed7a2d.akpm@linux-foundation.org>
	<20090128031439.GA11025@redhat.com>
	<20090127205739.1384343f@bike.lwn.net>
	<20090128042337.GA15060@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 05:23:37 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> But please don't forget it is not strictly necessary f_op->fasync()
> must use fasync_helper(). And we have users (pipe_rdwr_fasync) which
> call fasync_helper() twice.

Understood.  Any such change will certainly require an audit of all
in-tree fasync() implementations; that's part of why it's taking a
little while.  But it also cleans things up and solves the atomicity
problems nicely, so I think it's worth trying.

jon
