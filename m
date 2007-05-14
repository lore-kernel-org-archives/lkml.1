Return-Path: <linux-kernel-owner+w=401wt.eu-S1761871AbXENCFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761871AbXENCFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 22:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbXENCFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 22:05:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbXENCFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 22:05:37 -0400
Date: Sun, 13 May 2007 18:58:07 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Soeren Sonnenburg <kernel@nn7.de>, linux-input@atrey.karlin.mff.cuni.cz,
       nicolas@boichat.ch, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: [PATCH] Make appletouch shut up when it has nothing to say
Message-Id: <20070513185807.18222a0d.zaitcev@redhat.com>
In-Reply-To: <20070513195724.GA28493@srcf.ucam.org>
References: <1178995886.4168.10.camel@localhost>
	<20070513172052.GA26712@srcf.ucam.org>
	<20070513114626.d943999a.zaitcev@redhat.com>
	<20070513195724.GA28493@srcf.ucam.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 20:57:25 +0100, Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Ok, I've tidied this up a little. [...]

Looks fine here... well, almost. Did you try rmmod (I don't even know if
it's applicable, sorry)? Usually, when schedule_work is involved, you want
to make sure that a scheduled work won't be run when the module is gone.
More often, a device removal is the issue, but as I take it, such is not
possible for a built-in device :-) . In most cases, all it takes is a
strategically placed flush_scheduled_work().

-- Pete
