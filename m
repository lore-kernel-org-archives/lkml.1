Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZJ1BWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZJ1BWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbZJ1BWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:22:14 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:32865 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbZJ1BWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gg5CcWqC+Dx5VBOCKMAW+sub2HvAXj3KJ0BmWNWZJOjCPtk99ruRxSkQrtlhLdiezJ
         oGVb0hP6H/0Wg/zKYTenYbyFjQAGmag/4CeSCczHgKFeS77v74K3xUWWMO664RiozEu6
         jMKiBUvTr9Gs9RMQVdjThZB2PV+njlc3iWhEs=
MIME-Version: 1.0
Date: Wed, 28 Oct 2009 11:22:18 +1000
Message-ID: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
Subject: is avoiding compat ioctls possible?
From: Dave Airlie <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       DRI Development Mailing List 
	<dri-devel@lists.sourceforge.net>,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So for drm KMS we wrote a bunch of ioctls that were 64-bit clean in theory.

They used uint64_t to represent userspace pointers and userspace
casted into those and the kernel casts back out and passes it to copy_*_user

Now I thought cool I don't need to worry about compat ioctl hackery I can
run 32 on 64 bit apps fine and it'll all just work.

Now Dave Miller points out that I'm obivously deluded and we really need
to add compat ioctls so that the kernel can truncate correctly 32-bit address
in case userspace shoves garbage into the top 32bits of the u64.

Is there really no way to avoid compat ioctls? was I delusional in
thinking there was?

Dave.
