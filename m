Return-Path: <linux-kernel-owner+w=401wt.eu-S1161766AbXDXNfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161766AbXDXNfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161765AbXDXNfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:35:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39551 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161767AbXDXNfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:35:11 -0400
Date: Tue, 24 Apr 2007 14:34:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, rusty@rustcorp.com.au
Subject: Re: [PATCH] kthread: Spontaneous exit support
Message-ID: <20070424133450.GA5633@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
	linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
	rusty@rustcorp.com.au
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969596686-git-send-email-ebiederm@xmission.com> <20070419162459.af7a182c.akpm@linux-foundation.org> <20070422194455.GA18561@infradead.org> <m1fy6rzsug.fsf_-_@ebiederm.dsl.xmission.com> <20070423112537.GA21941@infradead.org> <Pine.LNX.4.61.0704241507460.2490@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704241507460.2490@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 03:08:57PM +0200, Jan Engelhardt wrote:
> >I don't think having to parallel APIs is a good idea, people will
> >get utterly confused which one to use.  Better always grab a reference
> >in kthread_create and drop it in kthread_stop.  For normal thread
> >no change in behaviour and only slightly more code in the slowpath.
> 
> I *am* already confused... a driver of mine does:
> 
> static __init int thkd_init(void)
> {
> 	touch_task = kthread_run(touch_thread, Device, "thkd");
> 	...
> }
> 
> and
> 
> static __exit void thkd_exit(void)
> {
> 	kthread_stop(touch_task);
> 	/* I bet something is missing */
> }
> 
> now what good would kthread_run do me?

Please read the kerneldoc documentation for kthread_create
