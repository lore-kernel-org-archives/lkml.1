Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZALEWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZALEWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 23:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZALEWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 23:22:02 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2117 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZALEWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 23:22:00 -0500
Date: Mon, 12 Jan 2009 05:21:39 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: "Diego E. 'Flameeyes' =?ISO-8859-1?Q?Petten=F2?=" 
	<flameeyes@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Warren Turkal <wt@penguintechs.org>
Subject: Re: 2.6.29 -mm merge plans
In-Reply-To: <1231284433.5158.2.camel@localhost>
Message-ID: <Pine.LNX.4.64.0901120442280.28002@localhost.localdomain>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> 
 <20090106225744.GA10553@infradead.org>  <20090106151747.c640dfd4.akpm@linux-foundation.org>
  <20090106231958.GA30271@infradead.org> <1231284433.5158.2.camel@localhost>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-57660524-1231731821=:28002"
Content-ID: <Pine.LNX.4.64.0901120444070.28002@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-57660524-1231731821=:28002
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0901120444071.28002@localhost.localdomain>

Hi,

On Wed, 7 Jan 2009, Diego E. 'Flameeyes' Pettenò wrote:

> Yes that one wasn't good at all, and I feel sorry for not having noticed
> that before sending it in the first place.

In general you could also use the create_date field to initialize the 
generation field (it's set in hfsplus_cat_build_record and should be read 
in hfsplus_cat_read_inode). (BTW OS X doesn't use create_date because it 
can be changed by the user, which isn't an issue for Linux).
I have some doubts about the hfsplus_get_parent() function. One has to 
know about HFS+ that every hard link has it's own link id (which is 
usually not visible) and the common inode id. If you lookup the parent 
like this you expose the usually hidden and private directory.
The link id is stored in d_fsdata under Linux, which seems not to be 
restored by hfsplus_fh_to_dentry(), so any catalog manipulations are 
likely to hit the wrong catalog entry. Any catalog change requires the 
correct link id, but with just the common id you currently can't find back 
the link entry.
Newer HFS+ OS X driver support a link chain, which would make it possible 
to find back the link entry using the common id and create_date in case 
the normal file became a hard link, but this isn't implemented under Linux 
yet.
So it seems the hard link handling may need a bit more work...

bye, Roman
--8323328-57660524-1231731821=:28002--
