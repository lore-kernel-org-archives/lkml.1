Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbYFUQig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbYFUQig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 12:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYFUQi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 12:38:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:50325 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYFUQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 12:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VFQT94rqaZyYt0Za62BC8lScsvN0ELGpjGee8tGtPOWFO1XUuczNkAxHV4ghAuQtdb
         /4hYiCofitIViOYsrfFz2syJ174SilT6WsKkMN8jABOZ4KbJWVTv1PNojam/YtGmID1r
         QnhrsdsUnwp/xoZC/GnQKcBSp9Fzy2p8Gqf+Y=
Message-ID: <e2e108260806210938k4ba12874t5f46e524ee188ab3@mail.gmail.com>
Date: Sat, 21 Jun 2008 18:38:24 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Eric Smith" <eric@brouhaha.com>
Subject: Re: Any lightweight way for one thread to force another thread to suspend execution?
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 1:54 AM, Eric Smith <eric@brouhaha.com> wrote:
> Is there any method for one thread to force another thread to suspend
> execution, then later let it resume, that is lighter weight than using
> signals?  I don't need it to be portable to anything other than Linux.
> The suspend needs to be synchronous, but resume doesn't.

Trying to suspend another thread synchronously is a bad idea because
this can easily trigger deadlocks. E.g. if you suspend a thread while
that thread holds a lock on a mutex, your application will deadlock.

Bart.
