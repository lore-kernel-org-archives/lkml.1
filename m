Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbXIRBNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbXIRBNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 21:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXIRBNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 21:13:14 -0400
Received: from mail.fieldses.org ([66.93.2.214]:51519 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbXIRBNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 21:13:13 -0400
Date: Mon, 17 Sep 2007 21:12:57 -0400
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.22.6] nfsd: fh_verify() `malloc failure' with lots of
	free memory leads to NFS hang
Message-ID: <20070918011257.GC2443@fieldses.org>
References: <874phtkk25.fsf@hades.wkstn.nix> <20070917223600.GA30350@fieldses.org> <87zlzkkfvk.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zlzkkfvk.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 12:54:07AM +0100, Nix wrote:
> The code which calls new_do_write() looks like this:
> 
> ,----[ libio/fileops.c:_IO_new_file_xsputn() ]
> |  if (do_write)
> |    {
> |      count = new_do_write (f, s, do_write);
> |      to_do -= count;
> |      if (count < do_write)
> |        return n - to_do;
> |    }
> `----
> 
> This code handles partial writes followed by errors by returning a
> suitable nonzero value, and immediate errors by returning -1.
> 
> In either case the buffer will have been filled as much as possible by
> that point, and will still be filled when (vf)printf() is next called.

OK, I'm a little lost at this point (what's n?  What's to_do?), but I'll
take your word for it.

I'd be kinda curious when exactly the behavior changed and why.

Also I suppose we should check which version of nfs-utils that fix is in
and make sure distributions are getting the fixed nfs-utils before they
get the new libc, or we're going to see this bug a lot....

> This behaviour is, IIRC, mandated by the C Standard: I can find no
> reference in the Standard to streams being flushed on error, only
> on fclose(), fflush(), or program termination.

OK!

Let me know if the problem's fixed.

--b.
