Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXKVSaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXKVSaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXKVSaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:30:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42466 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbXKVSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:30:09 -0500
Date: Thu, 22 Nov 2007 10:29:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why is FIBMAP ioctl root only?
Message-ID: <20071122102951.24e4e781@laptopd505.fenrus.org>
In-Reply-To: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz>
References: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 19:17:14 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hi,
> 
>   I guess subject says it all - why is FIBMAP ioctl restricted only to
> root (CAP_SYS_RAWIO)? Corresponding ioctl for XFS is allowed without
> any special capabilities so we are inconsistent here too...
>   Would anyone mind if the check is removed?

probably principle of least privilege; the location on physical media
for a file is clearly something internal to the OS, and non-trusted
users normally don't have any business knowing that. 

I can't think of any immediate exploitable thing with it, but I'm sure
attackers would find a way to use it to increase their privilege once
they can do something like "write 512 bytes to a disk address of my
choice".. (but then again it's game over mostly already)

> 
> 								Honza


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
