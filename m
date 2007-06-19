Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbXFSVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbXFSVC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbXFSVCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:02:49 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:36817 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbXFSVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:02:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18040.17518.714866.200801@stoffel.org>
Date: Tue, 19 Jun 2007 17:02:38 -0400
From: "John Stoffel" <john@stoffel.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: John Stoffel <john@stoffel.org>, Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
       alan <alan@clueserver.org>
Subject: Re: Versioning file system
In-Reply-To: <20070619203843.GU8154@parisc-linux.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org>
	<4673182B.4090800@redhat.com>
	<46739E89.1080003@hawkeye.stone.uk.eu.org>
	<46781A5B.9090104@redhat.com>
	<4678292B.6000804@hawkeye.stone.uk.eu.org>
	<4678369C.7070908@redhat.com>
	<467837AB.4030607@hawkeye.stone.uk.eu.org>
	<18040.15842.698982.608861@stoffel.org>
	<20070619203843.GU8154@parisc-linux.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Matthew> On Tue, Jun 19, 2007 at 04:34:42PM -0400, John Stoffel wrote:
>> >>>>> "Jack" == Jack Stone <jack@hawkeye.stone.uk.eu.org> writes:
>> 
Jack> The whole idea of the file system is that it wouldn't return the
Jack> file in the file listing. The user would have to know that the
Jack> file system was versioning to access the older versions as they
Jack> would explicitly have to request them.
>> 
>> So tell me what happens when I do:
>> 
>> touch foo:121212121212

Matthew> You create a new file called 'foo:121212121212'.  If you then
Matthew> modify it, you could access the old version as
Matthew> foo:121212121212:0.

Sure, I knew that, I was trying to push the boundaries a bit here with
magic version filenaming conventions to show that it won't scale.
Heck, trying to figure out what:

	touch foo::::::::::::::::::::::

does would be interesting, and would the filesystem parsing code
handle that case?  

Matthew> (The .snapshot directory makes more sense than magic names,
Matthew> since you can see what versions of a file are available
Matthew> without a special tool).

I agree 100%, it's a much better solution, though it has it's own
problems, esp over NFS and getting back to your original parent
directory properly can be painful.

John

