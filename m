Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYBONIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYBONIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYBONH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:07:56 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22084 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYBONH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:07:56 -0500
Message-ID: <47B58EAA.8040405@msgid.tls.msk.ru>
Date: Fri, 15 Feb 2008 16:07:54 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement barrier support for single device DM devices
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com>
In-Reply-To: <20080215122002.GM29914@agk.fab.redhat.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alasdair G Kergon wrote:
> On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
>> Implement barrier support for single device DM devices
>  
> Thanks.  We've got some (more-invasive) dm patches in the works that
> attempt to use flushing to emulate barriers where we can't just
> pass them down like that.

I wonder if it's worth the effort to try to implement this.

As far as I understand (*), if a filesystem realizes that the
underlying block device does not support barriers, it will
switch to using regular flushes instead - isn't it the same
thing as you're trying to do on an MD level?

Note that a filesystem must understand barriers/flushes on
underlying block device, since many disk drives don't support
barriers anyway.

(*) this is, in fact, an interesting question.  I still can't
find complete information about this.  For example, how safe
xfs is if barriers are not supported or turned off?  Is it
"less safe" than with barriers?  Will it use regular cache
flushes if barriers are not here?  Ditto for ext3fs, but
here, barriers are not enabled by default.

/mjt
