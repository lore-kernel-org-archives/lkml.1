Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYJBXpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYJBXpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYJBXo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:44:56 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:42236 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753514AbYJBXoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:44:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lM6RREdy71JlBRiNUDgwgMl/+nrMdycvJhsWZi1VhX9RupDL3eFuk1mylwfodJyHI2jvaajsLIwEdbo2flwQCLCb3WkcpbsVuEqEyWZ1pzu5RcVSNVzE2jfRmNis8mJrbWRqaour/ob8PysIJwOz7CXy3Ekfqi+Xh3E6i0nMLLU=  ;
X-YMail-OSG: qcWoHmkVM1m4mfV.TVoEzlR3VrupJC8xSg3nXiBiQwOqa59ozO0XIZpUGjZ523oZrQLr3VefLvLkrZaE42ACwXZmClgb2ivZZm9cfgQ64iRozuQ0vDHtHGJ64M17MbEVNq3_1G_m3ADXhXMQ1C.q6mT_
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc: fix kernel panic on second use of SIGIO nofitication
Date: Thu, 2 Oct 2008 16:44:51 -0700
User-Agent: KMail/1.9.9
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, stable@kernel.org
References: <20080914181122.GA32250@joi> <20081002144941.18211dbb.akpm@linux-foundation.org> <20081003001238.7030c151@i1501.lan.towertech.it>
In-Reply-To: <20081003001238.7030c151@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021644.51962.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2008, Alessandro Zummo wrote:
> On Thu, 2 Oct 2008 14:49:41 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 14 Sep 2008 20:11:27 +0200
> > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > 
> > > When user space uses SIGIO notification and forgets to disable it before
> > > closing file descriptor, rtc->async_queue contains stale pointer to struct
> > > file. When user space enables again SIGIO notification in different process,
> > > kernel dereferences this (poisoned) pointer and crashes.
> > > 
> > > So disable SIGIO notification on close.
> > > 
> > 
> > David, Alessandro: can we please have a review-n-ack of this one for
> > 2.6.27 and earlier?  
> > 
> > Thanks.
> > 
> > From: Marcin Slusarz <marcin.slusarz@gmail.com>
> > 
> > When userspace uses SIGIO notification and forgets to disable it before
> > closing file descriptor, rtc->async_queue contains stale pointer to struct
> > file.  When user space enables again SIGIO notification in different
> > process, kernel dereferences this (poisoned) pointer and crashes.
> > 
> > So disable SIGIO notification on close.
> 
>  [...]
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
> > Cc: David Brownell <dbrownell@users.sourceforge.net>
> > Cc: <stable@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
>  
>  Acked-by: Alessandro Zummo <a.zummo@towertech.it>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Seemed "obviously good" anti-oops medicine to me, then I double
checked against some code that is AFAIK still correct..
