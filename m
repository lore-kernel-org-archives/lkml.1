Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYHOL1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYHOL1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYHOL1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:27:05 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:34887 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYHOL1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:27:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MNwUcQP/4/K/0V2uijes8ezFdSXq+yPZ2OL2XhZO72ugW88E0p7ax32N3tT+90Xxk/
         QLVtciBTbxe7mQDHPrv0EGWf+PHUMgZTRQQeOdDS2WPnoWj97CR2zcwuq9xkg3lzLtQU
         Jm+ELvcp2Q8CtMvDQ/YDDtUWhfeWtyLifveJI=
Message-ID: <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>
Date: Fri, 15 Aug 2008 13:27:00 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       ak@linux.intel.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <20080814083828.d10e126d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
	 <20080814083828.d10e126d.randy.dunlap@oracle.com>
X-Google-Sender-Auth: ce53109ae3a795a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 17:38, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> calling  param_sysfs_init+0x0/0x1e7
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
> sysfs: duplicate filename 'acpi' can not be created

Hi Randy,
care to add a printk to the module sysfs setup, and post dmesg again?

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -603,6 +603,8 @@ static void __init param_sysfs_builtin(void)
 		}
 		name_len = dot - kp->name;

+		printk("XXX adding modparam:'%s' %i (%p)\n", kp->name, i, kp);
+
  		/* new kbuild_modname? */
 		if (strlen(modname) != name_len
 		    || strncmp(modname, kp->name, name_len) != 0) {

I might show the order of registering the /sys/modules/ directory, and
if there is possibly another "acpi" section, which tries to add
parameter names.

Thanks,
Kay
