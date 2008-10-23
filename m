Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYJWQct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYJWQct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbYJWQch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:32:37 -0400
Received: from saeurebad.de ([85.214.36.134]:58372 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbYJWQcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:32:36 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrea Righi <righi.andrea@gmail.com>, Dave Jones <davej@redhat.com>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: lockdep splat from ioctl and mmap fops sharing lock
References: <87ljwgj8p1.fsf@saeurebad.de> <87ej27jtvx.fsf@saeurebad.de>
	<49009375.1070209@s5r6.in-berlin.de>
Date: Thu, 23 Oct 2008 18:32:26 +0200
In-Reply-To: <49009375.1070209@s5r6.in-berlin.de> (Stefan Richter's message of
	"Thu, 23 Oct 2008 17:08:37 +0200")
Message-ID: <8763njjmqt.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> Johannes Weiner wrote:
>> raw1394_ioctl() doing usercopy under fi->state_mutex
>> raw1394_mmap() taking fi->state_mutex under mmap_sem
>
> The state_mutex in raw1394 however was introduced by me in patches
> written against 2.6.26 and 2.6.27-rcs.  And I tested the ioctls and I'd
> like to think that I also tested mmaps.  But maybe I didn't.  Of course
> I ahve all sorts of lockdep options enabled.
>
> So, was the usage of mmap_sem changed after 2.6.27 or were my tests
> insufficient?

In linux-next/-mm, copy_to/from_user have lockdep annotations telling
that they might fault and therefor acquire the mmap_sem in #PF.

But since faults on ioctl parameters are so rare, without these
annotations you would probably never see a warning.

        Hannes
