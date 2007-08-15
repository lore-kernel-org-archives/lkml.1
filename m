Return-Path: <linux-kernel-owner+w=401wt.eu-S934720AbXHORe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbXHORe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934597AbXHORec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:34:32 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:3499 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934589AbXHOReb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:34:31 -0400
Message-ID: <46C33934.7060802@cfl.rr.com>
Date: Wed, 15 Aug 2007 13:34:44 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com>
In-Reply-To: <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 17:34:39.0759 (UTC) FILETIME=[8EB871F0:01C7DF62]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15364.000
X-TM-AS-Result: No--12.061600-5.000000-4
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> Going even further in this direction, the following POSIX ACL on the 
> directories will do what you want:
> 
> ## Note: file owner and group are kmoffett
> u::rw-
> g::rw-
> u:lsorens:rw-
> u:mtharp:rw-
> u:mperkel:rw-
> g:randomcvsdudes:r-
> default:u::rw-
> default:g::rw-
> default:u:lsorens
> default:u:mtharp:rw-
> default:u:mperkel:rw-
> default:g:randomcvsdudes:r-


The problem that I have with this setup is that it specifies an ACL on 
EACH file.  Yes, you can set a default on the directory for newly 
created files, but what if I want to add a user to the access list for 
that whole directory?  I have to individually update every acl on every 
file in that directory.  Also if you move a file created elsewhere into 
that directory, it retains its existing permissions doesn't it?  I would 
rather just add a new ace to the directory itself which specifies that 
it applies to the entire tree.  Then you only need to store a single acl 
on disk, and only have to update one acl to add a new user.

