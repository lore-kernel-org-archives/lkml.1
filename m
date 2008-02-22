Return-Path: <linux-kernel-owner+w=401wt.eu-S936705AbYBVBjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936705AbYBVBjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932538AbYBVBjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:39:04 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:63250 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763884AbYBVBjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:39:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ETvHJVTEEsO9I3tHgQHNN+JwmDrokYYy9KXUTC7tcvoJJnRupe9SJhCEUi+ZsDswgpAtZacUIpITXYIvw0VlmIN+BpSx5JHSCHQWZeZr7b2zqM9HAIhsDnjZrFOwA6hIET2hd8snh4Jr0NLoHQGhojQKvU+AqWj7hDwL6PR1jxk=
Message-ID: <47BE27AE.8050009@gmail.com>
Date: Fri, 22 Feb 2008 10:38:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Max Krasnyanskiy <maxk@qualcomm.com>
CC: rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Module loading/unloading and "The Stop Machine"
References: <47ABC08C.8010101@qualcomm.com> <47B3BD51.1080706@gmail.com> <47BE245F.3030809@qualcomm.com>
In-Reply-To: <47BE245F.3030809@qualcomm.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyanskiy wrote:
> Thanks for the info. I guess I missed that from the code. In any case
> that seems like a pretty heavy refcounting mechanism. In a sense that
> every time something is loaded or unloaded entire machine freezes,
> potentially for several milliseconds. Normally it's not a big deal. But
> once you get more and more CPUs and/or start using realtime apps this
> becomes a big deal.

Module loading doesn't involve stop_machine last time I checked.  It's a
big deal when unloading a module but it's actually a very good trade off
because it makes much hotter path (module_get/put) much cheaper.  If
your application can't stand stop_machine, simply don't unload a module.

> And it's plain broken for the use case that I mentioned
> during CPU isolation discussions. ie When user-space thread(s) prevent
> stopmachine kthread from running, in which
> case machine simply hangs until those user-space threads exit.

This I don't know nothing about. :-)

-- 
tejun
