Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZHRDzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZHRDzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZHRDzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:55:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43442 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbZHRDzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:55:48 -0400
Subject: Re: kernel segv with 2.6.31-rc6 ?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Helge Deller <deller@gmx.de>, linux-parisc <linux-parisc@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200908181248.52572.rusty@rustcorp.com.au>
References: <4A89CC4D.5040801@gmx.de>
	 <1250549376.7858.96.camel@mulgrave.site>
	 <200908181248.52572.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 22:55:43 -0500
Message-Id: <1250567744.15255.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 12:48 +0930, Rusty Russell wrote:
> On Tue, 18 Aug 2009 08:19:36 am James Bottomley wrote:
> > The root cause is a duplicate section name (.text); is this legal?
> 
> I'd be happy to fail to load it.  There might be sysfs issues with it
> too.

Well, that's why I want clarification.  The bad code has been in since
2007 so it looks like a recent change, probably the one to more default
linker scripts is the cause.

> > However, there's a problem with commit
> > 6d76013381ed28979cd122eb4b249a88b5e384fa in that if you fail to allocate
> > a mod->sect_attrs (in this case it's null because of the duplication),
> > it still gets used without checking in add_notes_attrs()
> > 
> > This should fix it
> 
> No, the real problem is that it ignores failure.  I'd much rather fail
> the module load than various features mysteriously MIA.

There are two separate problems.  One is why the the module has
duplicate sections.  Under my reading of the ELF spec, they seem to be
allowable ... however we control the linker scripts and I believe we
shouldn't have generated them.

The other is the missing error handling in the module loader.

The question of whether this is a generic failure that needs load
refusal or an expected artifact of our new linker scripts needs
investigating.

> Which brings us to "patches which don't go thru the maintainer" (or
> perhaps, non-responsive maintainers who get bypassed).

Well, the original code was in 2007, so it's probably a bit late for a
postmortem.

James


