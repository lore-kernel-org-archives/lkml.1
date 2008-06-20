Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYFTQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYFTQa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYFTQaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:30:11 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:23594 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752787AbYFTQaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:30:10 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 12:30:10 EDT
Message-ID: <485BD780.5090103@LiPPERTEmbedded.de>
Date: Fri, 20 Jun 2008 18:14:56 +0200
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: "r/o bind mounts" patch in 2.6.26-rc6 changes (breaks?) error
 behaviour
References: <485B8361.6010708@LiPPERTEmbedded.de>	 <1213971466.7512.17.camel@nimitz> <1213975689.7512.36.camel@nimitz>
In-Reply-To: <1213975689.7512.36.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jun 2008 16:15:20.0090 (UTC) FILETIME=[D5CB17A0:01C8D2F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> ... requires a path walk ...

... which is spared only in the error path, the normal path still does the path walk anyway.

> Don't you *want* warnings when an 'rm -f' runs into a r/o filesystem? ;)

Well, not really. The "rm -f"s are in my startup scripts, supposed to delete stale lock files and lots of stuff that's usually not there unless something went wrong the last time. But most of the time, I leave the whole system mounted R/O, except some tmpfs, dead useful for kernel/hardware hacking/testing.
But now I get masses of error messages on bootup - guess I have to litter the scripts with "if [ -e ... ]; then"s or just live with it.  :-|

Anyway, thanks for solving this mystery for me.  :-)

Jens
