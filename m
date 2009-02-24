Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZBXGZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZBXGZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZBXGZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:25:51 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59021 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZBXGZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:25:50 -0500
Subject: Re: Another Performance Regression in write() syscall
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Dave Hansen <haveblue@us.ibm.com>,
       nickpiggin@yahoo.com.au, Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090224060558.GA14812@google.com>
References: <20090224060558.GA14812@google.com>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 22:25:45 -0800
Message-Id: <1235456745.26788.237.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 22:05 -0800, Salman Qazi wrote:
> Analysis of profile data has led us to believe that the commit
> 3d733633a633065729c9e4e254b2e5442c00ef7e has caused a performance
> regression.  This commit provides for tracking of writers so that read only
> bind mounts function correctly.
> 
> We can verify this regression by applying the following patch to partially
> disable the above-mentioned commit and then running the fstime component
> of Unixbench.  The settings used were 256 byte writes with MAX_BLOCK of 2000.

I'm a bit surprised that write() is what is regressing.  Unless I
screwed up, we do all the expensive accounting at open()/close() time.
Is this a test that gets run in parallel on multiple cpus?  

Could you take a look at Nick's patches to speed this stuff up?

	http://thread.gmane.org/gmane.linux.file-systems/28186

We may need to dust those off, although I'm still a bit worried about
the complexities of open-coding all the barriers.

Could we also see some kind of profile?  What kind of machine are you
seeing this on, btw?

-- Dave

