Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbZBRWv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbZBRWv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759234AbZBRWs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:48:26 -0500
Received: from THUNK.ORG ([69.25.196.29]:52147 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760312AbZBRWsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:48:25 -0500
Date: Wed, 18 Feb 2009 16:29:57 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andres Freund <andres@anarazel.de>
Cc: Alex Buell <alex.buell@munted.org.uk>, adilger@sun.com,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Jonathan Bastien-Filiatrault <joe@x2a.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4 ENOSPC Bug
Message-ID: <20090218212957.GR3600@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andres Freund <andres@anarazel.de>,
	Alex Buell <alex.buell@munted.org.uk>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
References: <20090216162028.3032666a@lithium.local.net> <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan> <499AF598.7080400@anarazel.de> <499C7B41.1090800@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C7B41.1090800@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:18:57PM +0100, Andres Freund wrote:
> On one of the machines I got several thousand of:
>
> [10379.575904] ext4: find_group_flex failed, fallback succeeded dir 416319
> [10379.576002] ext4: find_group_flex failed, fallback succeeded dir 416319
> [10379.579981] ext4: find_group_flex failed, fallback succeeded dir 416319
> [10379.580097] ext4: find_group_flex failed, fallback succeeded dir 416319
> (with different directories)

Ok, that's good.  Good to know the workaround works.  

Can you send me a dumpe2fs of the filesystem in question?  I'm curious
what was going on...

> No userspace visible behaviour.
>
> So it seems you were right. It seems sensible to put that patch without  
> printk in the kernel until the issue is fully solved...

Thanks for the report.  I'll push the workaround patch to Linus for
2.6.29 to avoid this problem for now.  I recently sent to linux-ext4
for comment a patch to revamp the Orlov allocator for flex_bg and to
use that instead of find_group_flex(), but no way that's going into
2.6.29 at this point....

							- Ted
