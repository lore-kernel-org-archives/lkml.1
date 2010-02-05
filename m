Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab0BEEAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 23:00:01 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60202 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab0BEEAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 23:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t2IswNc19YHQsM+2yPUNSNtYFOzqp67JpkMgxNWQYT9+cQFx5Se+7IeRX3bOwdYHg0
         o22wsxcwZ7stHB44hUkRg/e80z5c+B1nU4F2nc52rhZuveQNui2XdzOZ1ivAJVvyszP0
         81IXrLnnWmrvIFumfZm4JYfUIsaY/nbPLbAkY=
Date: Fri, 5 Feb 2010 04:59:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: reiserfs deadlock
Message-ID: <20100205035953.GB5408@nowhere>
References: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com> <a4423d671002031108x6c2682edl9a147c35ac9c2815@mail.gmail.com> <20100203202909.GA5068@nowhere> <a4423d671002031443q283bab49wd15cd4de556d9557@mail.gmail.com> <20100203225232.GI5068@nowhere> <a4423d671002041746q1d918972i7c180d38a7c1d52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d671002041746q1d918972i7c180d38a7c1d52@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 04:46:38AM +0300, Alexander Beregalov wrote:
> Hi Frederic
> 
> Does it help?


Nope :-S

I need the full stracktraces. Plus the fact a thread holds
the reiserfs lock doesn't help much in this regard. This
is a drawback of lockdep: "holding" a lock in such lock dump
means either: the task holds the lock _or_ the task requests the
lock and block on it.

The only way to determine if a task really holds the reiserfs
lock is to look at the stack trace and see if it blocks on
reiserfs_write_lock_*() or something else. If this is something
else, then it means it really holds it, and there are fair
chances this is exactly the stacktrace we want: the one that
raised the softlockup.

Thanks!

