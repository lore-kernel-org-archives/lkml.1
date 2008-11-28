Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYK1Nlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYK1Nlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYK1Nlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:41:32 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34884 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYK1Nlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:41:31 -0500
Date: Fri, 28 Nov 2008 13:41:19 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v4] relatime: Make relatime smarter
Message-ID: <20081128134119.GA5058@srcf.ucam.org>
References: <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127170615.GB14991@infradead.org> <20081127175813.GA24354@srcf.ucam.org> <20081127220839.GK3186@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127220839.GK3186@webber.adilger.int>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 03:08:39PM -0700, Andreas Dilger wrote:

> The one problem with a 1-day default is that cron jobs like updatedb will
> revert to updating the atime on every single file every day.  It would be
> better to make it slightly more than 1 day (e.g. 25h) to avoid this and
> at least defer atime updates to every other day for files that are not
> otherwise accessed except by cron.

I don't see the real benefit to this. If you want to prevent atime 
updates entirely, use noatime rather than relatime. Increasing the 
timeout just means that you get increased disk activity every other day 
rather than every day, which isn't really the problem we're trying to 
solve.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
