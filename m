Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbYK0WJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbYK0WJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 17:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYK0WIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 17:08:52 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59562 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYK0WIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 17:08:51 -0500
Date: Thu, 27 Nov 2008 15:08:39 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH v4] relatime: Make relatime smarter
In-reply-to: <20081127175813.GA24354@srcf.ucam.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Message-id: <20081127220839.GK3186@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20081126195457.GA3541@srcf.ucam.org>
 <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com>
 <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org>
 <20081127163535.775729bf@lxorguk.ukuu.org.uk>
 <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org>
 <20081127170615.GB14991@infradead.org> <20081127175813.GA24354@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 27, 2008  17:58 +0000, Matthew Garrett wrote:
> +	relatime_interval=
> +			[FS] relative atime update frequency, in seconds.
> +			(default: 1 day: 86400 seconds)

The one problem with a 1-day default is that cron jobs like updatedb will
revert to updating the atime on every single file every day.  It would be
better to make it slightly more than 1 day (e.g. 25h) to avoid this and
at least defer atime updates to every other day for files that are not
otherwise accessed except by cron.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

