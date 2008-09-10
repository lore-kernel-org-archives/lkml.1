Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYIJByl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYIJByl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 21:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYIJByd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 21:54:33 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:36747 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYIJByd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 21:54:33 -0400
Message-ID: <48C727B6.9000700@cs.columbia.edu>
Date: Tue, 09 Sep 2008 21:49:42 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v4][PATCH 9/9] File descriprtors (restore)
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>	 <1220946154-15174-10-git-send-email-orenl@cs.columbia.edu> <1220977581.23386.216.camel@nimitz>
In-Reply-To: <1220977581.23386.216.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
>> +static int cr_close_all_fds(struct files_struct *files)
>> +{
>> +       int *fdtable;
>> +       int n;
>> +
>> +       do {
>> +               n = cr_scan_fds(files, &fdtable);
>> +               if (n < 0)
>> +                       return n;
>> +               while (n--)
>> +                       sys_close(fdtable[n]);
>> +               kfree(fdtable);
>> +       } while (n != -1);
>> +
>> +       return 0;
>> +}
> 
> This needs to use an ERR_PTR().  It will save using the double-pointer.

I suppose you refer to the call to cr_scan_fds(): either 'fdtable'
or 'n' will have to pass-by-reference. Is it that you prefer it to be
	fdtable = cr_scan_fds(files, &n);
?

Oren.

