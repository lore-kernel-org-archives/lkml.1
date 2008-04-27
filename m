Return-Path: <linux-kernel-owner+w=401wt.eu-S1763534AbYD0T3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763534AbYD0T3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762239AbYD0T2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:28:53 -0400
Received: from lazybastard.de ([212.112.238.170]:33483 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762209AbYD0T2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:28:52 -0400
Date: Sun, 27 Apr 2008 21:27:37 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Chinner <dgc@sgi.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080427192736.GA21979@logfs.org>
References: <20080419142329.GA5339@elte.hu> <200804210945.24479.vda.linux@googlemail.com> <480C96BC.4020400@sandeen.net> <200804212151.02241.vda.linux@googlemail.com> <20080422012819.GT108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080422012819.GT108924158@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 April 2008 11:28:19 +1000, David Chinner wrote:
> On Mon, Apr 21, 2008 at 09:51:02PM +0200, Denys Vlasenko wrote:
> 
> > Why xfs code is said to be 5 timed bigged than e.g. reiserfs?
> > Does it have to be that big?
> 
> If we cut the bulkstat code out, the handle interface, the
> preallocation, the journalled quota, the delayed allocation, all the
> runtime validation, the shutdown code, the debug code, the tracing
> code, etc, then we might get down to the same size reiser....

Just noticed this bit of FUD.  Last time I did some static analysis on
stack usage, reiserfs alone would blow away 3k, while xfs was somewhere
below.  Reiserfs was improved afaik, but I'd still expect it to be worse
than xfs until shown otherwise.

Maybe reiserfs simply isn't used that much in nfs+*fs+md+whatnot+scsi
setups?

Jörn

-- 
Courage is not the absence of fear, but rather the judgement that
something else is more important than fear.
-- Ambrose Redmoon
