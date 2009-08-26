Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbZHZMim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbZHZMim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbZHZMim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:38:42 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:35925 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbZHZMil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:38:41 -0400
Message-ID: <4A952CCE.5050908@gmail.com>
Date: Wed, 26 Aug 2009 14:38:38 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: clement.lecigne@netasq.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] 8 bytes kernel memory disclosure in AppleTalk getsockname.
References: <20090826111247.GA79673@clem1.netasq.com> <200908262101.DBJ57868.OHOFFVLQOtMFSJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200908262101.DBJ57868.OHOFFVLQOtMFSJ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 26 Aug 2009 14:38:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa a écrit :
> Clement LECIGNE wrote:
>> Here is a patch that zero the whole sockaddr_at structure before
>> processing it. It should fix this bug.
> 
> Same kind of bug at http://lkml.org/lkml/2006/7/25/51 .
> I wonder why not zero'ing sockaddr at the caller rather than
> zero'ing at individual ->getname(). Doing so will save some lines.
> --

It would not help zeroing buffer before calling ->getname(), since
getname() will overwrite it with a memcpy(buffer, &somestruct, sizeof(somestruct));


