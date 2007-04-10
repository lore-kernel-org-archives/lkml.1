Return-Path: <linux-kernel-owner+w=401wt.eu-S1031005AbXDJQN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031005AbXDJQN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031007AbXDJQN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:13:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43607 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031005AbXDJQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:13:26 -0400
Date: Tue, 10 Apr 2007 17:16:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
Cc: "Robert Hancock" <hancockr@shaw.ca>, <linux-kernel@vger.kernel.org>
Subject: Re: Help Understanding Linux memory management
Message-ID: <20070410171631.4844afe8@the-village.bc.nu>
In-Reply-To: <AD98412A5373CC4AA643D9C021922A541C4DC8@cdskitexg01.cds.int>
References: <461B9BED.6030208@shaw.ca>
	<AD98412A5373CC4AA643D9C021922A541C4DC8@cdskitexg01.cds.int>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 10:31:34 -0400
"Mouawad, Tony" <Tony.Mouawad@christiedigital.com> wrote:

> When vm.overcommit_memory = 2 and there appears to be about 2M of memory
> readily available and about 12M of memory allocated to pagecache (this
> is info gathered from /proc/meminfo) , a call to malloc(5000000) returns
> NULL.  I would have expected that somehow, the call to malloc(5000000)
> would request the memory in pagecache to be released for use by the app.

That can only be done if the memory in the page cache is not being used.
In a system with swap it is possible for anonymous pages to be pushed to
disk, on a system without swap only unchanged disk mapped pages such as
executable progam pages (some of them anyway) can be thrown out if they
are still in use.

More importantly overcommit is address *space* not pages. It deals with
the theoretical worst cases and ensure that a page write won't cause an
out of memory situation. That means it is more pessimistic than the usual
workload. It also by default allows lots of room for worst case kernel
behaviour that is appropriate to a real system with swap but not embedded
so you may well want to tune that via the overcommit ratio proc interface

Alan
