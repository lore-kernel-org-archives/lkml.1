Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbXHBLGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbXHBLGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbXHBLG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:06:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442AbXHBLG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:06:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 2/3] Freezer: Use wait queue instead of busy looping
Date: Thu, 2 Aug 2007 13:15:18 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708012328.23939.rjw@sisk.pl> <200708012332.48798.rjw@sisk.pl> <20070801164831.ed40546d.akpm@linux-foundation.org>
In-Reply-To: <20070801164831.ed40546d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021315.18851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 2 August 2007 01:48, Andrew Morton wrote:
> On Wed, 1 Aug 2007 23:32:48 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > +/*
> > + * Used to notify try_to_freeze_tasks() that the refrigerator has been entered
> > + * by a task.
> > + */
> > +static int refrigerator_called;
> 
> this is rather icky.

Well, the alternative would be to open code something like wait_event_timeout.
