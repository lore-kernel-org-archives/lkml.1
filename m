Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYGWMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYGWMxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYGWMxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:53:10 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:44971 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbYGWMxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:53:10 -0400
Date: Wed, 23 Jul 2008 16:53:07 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jerome Arbez-Gindre <jeromearbezgindre@gmail.com>
Cc: linux-kernel@vger.kernel.org, deweerdt@free.fr
Subject: Re: New IDX in linux/connector.h ?
Message-ID: <20080723125307.GA12017@2ka.mipt.ru>
References: <a1d7a2f20807230540l4aa7e3f5i1511a2ea71fed8a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d7a2f20807230540l4aa7e3f5i1511a2ea71fed8a9@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerome.

On Wed, Jul 23, 2008 at 02:40:29PM +0200, Jerome Arbez-Gindre (jeromearbezgindre@gmail.com) wrote:
> Would it be possible to declare in linux/connector.h an IDX for the
> BB, without any restriction on the VAL the BB could use?

Sure. 
VAL (which is 'value' of course) is a private 'offset' inside given
index (IDX), so when you register single IDX all corresponding VALs
belong to the same user.

And some side notes.

I even wanted to have private indexes, i.e. those which are supposed to
be used by out-of-the-tree code, and no in-kernel users would ever touch
this numbers.

You actually can use your own private numbers as long they do not
correspond to currently loaded callbacks. Number of users in the header
is actually a hint, it does not play any role at all as long as number
of users is smaller than 32 (kernel stack allocates this bitmask by
default even if number of users/sockets is smaller).

There is also connector's itself own index (-1), used for requesting a
notifications about new connector users registrations, it can be
simply enough extended to provide dynamic index assignment.

-- 
	Evgeniy Polyakov
