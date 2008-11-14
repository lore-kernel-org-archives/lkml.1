Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYKNPha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYKNPha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYKNPhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:37:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38747 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYKNPhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:37:18 -0500
Subject: Re: [PATCH] filesystems: use has_capability_noaudit interface for
 reserved blocks checks
From: Eric Paris <eparis@redhat.com>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: linux-kernel@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, tytso@mit.edu, linux-ext4@vger.kernel.org,
       dedekind@infradead.org, ext-adrian.hunter@nokia.com,
       linux-mtd@lists.infradead.org, dushistov@mail.ru, jmorris@namei.org
In-Reply-To: <491D2F09.3070104@yandex.ru>
References: <1226430769.3353.5.camel@localhost.localdomain>
	 <491D2F09.3070104@yandex.ru>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 10:36:01 -0500
Message-Id: <1226676961.3353.78.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 09:55 +0200, Artem Bityutskiy wrote:
> Eric Paris wrote:
> > ext[2,3,4], ufs, and ubifs all check for  CAP_SYS_RESOURCE to determine
> > if they should allow reserved blocks to be used.  A process not having
> > this capability is not failing some security decision and should not be
> > audited.  Thus move to using has_capability_noaudit.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> 
> UBIFS part looks OK, as long as the whole idea of the patch is right, which
> I have not checked, but assume it is.
> 
> The only question is are you sure exporting 'cap_capable()' is relevant
> to this patch? You do not seem to call it directly.

After this change, modules call has_capability_noaudit() which is a
#define which turns this into modules calling
security_capable_noaudit().  You noticed this and decided it was correct
to make that export.  But when CONFIG_SECURITY is not set
security_capable_notaudit() is a static inline which calls
cap_capable().  See include/linux/security.h line 2832 in the linux-next
tree.  Now modules are calling cap_capable directly, thus the export.

-Eric

