Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbXBRTBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbXBRTBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 14:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXBRTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 14:01:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbXBRTBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 14:01:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Sun, 18 Feb 2007 19:14:44 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702181614.38315.rjw@sisk.pl> <20070218161953.GB143@tv-sign.ru>
In-Reply-To: <20070218161953.GB143@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181914.45757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 17:19, Oleg Nesterov wrote:
> On 02/18, Rafael J. Wysocki wrote:
> >
> > On Sunday, 18 February 2007 15:52, Oleg Nesterov wrote:
> > > 
> > > And now another problem: exec. de_thread() sleeps in TASK_UNINTERRUPTIBLE
> > > waiting for all sub-threads to die, and we have the same "deadlock" if
> > > one of them is frozen. This is nasty. Probably we can change the ->state
> > > to TASK_INTERRUPTIBLE and add try_to_freeze(), or play with the new PF_
> > > flag, but I am not sure it is safe to freeze() the task which is deep
> > > in the exec() path.
> > 
> > Hm, I haven't been aware of this case.
> > 
> > Well, probably we can do something like in the patch that I've just sent: the
> > child that enters the refrigerator should know that the parent is
> > uninterruptible and will wait for it to exit.  Thus it can either mark the
> > parent as frozen or just exit the refrigerator without freezing itself.
> 
> Sub-thread could already sleep in refrigerator when another thread does exec.
> So we have no choice but somehow freeze the execer. But again, I don't know
> if it is safe to freeze it here, at de_thread() stage. It is called from
> load_xxx_binary(), we may hold some important locks...

So it probably isn't safe.

Rafael

