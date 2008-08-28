Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYH1RtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYH1RtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYH1RtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:49:00 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56308 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753856AbYH1Rs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:48:59 -0400
Date: Thu, 28 Aug 2008 13:48:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Markku Savela <msa@moth.iki.fi>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Frustrated with capabilities..
Message-ID: <20080828174854.GM26987@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Markku Savela <msa@moth.iki.fi>, Pavel Machek <pavel@suse.cz>,
	linux-kernel@vger.kernel.org
References: <87hc96by8x.fsf@burp.tkv.asdf.org> <20080828141826.GA6797@ucw.cz> <200808281445.m7SEjYsB007502@burp.tkv.asdf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808281445.m7SEjYsB007502@burp.tkv.asdf.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 05:45:34PM +0300, Markku Savela wrote:
> 
> > From: Pavel Machek <pavel@suse.cz>
> 
> > Yes, you need upcoming filesystem capabilities.  Binary may not
> > inherit capabilities unless filesystem flags permit that.
> 
> I think this is wrong. Normal executables inherit uid/gid and
> supplementary groups by default. Why should capabilities be any
> different?

Well, because that's not the what the POSIX draft specification (and
the rest of the Unix industry who were striving to meet the US
Department of Defense's "B2 by '92" initiative) ended up implementing.

The reason for that was to avoid bugs where a program that wasn't
expecting to be setuid (or just written by a stupid progammer) exec's
some program which wasn't expecting to have root privileges then bad
things happen.  The classic example of this was running the mail
program, which was setuid or setgid to the mail user/group, and then
typing "!/bin/sh" which would exec a shell running with those
privileges (because the mail program didn't know to drop its
privileges).

So in the capabilities model, the capabilities do *not* inherit unless
the a particular file explicitly states that it should inherit the
capabilities.  It's the principle of least privilege taken to its
logical conclusion.

						- Ted
