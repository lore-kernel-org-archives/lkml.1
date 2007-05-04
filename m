Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXEDP0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXEDP0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXEDP0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:26:14 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46521 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbXEDP0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:26:11 -0400
Message-ID: <463B50A5.3070500@us.ibm.com>
Date: Fri, 04 May 2007 10:26:29 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-cifs-client@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Layton <jlayton@redhat.com>, hch@infradead.org
Subject: Re: [PATCH] CIFS: make sec=none force an anonymous mount
References: <20070504024910.CE97B1638AF@lists.samba.org>
In-Reply-To: <20070504024910.CE97B1638AF@lists.samba.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:
> We had a customer report that attempting to make CIFS mount with a null
> username (i.e. doing an anonymous mount) doesn't work. Looking through the
> code, it looks like CIFS expects a NULL username from userspace in order
> to trigger an anonymous mount. The mount.cifs code doesn't seem to ever
>pass a null username to the kernel, however.
Yes - cifs kernel code expects a NULL username (e.g. "username=") if 
you really don't want to pass the default username of the uid of 
the current process and you don't set the username explicitly
(e.g. in a credential file or mount parameter).

Samba userspace tools (and smbfs) handled this by first trying to
setup the SMB session using the default user, and if that fails 
with access denied then retrying sessionsetup with a null username 
string.  This would be easy to change in mount.cifs (ie as long 
as username was not explicitly passed on mount then if mount fails
with access denied simply add a retry with "username=").  This was
discussed at SambaXP.


Christoph Hellwig wrote:
> Looks useful.  In case you have some spare time at your hand it would
> be really nice to convert cifs option parsing to the lib/parser.c code
> and move all validation of the arguments into one place, so it's easily
> understanable and better to maintain.

Yes - that would be excellent.  The parse_mount_options badly needs to
be rewritten now that the number of mount options needed has grown.   
This is something Alex Bokovoy and I discussed last week at SambaXP 
for both the kernel code and the user space mount.cifs code.
Alex had volunteered to rewrite the user space cifs mount option
parsing code (and also change to use the safer talloc library)


