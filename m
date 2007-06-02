Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXFBAiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXFBAiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbXFBAh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:37:57 -0400
Received: from gw.goop.org ([64.81.55.164]:41323 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbXFBAh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:37:56 -0400
Message-ID: <4660BBDF.1040007@goop.org>
Date: Fri, 01 Jun 2007 17:37:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <466087CF.70708@goop.org> <4660924A.2070009@zytor.com> <466093E3.4010701@goop.org> <46609636.4050208@zytor.com>
In-Reply-To: <46609636.4050208@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Well, if we define is as a movable object then it has to be treated as
> such.  It's a protocol definition issue.  If we define it opaque, though
> -- of for that matter, if we don't -- we should define what memory it
> can live in, though.  Right now, the only "available" memory we have is
> end of setup to 0xa0000; the command line is defined to be allocated
> from this memory.
>   

Well, I think we can safely say that its something that's only
meaningful in 32/64-bit mode, so we aren't constrained by the real-mode
address space.

One of my goals in this project is to make the boot image, in some way,
completely define which memory it needs it get started.  That means that
the boot loader can either place things knowing they'll avoid the boot
image and/or definitively know that the image is unloadable.

So I don't think its strictly necessary to pre-define what memory this
object can use, since I think it can be safely determined dynamically.

    J
