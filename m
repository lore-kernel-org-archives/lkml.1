Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYAQTdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYAQTdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYAQTdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:33:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYAQTdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:33:22 -0500
Message-ID: <478FABDF.1020002@zytor.com>
Date: Thu, 17 Jan 2008 14:26:23 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, drepper@redhat.com,
       Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Extending syscalls
References: <25712.1200582125@vena.lwn.net>
In-Reply-To: <25712.1200582125@vena.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> 
> Heh, indeed.  But we do seem to have a recurring problem of people
> wanting to extend sys_foo() beyond the confines of its original API.
> I've observed a few ways of doing that:
> 
>  - create sys_foo2() (or sys_foo64(), or sys_fooat(), or sys_pfoo(),
>    or...) and add the new stuff there.
> 
> The first approach has traditionally been the most popular.  If we have
> a consensus that this is the way to extend system calls in the future,
> it would be nice to set that down somewhere.  We could avoid a lot of
> API blind alleys that way.
> 

I would argue it is the right approach.  It lets the kernel system call 
entry dispatch directly to the system call for the "new" case, and to a 
compatibility thunk for the "old" case.  It has the following desirable 
properties:

- No overhead for the "new" case.
- Minimal overhead for the "old" case.
- Easily dealt with by tools like strace that examine system calls.

	-hpa
