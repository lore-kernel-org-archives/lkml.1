Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZEBALs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZEBALs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 20:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZEBALh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 20:11:37 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:14812 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZEBALg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 20:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type:content-transfer-encoding;
        b=ASfc9SrehlGIwgDoKlYXgMhKMPbDrCu7Ghg4KtP+jNSJqkhuU9MAU4N4HWsbZDo2ak
         LbSOtz4y68rQKCKOhIqKjh5MQ9e850Iq6b1FDrcsWmT69W6Nhf2DMzXvELPW4rySbTrV
         sIuZ+NM+vu0MzUoHL4pL5ENFKyHN4h7igbmO0=
MIME-Version: 1.0
From: john slee <indigoid@oldcorollas.org>
Date: Sat, 2 May 2009 10:11:21 +1000
X-Google-Sender-Auth: 605bcd47e671177e
Message-ID: <9641a91e0905011711j75e33219yf520d0e40171908e@mail.gmail.com>
Subject: [proposal] creating anonymous files
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

At present developers seem to go through all kinds of ridiculous
antics to try to open a temporary file with some degree of safety.
Most of these seem to revolve around choosing a name, and in
many cases it gets unlinked immediately after open() anyway.

Temporary file creation/handling would be far less unpleasant if
it went something like this:

/* need to establish which fs the new inode goes on */
dirfd = open("/etc", O_RDONLY);

fd = openfdat(dirfd, O_CREAT, S_IWUSR|S_IRUSR);
/* file has no links, no need to unlink.  now use fd */

/* if we want to keep the file, add a link */
if (all_ok) {
    linkfdat(dirfd, fd, "nsswitch.conf");
} else {
   /* no cleanup required, inode has no links and */
   /* disappears at process exit */
}

I had a quick look through the Free/OpenBSD and Solaris 10
manpages in case they had implemented something similar, but
it seems that they haven't.

Sorry about lack of attached patch.  I did have a good look through
fs/namei.c and fs/open.c but I am more a sysadmin than a kernel
hacker

Comments/constructive abuse appreciated...

John

-- 
P-plate adventurer -- http://indigoid.org/
