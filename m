Return-Path: <linux-kernel-owner+w=401wt.eu-S966312AbXEVQod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312AbXEVQod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbXEVQoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:44:25 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55222 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623AbXEVQoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:44:24 -0400
Date: Tue, 22 May 2007 18:35:05 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Paul Dickson <paul@permanentmail.com>
cc: Badari Pulavarty <pbadari@us.ibm.com>, bharata@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  5/14] Introduce union stack
In-Reply-To: <20070519031836.f86e8981.paul@permanentmail.com>
Message-ID: <Pine.LNX.4.61.0705221834410.4452@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094047.GG4139@in.ibm.com>
 <1179174187.2836.72.camel@dyn9047017100.beaverton.ibm.com>
 <20070519031836.f86e8981.paul@permanentmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 19 2007 03:18, Paul Dickson wrote:
>
>How about getting rid of the gotos:
>
>	while (fs) {
>		locked = union_trylock(fs->root);
>		if (locked) {
>			locked = union_trylock(fs->altroot);
>			if (locked) {
>				locked = union_trylock(fs->pwd);
>				if (locked)
>					break;

Suppose we break here...

>				else {
>					union_unlock(fs->altroot);
>					union_unlock(fs->root);
>				}
>			else
>				union_unlock(fs->root);
>			}
>		}
>		read_unlock(&fs->lock);
>		UM_DEBUG_LOCK("Failed to get all semaphores in fs_struct!\n");
>		cpu_relax();
>		read_lock(&fs->lock);
>	}
>	BUG_ON(!fs);

Then no lock is released. Boom.



	Jan
-- 
