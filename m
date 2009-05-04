Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZEDOB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZEDOB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbZEDOBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:01:49 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48478 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZEDOBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:01:48 -0400
From: Oliver Neukum <oliver@neukum.org>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] usb: use memdup_user()
Date: Mon, 4 May 2009 16:01:51 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Li Hong <lihong.hi@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com> <200905040854.03329.oliver@neukum.org> <200905040002.38304.david-b@pacbell.net>
In-Reply-To: <200905040002.38304.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905041601.51789.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. Mai 2009 09:02:38 schrieb David Brownell:
> On Sunday 03 May 2009, Oliver Neukum wrote:
> > No. To make it plain. To me any use of memdup_user() in USB code
> > is a bad idea. I don't want to have to think about a new primitive.
>
> Unless it's incorrect to use that, I have to say that it
> makes more sense to use that utility than recreate it by
> open-coding...

I want people to be forced to think about memory allocations.
We had endless trouble during 2.4 with storage deadlocking.
We simply need full control of this.

I prefer the explicite way for the same reason I prefer

if (rv < 0)
	goto err_out;

over

if (rv < 0)
	return rv;

In the former version you need to think about what you need to do
to cleanup.

	Regards
		Oliver

