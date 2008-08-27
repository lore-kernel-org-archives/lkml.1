Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYH0QwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYH0QwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYH0QwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:52:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52958 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752675AbYH0QwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:52:04 -0400
Date: Wed, 27 Aug 2008 17:32:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, dhowells@redhat.com,
       Andreas Gruenbacher <agruen@suse.de>,
       "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Message-ID: <20080827173236.2198786e@lxorguk.ukuu.org.uk>
In-Reply-To: <26995.1219853604@redhat.com>
References: <20080827160439.GA12085@us.ibm.com>
	<200808262057.51606.agruen@suse.de>
	<20080827135206.GA12919@us.ibm.com>
	<200808271729.18220.agruen@suse.de>
	<26995.1219853604@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008 17:13:24 +0100
David Howells <dhowells@redhat.com> wrote:

> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > (Also note that if you have such users, you'll want to ask David Howells not
> > to push the patch he has floated removing the ability to pass caps to
> > another task altogether when CONFIG_SECURITY_FILE_CAPABILITIES=n :)
> 
> Ugh.  My patch removes the ability to pass caps to another task under all
> circumstances because to do otherwise means that I have to make the kernel use
> RCU locking for a task to access its own creds.  If you want this, I'll have
> to redo all my later patches.

That gets foul in another way - bounding the worst case RCU
memory utilisation if someone is sitting doing things like while(1)
change_credentials();
