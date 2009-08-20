Return-Path: <linux-kernel-owner+w=401wt.eu-S1751436AbZHTSgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbZHTSgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 14:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZHTSgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 14:36:38 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:34136 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZHTSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 14:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ILY65eoPUskfJw7Y2svYgf007ybpUdbva7waQ3VRO6j15xc4AE8zXo9qLHElh71R5m
         L/k9t5wvwj5rRJNCdLsZ7uBCD7OoSErwdhChq139VU0ghf6kOgtYK9HD5kej0EmfvZii
         LeDwQ01gaf7k4H0aPtQIzBsZ2gpFlpRFhAaJA=
Date: Thu, 20 Aug 2009 22:36:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: q-funk@iki.fi, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Bug #13941] x86 Geode issue
Message-ID: <20090820183635.GB8517@lenovo>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.R0.COIjKB@chimera> <11fae7c70908200033k7c28561eh28e1195ce4a692f8@mail.gmail.com> <200908201704.06553.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200908201704.06553.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rafael J. Wysocki - Thu, Aug 20, 2009 at 05:04:06PM +0200]
| On Thursday 20 August 2009, Martin-Éric Racine wrote:
| > Yes, it's still valid.
| 
| Thanks for the update.
| 
| > Screenshots of the crash have been provided. Is anything else missing
| > for the LKML to be able to debug and fix this?
| 
| An idea of what can be wrong?
| 
| > On Wed, Aug 19, 2009 at 11:26 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
| > > This message has been generated automatically as a part of a report
| > > of recent regressions.
| > >
| > > The following bug entry is on the current list of known regressions
| > > from 2.6.30.  Please verify if it still should be listed and let me know
| > > (either way).
| > >
| > >
| > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13941
| > > Subject         : x86 Geode issue
| > > Submitter       : Martin-Éric Racine <q-funk@iki.fi>
| > > Date            : 2009-08-03 12:58 (17 days old)
| > > References      : http://marc.info/?l=linux-kernel&m=124930434732481&w=4
| 
| Rafael
| 

Hi,

may I post a thought?

It seems strange to me that alloc_inode may set 

#ifdef CONFIG_FS_POSIX_ACL
	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
#endif

[where ACL_NOT_CACHED is #define ACL_NOT_CACHED ((void *)(-1))]

meanwhile say jffs2_init_acl_post use ACL_NOT_CACHED
as a valid value and trying to parse it.

But perhaps, I miss something.

	-- Cyrill
