Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZHFS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZHFS5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZHFS5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:57:45 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:45674 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZHFS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:57:44 -0400
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 14:57:44 EDT
Message-ID: <4A7B24C9.6020309@cs.columbia.edu>
Date: Thu, 06 Aug 2009 14:45:29 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.22 (X11/20090804)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: James Morris <jmorris@namei.org>, Justin Banks <justinb@bakbone.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: security module question
References: <20090804220632.GG26133@bleen>	 <alpine.LRH.2.00.0908051159100.29562@tundra.namei.org> <1249583888.20644.37.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1249583888.20644.37.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Wed, 2009-08-05 at 12:02 +1000, James Morris wrote:
>> On Tue, 4 Aug 2009, Justin Banks wrote:
>>
>>> Hello - I'm trying to implement a security module that will allow or
>>> disallow writes on files by byte ranges. Is there a way to use
>>> inode_permission() to do this, or is there an alternative route I should
>>> take? It doesn't look like inode_permission() will give me the data I
>>> need (offset + length of write).
> 
> There is nothing that can do that.  Neither fanotify nor the LSM.
> Biggest problem is mmap.....
> 
> I think there was past kernel module which did this, but I don't
> remember what they were called.  Nothing which tracks this and could be
> used was ever reasonable for the mainline kernel.

stackable file-system could do it (ala ecryptfs).  You'd end up with
double page table usage (as they don't stack well), but you'd be able to
catch all mmap writes to disk.
