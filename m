Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbXL3KVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbXL3KVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 05:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXL3KVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 05:21:36 -0500
Received: from [194.117.236.238] ([194.117.236.238]:58688 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXL3KVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 05:21:35 -0500
Date: Sun, 30 Dec 2007 12:17:25 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: pharon@gmail.com
Cc: Rene Herman <rene.herman@keyaccess.nl>, "David P. Reed" <dpreed@reed.com>,
       Richard Harman <richard@richardharman.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071230121725.11d05099@linux360.ro>
In-Reply-To: <1198979361.11150.2.camel@iamer-laptop>
References: <47765D11.2040903@reed.com>
	<1198967334.5049.3.camel@iamer-laptop>
	<4776F6A0.9010801@keyaccess.nl>
	<1198979361.11150.2.camel@iamer-laptop>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007 03:49:21 +0200
Islam Amer <pharon@gmail.com> wrote:

> So what I understand now is that AMD C1E state saves battery like
> dynticks, so we don't need dynticks ?

No, it's not true.

C1E currently saves more power than dynticks just
because these platforms do not support higher C-states (like C2 and
C3). So, if we want to enable the current dynticks implementation, we
have to disable C1E, so we're left only with C1 (the old plain 'hlt'),
which isn't that great.

Other kernel developers, as discussed previously in this thread, are
working on a HPET-driven dynticks (as opposed to the current
LAPIC-driven one), but the change isn't that easy to make. This way,
dynticks and C1E could be both enabled and thus save more power.

Moreover, as I previously stated, dynticks isn't just about power
saving.

Note that this problem is only related to AMD64 multi-core laptops. As
far as I can see, devs might not invest much coding effort into this
and instead say "Go buy an Intel laptop!", as this really is a hardware
quirk. And if Andi Kleen is correct, this is not just a laptop vendors'
problem, but AMD itself doesn't offer support for higher C-states.
