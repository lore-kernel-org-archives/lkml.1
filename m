Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZKHRCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZKHRCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZKHRCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:02:02 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52864 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbZKHRCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:02:01 -0500
Date: Sun, 8 Nov 2009 18:01:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com, jamie@shareable.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091108170157.GA1389@ucw.cz>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu> <20091105131545.72b4e319@lxorguk.ukuu.org.uk> <E1N63Io-000353-KX@pomaz-ex.szeredi.hu> <20091106141742.GA1428@ucw.cz> <m17hu3xtiy.fsf@fess.ebiederm.org> <E1N6g3B-0006UZ-1R@pomaz-ex.szeredi.hu> <m13a4qsiap.fsf@fess.ebiederm.org> <E1N6jWB-0006gu-2u@pomaz-ex.szeredi.hu> <m1y6mipnc4.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6mipnc4.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The only really weird case Alan spotted is device nodes, where the
> > actual device registered to a major/minor pair changes over time,
> > possibly allowing a re-open to access a device it otherwise was not
> > meant to.  BTW if the device number reuse happens really quickly, this
> > could even be a race for a plain open.  Real solution might actually
> > be in udev: when deregistering a device, change mode bits to all-zero
> > before removing the device node.
> 
> Devices nodes specifically were the case I was thinking of.
> 
> Changing the mode bits to all-zero at the final unlink would be a lot
> more reliable and certain in the kernel.

Does it really close the race completely?

					udev sets 660
open does permission checks
					device disappears
					chmod 000
					new device appears
					udev chmods 600
open returns new device

?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
