Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZESUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZESUmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 16:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZESUmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 16:42:06 -0400
Received: from thunk.org ([69.25.196.29]:48594 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZESUmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 16:42:05 -0400
Date: Tue, 19 May 2009 16:41:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: John Stoffel <john@stoffel.org>
Cc: David Watson <kernel-nospam@dbwatson.ukfsn.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Message-ID: <20090519204152.GE9053@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	John Stoffel <john@stoffel.org>,
	David Watson <kernel-nospam@dbwatson.ukfsn.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.yJG.DA0DKB@chimera> <20090518132517.GL32019@mit.edu> <20090519171713.GA3354@dbwatson.ukfsn.org> <20090519175312.GC9053@mit.edu> <18962.64002.324970.49512@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18962.64002.324970.49512@stoffel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 02:27:14PM -0400, John Stoffel wrote:
> I wonder if this is the reason my main file server has been locking up
> solid under 2.6.29 or newer kernels lately, but 2.6.28 is rock solid.
> Since it's my main file server at home, and with my home dir NFS
> mounted from it onto another system, it's been hard to catch.  I spent
> some time fiddling around getting netconsole setup, but then I ran out
> of time.

Unless you have your partition mounted with the "sync" mount option
(which has negative performance implifications; it makes sense for a
mail queue directory, but not necessarily for a general purpose file
server) or you have a directory chattr'ed with the sync flag, probably
not...

If you want to try it, though, the patch is available here:

   http://bugzilla.kernel.org/attachment.cgi?id=21436

> If someone could send me the patch, I'll apply it and see how well
> 2.6.29.[34] works, and whether or not 2.6.30-rcN works as well.
> Reproducing the problem was pretty easy for me.  

Anything on the console?  Any oops messages, or soft lockup warnings?

What filesystem(s) are you using? 


						- Ted
