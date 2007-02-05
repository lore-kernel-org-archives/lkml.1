Return-Path: <linux-kernel-owner+w=401wt.eu-S933477AbXBEVgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477AbXBEVgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933475AbXBEVgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:36:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55509 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXBEVgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:36:01 -0500
Date: Mon, 5 Feb 2007 21:35:30 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070205213530.GA9794@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
	linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070202161611.cf8b4328.akpm@linux-foundation.org> <20070203003536.GA619@khazad-dum.debian.net> <1170710913.6105.39.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170710913.6105.39.camel@nigel.suspend2.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 08:28:33AM +1100, Nigel Cunningham wrote:
> Why do you think remounting filesystems is necessary? Are you getting
> problems with some particular filesystem?
> 
> If I recall correctly, we briefly tried remounting filesystems in
> Suspend2, but it created problems with logging - some files open r/w
> were readonly afterwards.

Yes, that's the biggest problem with the forced remount r/o hack -
FMODE_WRITE is dropped from all files, and can't be recovered.
(and at the same time in progress writes or writes through shared
mmaps are totally ignored).

> We then tried bdev freezing with much better success.

Yes, that's the right thing to do if you want to be safe, but
we already had that discussion..

