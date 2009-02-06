Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZBFAfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZBFAfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZBFAe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:34:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:34500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbZBFAe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:34:58 -0500
Date: Thu, 5 Feb 2009 16:35:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] input: introduce a tougher i8042.reset
Message-ID: <20090205163513.1a5d7308@infradead.org>
In-Reply-To: <20090205135229.e4d5efc3.akpm@linux-foundation.org>
References: <20090204191540.2d6abd87@infradead.org>
	<20090204191631.21783c62@infradead.org>
	<20090205135229.e4d5efc3.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 13:52:29 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 4 Feb 2009 19:16:31 -0800
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > Some touchpads don't reset right the first time (MSI Wind U-100 for
> > example). This patch will retry the reset up to 5 times.
> 
> Sigh, real life sucks.  I wonder what the windows driver does.

I have no idea; but this worked for me.
I bet the windows driver just retries as well.

> 
> > In addition, this patch also adds a module parameter to not treat
> > reset failures as fatal to the usage of the device. This prevents
> > a touchpad failure from also disabling the keyboard....
> > 
> 
> Is there any reason why we shouldn't just do this all the time?
> 
> IOW, is there any benefit in marking the 8042 as dead?

if it really is not there, then the kernel later will stall talking to
it.... for the "normal" headless server case.
At least I suppose. The input people need to jump in on this one.. I
didn't want to do a mass behavior change on something this fragile.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
