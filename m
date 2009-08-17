Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbZHQXyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbZHQXyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZHQXyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:54:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZHQXyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:54:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
X-Fcc: ~/Mail/linus
Cc: Helge Deller <deller@gmx.de>, linux-parisc <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel segv with 2.6.31-rc6 ?
In-Reply-To: James Bottomley's message of  Monday, 17 August 2009 22:49:36 +0000 <1250549376.7858.96.camel@mulgrave.site>
References: <4A89CC4D.5040801@gmx.de>
	<1250549376.7858.96.camel@mulgrave.site>
X-Zippy-Says: RHAPSODY in Glue!
Message-Id: <20090817235438.8846B4730F@magilla.sf.frob.com>
Date: Mon, 17 Aug 2009 16:54:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The root cause is a duplicate section name (.text); is this legal?

It's a complicated subject, but I don't think they should ever actually
exist in a .ko.  The linker script for making .ko's should take care of
that.  But if modules do some crazy things like using section groups
(e.g. for COMDAT, i.e. compile C++ code into modules) then I'm not sure how
easy it is to get ld to combine things ideally as we'd like.

Suffice it to say that any occurrence of this merits further investigation.
It is certainly a red flag at first blush (as it were).

> However, there's a problem with commit
> 6d76013381ed28979cd122eb4b249a88b5e384fa in that if you fail to allocate
> a mod->sect_attrs (in this case it's null because of the duplication),
> it still gets used without checking in add_notes_attrs()
> 
> This should fix it

Yes, good catch.  Sorry about that complete failure of defensive programming.

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
