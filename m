Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYJVWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYJVWas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759230AbYJVWaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:30:30 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:28924 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758730AbYJVWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:30:27 -0400
X-YMail-OSG: sq3qyqMVM1nirSQK7I8BDPxvY4mrhtYtlaZAST724q3zLm0Gx8ah1hJ7gdFZDB.bfEizMnJt33aYpXodDaWksLYgiStiCZFXvrBmdriJFc3rVcUvk8y1BYCiV4OQBYhCr5MIMlH24WbWh_2ZgInPZkfkW0A.v__om.HS3Lc-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: PATCH] [ConfigFS]: Extend CONFIGFS_ATTR_STRUCT() and
	CONFIGFS_ATTR_OPS() macros
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
In-Reply-To: <20081022221358.GA7621@mail.oracle.com>
References: <1224713189.24358.111.camel@haakon2.linux-iscsi.org>
	 <20081022221358.GA7621@mail.oracle.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 15:30:25 -0700
Message-Id: <1224714625.24358.125.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 15:13 -0700, Joel Becker wrote:
> On Wed, Oct 22, 2008 at 03:06:29PM -0700, Nicholas A. Bellinger wrote:
> > Hi Joel,
> > 
> > What do you think..?
> > 
> > Also, here is the drivers/lio-core/iscsi_target_configfs.c commit to
> > convert to use to new parameters for CONFIGFS_ATTR_STRUCT() and
> > CONFIGFS_ATTR_OPS():
> 
> 	It seems even more complex, and inconsistent with what sysfs
> and other users do.  Can you give me an example of using it?
> 

Sure, my reasoning was as I was looking at converting as much code as
possible in target_core_config.c and iscsi_target_configfs.c to use the
include/linux/config.h wrappers, I have noticed I am running into a
limitiation with existing code:

Having the user's attribute set of macro's '_name' being synonymous with
both the user's struct _item * and show()/store() defines with
CONFIGFS_ATTR_OPS() was going to cause namespace pollution when you want
to be able generic show()/store() on multiple struct config_groups
hanging off the same original struct _item.

For me, this was looking like problems when you have multiple default
struct config_groups off a single struct config_group,
namely /sys/kernel/config/target/iscsi/$IQN/$TPGT amoung other places in
LIO-Target.

Also, I would argue the patch makes the existing attribute macro in
configfs.h slightly *LESS* complex for the users of the macro because
you no longer have to define your own internal "to_<name>()" for each
struct config_group you want to hang attributes off.

Thanks!

--nab

> Joel
> 

