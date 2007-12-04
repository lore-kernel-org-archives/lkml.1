Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbXLDHoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbXLDHoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXLDHoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:44:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:52405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbXLDHoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:44:18 -0500
Date: Mon, 3 Dec 2007 23:46:12 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The use of KOBJ_NAME_LEN
Message-ID: <20071204074612.GA25316@suse.de>
References: <20071204064547.GA17094@darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204064547.GA17094@darkstar.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 02:45:47PM +0800, Dave Young wrote:
> Hi,
> Does the KOBJ_NAME_LEN really means the limit of kobject name length? seems
> not . And if it's true, is the KOBJ_NAME_LEN of 20 enough to use?

No, not anymore, the kobject name is totally dynamic.

> In the kobject_set_name, the limit is 1024. Looks like either the comment or
> the code should be updated.

Here's a patch below for the comment updating it.

I also have a patch in my -mm series that takes away the 1024 character
limit, but for 2.6.24 we'll have to live with it :)

thanks,

greg k-h


---
 lib/kobject.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -234,13 +234,13 @@ int kobject_register(struct kobject * ko
 
 
 /**
- *	kobject_set_name - Set the name of an object
- *	@kobj:	object.
- *	@fmt:	format string used to build the name
+ * kobject_set_name - Set the name of a kobject
+ * @kobj: kobject to name
+ * @fmt: format string used to build the name
  *
- *	If strlen(name) >= KOBJ_NAME_LEN, then use a dynamically allocated
- *	string that @kobj->k_name points to. Otherwise, use the static 
- *	@kobj->name array.
+ * This sets the name of the kobject.  If you have already added the
+ * kobject to the system, you must call kobject_rename() in order to
+ * change the name of the kobject.
  */
 int kobject_set_name(struct kobject * kobj, const char * fmt, ...)
 {
