Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYICAmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYICAmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbYICAm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:42:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30382 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbYICAm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:42:29 -0400
Date: Tue, 2 Sep 2008 17:42:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Firstname Lastname <skb632@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: targets of function pointer invocations
Message-Id: <20080902174224.3ffb9966.randy.dunlap@oracle.com>
In-Reply-To: <269784.46170.qm@web59506.mail.ac4.yahoo.com>
References: <269784.46170.qm@web59506.mail.ac4.yahoo.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 00:12:12 -0700 (PDT) Firstname Lastname wrote:

> Hi all,
> 
> The lines 522-523 in function do_acct_process in file kernel/acct.c in version 2.6.26.3 are:
> 
>  file->f_op->write(file, (char *)&ac,sizeof(acct_t), &file->f_pos);
> 
> What are the full set of targets of this function pointer invocation and how can one be sure, by examining the code, that this is in fact the complete set?

If I understand your question, you want to know what are the ->write()
function parameters and how does one determine them?

'file' is struct file, found in include/linux/fs.h.
'f_op' is struct file_operations, in the same file.
'write' is defined in struct file_operations as:

	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);

4 typed parameters, returning ssize_t.

Is that what you meant?

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
