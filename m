Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZEYXN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZEYXN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZEYXNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:13:19 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43581 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZEYXNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:13:18 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Tue, 26 May 2009 01:13:46 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905260045.33902.oliver@neukum.org> <200905260058.54482.rjw@sisk.pl>
In-Reply-To: <200905260058.54482.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260113.46440.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Mai 2009 00:58:53 schrieb Rafael J. Wysocki:
> On Tuesday 26 May 2009, Oliver Neukum wrote:

> > No, I am afraid it is not. The average user has no clue. Even if that
> > is not the problem, the user never knows for sure he has encountered
> > the worst case.
>
> OK there, but surely it's better to have a sysfs attribute than a fixed
> value?

Why? The driver knows best. Tunables are generally the worst solution.

> > If you really have drivers that have exceptionally large memory
> > requirements (eg. you need to copy video ram), you should tell the system
> > through struct driver and do accounting at probe and removal of devices.
>
> Or perhaps the drivers should allocate memory from a PM notifier (which is
> called before the freezing of tasks) to avoid the problem?

That's also possible. It is slightly more wasteful, as you are required
to actually the memory. If you tell the core, it is sufficient that the memory
can be freed without a device driver becoming involved, that is the page
must be cleaned but doesn't have to be dropped.

	Regards
		Oliver

