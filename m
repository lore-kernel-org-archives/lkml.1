Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZCRJp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZCRJp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZCRJpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:45:18 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:48008 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZCRJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:45:16 -0400
Message-ID: <49C0C273.4070408@cs.columbia.edu>
Date: Wed, 18 Mar 2009 05:44:19 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: C/R review
References: <20090317210110.GA3897@x200.localdomain> <20090318004742.GA14308@us.ibm.com>
In-Reply-To: <20090318004742.GA14308@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
>>> +Keeping the restart procedure to operate within the limits of the
>>> +caller's credentials means that there various scenarios that cannot
>>> +be supported. For instance, a setuid program that opened a protected
>>> +log file and then dropped privileges will fail the restart, because
>>> +the user won't have enough credentials to reopen the file.
>> That's a bug.
> 
> What is described is not a bug, but I think the way it is done is in
> fact a bug.
> 
> Note that just because you *can* do the restart without privilege
> doesn't mean that you have to.  If you do a restart with privilege,
> then you should be able to open that file, then drop down to the
> original task's uid.
> 
> But to say that letting an unprivileged user do restart, and that
> it will only succeed if it can access the resources its allowed to
> access, is bogus.
> 
> But I do think the way it's implemented will become buggy and needs to
> be fixed.  That is, we do cr_read_task_struct() before we do
> cr_read_files().  So in fact if I'm root doing restart of such a
> checkpoint image, I'll first drop down to uid 500, then open the files.
> 
> That would obviously be a bug.
> 
> Now, we don't actually restore uids yet in the current code, so
> it's still a theoretical bug :)

Good point. And that's why uid's will be restored at the end :)
(when we get there ...)

Oren.
