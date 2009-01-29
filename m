Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZA2KcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZA2KcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZA2KcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:32:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZA2Kb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:31:59 -0500
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233224644.5294.52.camel@bugs-laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 11:31:49 +0100
Message-Id: <1233225109.4495.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 11:24 +0100, Thomas Pilarski wrote:
> Some explanation of the test program. 
> 
> ../schedulerissue 1 4096 8 2000
> 1 producer and 1 consumer
> buffer size of 4096 doubles * 8byte 
> 8 buffer (256kB total buffer)
> 2000 messages
> 
> ../schedulerissue 2 4096 8 2000
> 2 producer and 2 consumer
> buffer size of 4096 doubles * 8byte 
> 8 buffer (256kB total buffer)
> 2000 messages
> 
> 
> It was not 512KB bytes in the test before, but 4MB.
> But there is the same problem with a total buffer size of 48kB and 4
> threads (./schedulerissue 2 2048 3 20000).

Right, read the proglet (and removed that usleep(1)) and am poking at
it.

