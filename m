Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYK0Wfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYK0Wfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 17:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYK0Wfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 17:35:32 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57088 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYK0Wfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 17:35:31 -0500
Date: Thu, 27 Nov 2008 15:35:14 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andreas Dilger <adilger@sun.com>
Cc: Matthew Garrett <mjg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v4] relatime: Make relatime smarter
Message-ID: <20081127223514.GP25548@parisc-linux.org>
References: <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127170615.GB14991@infradead.org> <20081127175813.GA24354@srcf.ucam.org> <20081127220839.GK3186@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127220839.GK3186@webber.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 03:08:39PM -0700, Andreas Dilger wrote:
> On Nov 27, 2008  17:58 +0000, Matthew Garrett wrote:
> > +	relatime_interval=
> > +			[FS] relative atime update frequency, in seconds.
> > +			(default: 1 day: 86400 seconds)
> 
> The one problem with a 1-day default is that cron jobs like updatedb will
> revert to updating the atime on every single file every day.  It would be
> better to make it slightly more than 1 day (e.g. 25h) to avoid this and
> at least defer atime updates to every other day for files that are not
> otherwise accessed except by cron.

Doesn't updatedb only access directories, not files?  I don't think
relatime implies nodiratime, but certainly the two could both be
specified, and that would fix one of the updatedb problems.  Are there
any other common cronjobs you're concerned about?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
