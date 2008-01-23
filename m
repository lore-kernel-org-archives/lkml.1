Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbYAWTdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbYAWTdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYAWTda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:33:30 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38485 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYAWTd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:33:28 -0500
To: hpa@zytor.com
CC: pavel@ucw.cz, miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
In-reply-to: <47978F5D.8010006@zytor.com> (hpa@zytor.com)
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu> <4792DF11.7040403@zytor.com> <E1JGVSG-0003mx-TS@pomaz-ex.szeredi.hu> <20080123134926.GB4059@ucw.cz> <47978F5D.8010006@zytor.com>
Message-Id: <E1JHlLA-0003jk-Ee@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Jan 2008 20:32:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pavel Machek wrote:
> > On Sun 2008-01-20 09:23:00, Miklos Szeredi wrote:
> >>> Miklos Szeredi wrote:
> >>>> - for mount ID's use IDA (from the IDR library) instead of a 32bit
> >>>>   counter, which could overflow
> >>> IDAs tend to get reused quickly, which can cause race conditions.  Any 
> >>> reason not to just use a 64-bit counter?
> >> They tend to become hard to parse/compare for humans after a while.
> >> And all this is basically only for humans, so race conditions don't
> >> really matter.  Also a changed mount with a reused ID is easily
> >> identified by comparing the other fields.
> > 
> > Hmm, smart humans only compare last few digits if they don't care
> > about 100% reliability, and dumb software compares 64bits easily...
> > 							Pavel
> 
> Indeed.
> 
> And this is most certainly NOT only for humans, and race conditions most 
> certainly matter.

Use case please?  What will this info be used for, other than for
feedback for humans about the state of the propagation tree?

Face it, userspace is inherently racy.  Inode numbers, device numbers,
whatever are being reused all the time, we live with it, even if it's
programs, and not just humans.

But it's not even an important design decision, the ID allocation can
be swapped at any time.  If you insist, I'll change it to a 64bit
counter, and it'll just suck a little more, but no permanent damage
done ;)

Miklos
