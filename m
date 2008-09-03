Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYICAxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYICAxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYICAx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:53:29 -0400
Received: from gw.goop.org ([64.81.55.164]:46976 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbYICAx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:53:28 -0400
Message-ID: <48BDE003.1090605@goop.org>
Date: Tue, 02 Sep 2008 17:53:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Firstname Lastname <skb632@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: targets of function pointer invocations
References: <269784.46170.qm@web59506.mail.ac4.yahoo.com> <20080902174224.3ffb9966.randy.dunlap@oracle.com>
In-Reply-To: <20080902174224.3ffb9966.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat, 30 Aug 2008 00:12:12 -0700 (PDT) Firstname Lastname wrote:
>
>   
>> Hi all,
>>
>> The lines 522-523 in function do_acct_process in file kernel/acct.c in version 2.6.26.3 are:
>>
>>  file->f_op->write(file, (char *)&ac,sizeof(acct_t), &file->f_pos);
>>
>> What are the full set of targets of this function pointer invocation and how can one be sure, by examining the code, that this is in fact the complete set?
>>     
>
> If I understand your question, you want to know what are the ->write()
> function parameters and how does one determine them?
>
> 'file' is struct file, found in include/linux/fs.h.
> 'f_op' is struct file_operations, in the same file.
> 'write' is defined in struct file_operations as:
>
> 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
>
> 4 typed parameters, returning ssize_t.
>
> Is that what you meant?
>   

Actually, I think OP is asking what's the complete set of functions
->write can point to.  You can look for all the in-tree assignments to
f_ops (or all the struct file_ops) to get the in-kernel estimate.  But
any out of tree module could also install file_ops.write, so you can't
be exhaustive.

    J
