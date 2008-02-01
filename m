Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYBAKTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYBAKTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYBAKTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:19:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693AbYBAKTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:19:06 -0500
Date: Fri, 1 Feb 2008 02:19:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kenichi Okuyama" <kenichi.okuyama@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] NULL pointer check for vma->vm_mm
Message-Id: <20080201021917.5db3448d.akpm@linux-foundation.org>
In-Reply-To: <3fd7d7a70802010024q22b4d179mf56e6d4b60e4f574@mail.gmail.com>
References: <3fd7d7a70801312339p2a142096p83ed286c81379728@mail.gmail.com>
	<20080131235544.346b938a.akpm@linux-foundation.org>
	<3fd7d7a70802010024q22b4d179mf56e6d4b60e4f574@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008 17:24:17 +0900 "Kenichi Okuyama" <kenichi.okuyama@gmail.com> wrote:

> First of all, thank you for looking at the patch.
> 
> I do agree that if mm is NULL, system will call Oops anyway.
> However, since it's oops, it does not stop the system, nor call kdump.

That would be a huge bug in kdump?  Surely it dumps when the kernel oopses?

> By calling BUG_ON(), it'll gives us chance of calling kdump at the first chance.
> 
> Since this is very rare to happen, I thought we should capture the incident
> whenever possible. On other hand, because BUG_ON macro is very light,
> I thought this will not harm any performance...
> 
> Forgive me in advance if I was wrong.
> I still think checking mm with BUG_ON here is better than counting on Oops.

But there are probably a million potential NULL-pointer dereferences in the 
kernel.  Why single out this one?
