Return-Path: <linux-kernel-owner+w=401wt.eu-S935245AbZJOSg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245AbZJOSg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935232AbZJOSg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935231AbZJOSg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:36:28 -0400
Date: Thu, 15 Oct 2009 14:35:41 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       esandeen@redhat.com, cebbert@redhat.com
Subject: Unnecessary overhead with stack protector.
Message-ID: <20091015183540.GA8098@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	esandeen@redhat.com, cebbert@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

113c5413cf9051cc50b88befdc42e3402bb92115 introduced a change that
made CC_STACKPROTECTOR_ALL not-selectable if someone enables CC_STACKPROTECTOR.

We've noticed in Fedora that this has introduced noticable overhead on
some functions, including those which don't even have any on-stack variables.

According to the gcc manpage, -fstack-protector will protect functions with
as little as 8 bytes of stack usage. So we're introducing a huge amount
of overhead, to close a small amount of vulnerability (the >0 && <8 case).

The overhead as it stands right now means this whole option is unusable for
a distro kernel without reverting the above commit.

	Dave

