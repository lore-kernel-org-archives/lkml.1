Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXHTAxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXHTAxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbXHTAxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:53:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46048 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXHTAxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:53:05 -0400
Date: Mon, 20 Aug 2007 01:52:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Message-ID: <20070820005246.GX21089@ftp.linux.org.uk>
References: <20070819225546.GV21089@ftp.linux.org.uk> <C0FCB07A-EE48-4ABB-96A7-470C53C86A38@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C0FCB07A-EE48-4ABB-96A7-470C53C86A38@cam.ac.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 01:27:13AM +0100, Anton Altaparmakov wrote:

> And what the cast was doing I can't remember.  I may well have just  
> copied it from the VFS or I was perhaps trying to silence a warning  
> and this happened to work...

... due to sparse bug (it miscalculated address space of pointed to,
picking top-level qualifiers for some reason; __user pointer to char
and pointer to __user char gave the same result and so did __user long).
That cast still made no sense...
