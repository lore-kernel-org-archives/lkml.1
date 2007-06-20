Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbXFTWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbXFTWrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXFTWrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:47:04 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36888 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXFTWrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:47:01 -0400
Message-ID: <4679AE5E.4050001@zytor.com>
Date: Wed, 20 Jun 2007 15:46:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Karel Zak <kzak@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620220551.GX7226@petra.dvoda.cz> <20070620224135.GC6258@gallifrey>
In-Reply-To: <20070620224135.GC6258@gallifrey>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
> 
> What happens with the (sick) case of spaces in directory names?
> Also is it really nicely defined that there is no way to put a space
> in an option in any of the filesystems?   I suppose someone
> particularly sick could have a device node in a directory with a space
> in it.  It would be nice if new formats for this are being defined
> to make it cover everything.
> 

That's already handled just fine:

bash-3.1$ mkdir /tmp/'Jag är: \
en liten mask'
bash-3.1$ sudo mount -t tmpfs none '/tmp/Jag är: \
en liten mask'/
bash-3.1$ tail -1 /proc/mounts
none /tmp/Jag\040är:\040\134\012en\040liten\040mask tmpfs rw 0 0
bash-3.1$

	-hpa
