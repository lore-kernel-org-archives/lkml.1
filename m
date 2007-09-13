Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbXIMUKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbXIMUKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761893AbXIMUK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:10:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755451AbXIMUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:10:27 -0400
Date: Thu, 13 Sep 2007 13:09:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: viro@ftp.linux.org.uk, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Credentials test patch
In-Reply-To: <1577.1189713412@redhat.com>
Message-ID: <alpine.LFD.0.999.0709131304510.16478@woody.linux-foundation.org>
References: <1577.1189713412@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Sep 2007, David Howells wrote:
> 
> Here's a patch that implements a very basic set of COW credentials. 

That "current_cred" thing is really too ugly to live.

Why is it trying to make it look like a variable? That will just confuse 
people, and/or make them think it's a cheap thing rather than some complex 
function call.

Also, why does the "__current_cred()" function have those illogical and 
insane "#ifdef CONFIG_KEYS" things in it, when it cannot be used/work 
sanely without it (and when the header file does a

	+#ifndef CONFIG_KEYS
	+#define __current_cred()       ({ current->cred; })
	+#else
	..

anyway?)

IOW, this patch should be taken out and shot, for apparently actively 
trying to obfuscate what the heck is going on.

		Linus
