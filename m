Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbZEZX3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbZEZX3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757013AbZEZX3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:29:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756883AbZEZX3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:29:12 -0400
Date: Tue, 26 May 2009 16:28:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: andi@firstfloor.org, paul@mad-scientist.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-Id: <20090526162821.02e11d5b.akpm@linux-foundation.org>
In-Reply-To: <20090526231428.GK846@one.firstfloor.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
	<878wkjobbm.fsf@basil.nowhere.org>
	<20090526160017.98fc62e4.akpm@linux-foundation.org>
	<20090526231428.GK846@one.firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 01:14:28 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, May 26, 2009 at 04:00:17PM -0700, Andrew Morton wrote:
> > dump_write() doesn't seem right, either.  If ->write() returns, say,
> > 100 then the dump should keep on going.  At present it treats this
> > return as an error.
> 
> I think that's correct actually. Short write typically means serious 
> issue like disk full or broken pipe, so stopping is good.

But we shouldn't assume that.  It could be that the ->write
implementation is perfectly able to absorb the remaining data.

We should only error out of the write() returned zero or -EFOO.
The current code is simply buggy, but got lucky.

