Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0CFRlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:41:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36698 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0CFRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:41:09 -0500
Date: Sat, 6 Mar 2010 17:41:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>
Subject: Re: Selinux going crazy in 2.6.34-rc0
Message-ID: <20100306174106.GC30031@ZenIV.linux.org.uk>
References: <20100306102919.GA2341@core.coreip.homeip.net>
 <20100306104946.GB30031@ZenIV.linux.org.uk>
 <20100306172727.GA13120@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306172727.GA13120@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 09:27:27AM -0800, Dmitry Torokhov wrote:

> > Interesting...  That smells like a selinux policy that needed recognition
> > of inotify file descriptors and got b0rken by
> > commit c44dcc56d2b5c79ba3063d20f76e5347e2e418f6
> > that switched inotify to use of anon_inodes.  Could you check if that's the
> > trigger?
> 
> Yep, that was it. With this commit reverted selinux stays quiet.
> Well, almost, it is never completely quiet ;).
> 
> Thank you Al.

Hrm...  Folks, does anybody have suggestions on what to do about that one?
I can revert that thing, of course, but I wonder what's really going on
in the policy that triggers that spew...
