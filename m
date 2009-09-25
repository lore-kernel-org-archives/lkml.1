Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbZIYLCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbZIYLCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZIYLCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:02:46 -0400
Received: from mga12.intel.com ([143.182.124.36]:47415 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbZIYLCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:02:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,451,1249282800"; 
   d="scan'208";a="191600154"
Date: Fri, 25 Sep 2009 11:56:36 +0100
From: Alan Cox <alan@linux.intel.com>
To: "jeff.chua.linux" <jeff.chua.linux@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-2.6.31 INIT: open(/dev/console): Input/output error (due
 to  commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
Message-ID: <20090925115636.5b4b8aca@linux.intel.com>
In-Reply-To: <b6a2187b0909240923t4e8d61f4g6d82b7f9f9bf621b@mail.gmail.com>
References: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>
	<20090924160136.44e31ad0@lxorguk.ukuu.org.uk>
	<b6a2187b0909240923t4e8d61f4g6d82b7f9f9bf621b@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 00:23:27 +0800
"jeff.chua.linux" <jeff.chua.linux@gmail.com> wrote:

> On Thu, Sep 24, 2009 at 11:01 PM, Alan Cox <alan@lxorguk.ukuu.org.uk>
> wrote:
> > It is timing dependant. A discussion and some fixes were posted a
> > while ago.
> 
> I must have missed that. Will try to search for it.
> 
> Thanks,
> Jeff

>From Andrew's tree:

     tty: fix regression caused by "tty: make the kref destructor occur
     asynchronously"

which allows both a sync and an async element to the destruction
cleanup. The console uses the synchronous one which avoids the delay
before it becomes available again.

