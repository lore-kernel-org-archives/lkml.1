Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbZCSU7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbZCSU7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZCSU6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:58:54 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:35237 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZCSU6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:58:53 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: linux-audit@redhat.com
Subject: Re: [PATCH] Add SELinux context and TTY name to AUDIT_TTY records
Date: Thu, 19 Mar 2009 16:58:10 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.27-gentoo-r8; KDE/4.2.1; i686; ; )
Cc: Miloslav Trmac <mitr@redhat.com>, viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <273781508.1737621237483080376.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <273781508.1737621237483080376.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903191658.10530.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009 01:18:00 pm Miloslav Trmac wrote:
> From: Miloslav Trmač <mitr@redhat.com>
>
> Add SELinux context information and TTY name (consistent with the
> AUDIT_SYSCALL record) to AUDIT_TTY.  An example record after applying
> this patch:
>
>  type=TTY msg=audit(1237480806.220:22): tty pid=2601 uid=0 auid=500 ses=1
>  subj=unconfined_u:unconfined_r:unconfined_t:s0 major=136 minor=1 tty=pts1
>  comm="bash" data=6361740D
>
> (line wrapped, new fields are "subj" and "tty".)
>
> Signed-off-by: Miloslav Trmač <mitr@redhat.com>
> ---
>  drivers/char/tty_audit.c |   57 ++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 19 deletions(-)

Just a quick procedural comment, in the future you should include patches in 
the body of the email; people will likely ignore your submission otherwise.

There are several audit experts which should review this code but two things 
jumped out at me when glancing at your patch:

 1. SELinux SIDs should not be recorded
 2. From a SELinux/security point of view ttys are considered objects
    and their labels/contexts should be recorded with "obj=" not "subj="

-- 
paul moore
linux @ hp

