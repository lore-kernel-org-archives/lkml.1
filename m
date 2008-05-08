Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbYEHIT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbYEHIT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYEHITP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:19:15 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:45554 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbYEHITM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:19:12 -0400
Date: Thu, 8 May 2008 11:19:06 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Morten Welinder <mwelinder@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
Message-ID: <20080508081906.GY3700@mea-ext.zmailer.org>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 03:49:30PM -0400, Morten Welinder wrote:
> Hi there,
> 
> deleting large files, say on the order of 4.6GB, takes approximately forever.
> Why is that?  Well, it is because a lot of things need to take place to free
> the formerly used space, but my real question is "why does the unlink caller
> have to wait for it?"

This very question has troubled SQUID developers.  Whatever the system, unlink()
that really does free diskspace does so with unbound timelimit and in services
where one millisecond is long wait time, the solution has been to run separate
subprocess that actually does the unlinks.

Squid is not threaded software, and it was created long ago when threads were
rare and implementations were different in subtle details --> no threads at all.

> Morten

  /Matti Aarnio
