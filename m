Return-Path: <linux-kernel-owner+w=401wt.eu-S1765304AbZAPQmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765304AbZAPQmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZAPQmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:42:25 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35150 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256AbZAPQmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:42:24 -0500
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, t-sato@yk.jp.nec.com
In-Reply-To: <1232122907.15209.3.camel@norville.austin.ibm.com>
References: <496EB639.6090800@redhat.com>
	 <20090115162031.a512232b.akpm@linux-foundation.org>
	 <497003CC.8030503@redhat.com>
	 <1232122907.15209.3.camel@norville.austin.ibm.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 10:42:21 -0600
Message-Id: <1232124141.15209.8.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 10:21 -0600, Dave Kleikamp wrote:
> On Thu, 2009-01-15 at 21:49 -0600, Eric Sandeen wrote:

> > oh, hrm.  Maybe I didn't think enough about how it's handed off to
> > pdflush; I could rearrange if that makes sense?  Or maybe handing to
> > pdflush is wrong, it was just so convenient....
> 
> I don't understand the reason for handing it to pdflush.  I would expect
> thaw to be very fast.  Do we expect it to block anywhere, and if so, for
> very long?  Not that I see any problem with it.

Eric pointed out on irc that this is in interrupt context, so even
taking a mutex is not allowed.  I now agree that handing it to pdflush
is reasonable.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

