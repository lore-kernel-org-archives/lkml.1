Return-Path: <linux-kernel-owner+w=401wt.eu-S1751105AbXBRQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbXBRQRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXBRQRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:17:21 -0500
Received: from mail.screens.ru ([213.234.233.54]:50581 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbXBRQRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:17:21 -0500
Date: Sun, 18 Feb 2007 19:19:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070218161953.GB143@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702181314.29214.rjw@sisk.pl> <20070218145246.GA80@tv-sign.ru> <200702181614.38315.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702181614.38315.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Rafael J. Wysocki wrote:
>
> On Sunday, 18 February 2007 15:52, Oleg Nesterov wrote:
> > 
> > And now another problem: exec. de_thread() sleeps in TASK_UNINTERRUPTIBLE
> > waiting for all sub-threads to die, and we have the same "deadlock" if
> > one of them is frozen. This is nasty. Probably we can change the ->state
> > to TASK_INTERRUPTIBLE and add try_to_freeze(), or play with the new PF_
> > flag, but I am not sure it is safe to freeze() the task which is deep
> > in the exec() path.
> 
> Hm, I haven't been aware of this case.
> 
> Well, probably we can do something like in the patch that I've just sent: the
> child that enters the refrigerator should know that the parent is
> uninterruptible and will wait for it to exit.  Thus it can either mark the
> parent as frozen or just exit the refrigerator without freezing itself.

Sub-thread could already sleep in refrigerator when another thread does exec.
So we have no choice but somehow freeze the execer. But again, I don't know
if it is safe to freeze it here, at de_thread() stage. It is called from
load_xxx_binary(), we may hold some important locks...

Oleg.

