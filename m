Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYJIQEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYJIQEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbYJIQE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:04:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42010 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYJIQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:04:26 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org>
	(message from Linus Torvalds on Thu, 9 Oct 2008 08:37:50 -0700 (PDT))
Subject: Re: splice vs O_APPEND
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org>
Message-Id: <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Oct 2008 18:04:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008, Linus Torvalds wrote:
> I do wonder if we shouldn't just do this in rw_verify_area(). The whole 
> reason for that function is that we used to have all those flock checks 
> etc spread out all over, and some path would inevitably just miss one 
> check or another. It's kind of stupid to expect low-level filesystems to 
> do the IS_APPEND/IS_IMMUTABLE checks.

Do we expect them?  I thought we don't care if it's marked immutable
or append-only after the file has been opened, same as with normal
permissions.

> Comments?

Your patch still ignores O_APPEND, is that what we want?  It sounds
sort of strange.  pwrite() for example honors O_APPEND and ignores the
position, AFAICS.

Miklos
