Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbXE3WYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbXE3WYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbXE3WY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:24:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761631AbXE3WY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:24:26 -0400
Message-ID: <465DF91F.3010201@sandeen.net>
Date: Wed, 30 May 2007 17:22:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net>
In-Reply-To: <465DF0B4.2050203@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:

> Jan, something seems busted here.  I'm getting lockups when testing udf
> on a single cpu with this last patch in place...
> 
> I think it's the BKL stumbling on itself.

To demonstrate, try this:

# BIGFILENAME=`seq -s '' 1 1000`
# ln -s $BIGFILENAME foo

instant deadlock :(

-Eric
