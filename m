Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0BLMrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:47:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42835 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0BLMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:47:15 -0500
To: Greg KH <gregkh@suse.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo \<tj\@kernel.org\> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: Document sysfs_attr_init and sysfs_bin_attr_init
References: <4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
	<4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org>
	<m14olnxt3s.fsf_-_@fess.ebiederm.org>
	<m1ljezwean.fsf_-_@fess.ebiederm.org>
	<m1hbpnwe7i.fsf_-_@fess.ebiederm.org>
	<m1d40bwe5i.fsf_-_@fess.ebiederm.org> <20100211234221.GA10498@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 12 Feb 2010 04:47:10 -0800
In-Reply-To: <20100211234221.GA10498@suse.de> (Greg KH's message of "Thu\, 11 Feb 2010 15\:42\:21 -0800")
Message-ID: <m1vde2vcxd.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Thu, Feb 11, 2010 at 03:23:05PM -0800, Eric W. Biederman wrote:
>> 
>> These are the non-static sysfs attributes that exist on
>> my test machine.  Fix them to use sysfs_attr_init or
>> sysfs_bin_attr_init as appropriate.   It simply requires
>> making a sysfs attribute present to see this.  So this
>> is a little bit tedious but otherwise not too bad.
>
> Can we document this in the sysfs_attr_init kerneldoc documentation that
> you add for this new function?

Here you go.

>From 646c76c0b20b30923a652bbf8cefec5e335359a9 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Fri, 12 Feb 2010 04:35:32 -0800
Subject: [PATCH] sysfs: Document sysfs_attr_init and sysfs_bin_attr_init

I have added a new requirement to the external sysfs interface
that dynamically allocated sysfs attributes must call sysfs_attr_init
if lockdep is enabled.  For the time being callying sysfs_attr_init
is only mandatory if lockdep is enabled, so we can live with a few
unconverted instances until we find them all.  As this is part of
the public interface of sysfs it is a good idea to document these
pseudo functions so someone inspeciting the code can find out
what has happened.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/sysfs.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index c3048de..2b24ae5 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -36,6 +36,16 @@ struct attribute {
 #endif
 };
 
+/**
+ *	sysfs_attr_init - initialize a dynamically allocated sysfs attribute
+ *	@attr: struct attribute to initialize
+ *
+ *	Initialize a dynamically allocated struct attribute so we can
+ *	make lockdep happy.  This is a new requirement for attributes
+ *	and initially this is only needed when lockdep is enabled.
+ *	Lockdep gives a nice error when your attribute is added to
+ *	sysfs if you don't have this.
+ */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define sysfs_attr_init(attr)				\
 do {							\
@@ -90,6 +100,16 @@ struct bin_attribute {
 		    struct vm_area_struct *vma);
 };
 
+/**
+ *	sysfs_bin_attr_init - initialize a dynamically allocated bin_attribute
+ *	@attr: struct bin_attribute to initialize
+ *
+ *	Initialize a dynamically allocated struct bin_attribute so we
+ *	can make lockdep happy.  This is a new requirement for
+ *	attributes and initially this is only needed when lockdep is
+ *	enabled.  Lockdep gives a nice error when your attribute is
+ *	added to sysfs if you don't have this.
+ */
 #define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&bin_attr->attr)
 
 struct sysfs_ops {
-- 
1.6.5.2.143.g8cc62

