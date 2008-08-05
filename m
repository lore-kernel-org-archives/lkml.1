Return-Path: <linux-kernel-owner+w=401wt.eu-S1761710AbYHERxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710AbYHERxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbYHERwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:52:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:3273 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761323AbYHERwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=GxTmab0vPzeUbDLaNDEInABYaYhS1dBJQR20bRxxE5JQI6J/xCCgEViflnakj5OUCB
         7XkNCbc/UswlhkH7zULiY52PtkAiUef2kaUpXCq/c+St2xTyDqVxc+jmN4+kdmbE9UsZ
         afxu3nstr2C91CDS+r7vpLOxidmzhQTnWyRM8=
Date: Tue, 5 Aug 2008 23:22:25 +0530
From: Rabin Vincent <rabin@rab.in>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com
Subject: Re: BUG when doing a cat
	/sys/devices/system/cpu/cpuidle/current_driver
Message-ID: <20080805175224.GA1745@debian>
References: <20080805111836.GB12217@alice> <20080805123356.GA12656@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805123356.GA12656@alice>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 02:33:56PM +0200, Eric Sesterhenn wrote:
> > issuing a 
> > 
> > cat /sys/devices/system/cpu/cpuidle/current_driver
> > 
[trim first oops, same issue]
> > gives me the following oops on current -git,
> > [ 4089.268648] BUG: unable to handle kernel paging request at 7898b450
> > [ 4089.268965] IP: [<c0678bd3>] show_current_driver+0x3/0x70
> > [ 4089.269175] *pde = 00000000 
> > [ 4089.269370] Oops: 0000 [#1] DEBUG_PAGEALLOC
> > [ 4089.269579] Modules linked in: [last unloaded: rcutorture]
> > [ 4089.269875] 
> > [ 4089.269975] Pid: 13168, comm: cat Not tainted (2.6.27-rc1 #24)
> > [ 4089.270106] EIP: 0060:[<c0678bd3>] EFLAGS: 00010282 CPU: 0
> > [ 4089.270295] EIP is at show_current_driver+0x3/0x70
> > [ 4089.270425] EAX: c0b74da0 EBX: cc8c9000 ECX: c0678bd0 EDX: cc8c9000
> > [ 4089.270559] ESI: c0b74de2 EDI: cf844cc8 EBP: c99aef3c ESP: c99aef30
> > [ 4089.270692]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > [ 4089.270877] Process cat (pid: 13168, ti=c99ae000 task=ca52d420 task.ti=c99ae000)
> > [ 4089.271020] Stack: c0563d49 c9a48978 c0b74a20 c99aef6c c01e1cd1 c042cdd4 c99aef6c 00001000 
> > [ 4089.271746]        092b7000 c9a4898c c0b74a20 c0b74ddc c8456550 092b7000 00001000 c99aef90 
> > [ 4089.272528]        c0197b09 c99aef9c 00000002 00000000 c01e1c50 c8456550 fffffff7 092b7000 
> > [ 4089.273252] Call Trace:
> > [ 4089.273487]  [<c0563d49>] ? sysdev_class_show+0x29/0x40
> > [ 4089.273795]  [<c01e1cd1>] ? sysfs_read_file+0x81/0x110
> > [ 4089.274039]  [<c042cdd4>] ? security_file_permission+0x14/0x20
> > [ 4089.274346]  [<c0197b09>] ? vfs_read+0x99/0x160
> > [ 4089.274635]  [<c01e1c50>] ? sysfs_read_file+0x0/0x110
> > [ 4089.274927]  [<c01980e2>] ? sys_read+0x42/0x70
> > [ 4089.275156]  [<c0103059>] ? sysenter_do_call+0x12/0x31
> > [ 4089.275452]  [<c019e074>] ? __free_pipe_info+0x44/0x50
> > [ 4089.275750]  =======================
> > [ 4089.275860] Code: 00 00 8d bf 00 00 00 00 55 89 e5 e8 ac b0 a8 ff ba a4 35 b8 c0 83 c0 3c e8 db b4 b6 ff 5d c3 89 f6 8d bc 27 00 00 00 00 6e 6f 6e <65> 0a 00 0c 0f 1f 44 00 00 b8 68 35 b8 c0 89 cb e8 d8 70 1b 00 
> > [ 4089.277001] EIP: [<c0678bd3>] show_current_driver+0x3/0x70 SS:ESP 0068:c99aef30
> > [ 4089.277925] ---[ end trace 463e756b5a7abbdb ]---

The problem is that the sysfs attributes are incorrectly declared.  The
patch below should fix it:

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 31a0e0b..97b0038 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -21,8 +21,8 @@ static int __init cpuidle_sysfs_setup(char *unused)
 }
 __setup("cpuidle_sysfs_switch", cpuidle_sysfs_setup);
 
-static ssize_t show_available_governors(struct sys_device *dev,
-		struct sysdev_attribute *attr, char *buf)
+static ssize_t show_available_governors(struct sysdev_class *class,
+					char *buf)
 {
 	ssize_t i = 0;
 	struct cpuidle_governor *tmp;
@@ -40,8 +40,8 @@ out:
 	return i;
 }
 
-static ssize_t show_current_driver(struct sys_device *dev,
-		struct sysdev_attribute *attr, char *buf)
+static ssize_t show_current_driver(struct sysdev_class *class,
+				   char *buf)
 {
 	ssize_t ret;
 
@@ -55,8 +55,8 @@ static ssize_t show_current_driver(struct sys_device *dev,
 	return ret;
 }
 
-static ssize_t show_current_governor(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t show_current_governor(struct sysdev_class *class,
+				     char *buf)
 {
 	ssize_t ret;
 
@@ -70,9 +70,8 @@ static ssize_t show_current_governor(struct sys_device *dev,
 	return ret;
 }
 
-static ssize_t store_current_governor(struct sys_device *dev,
-	struct sysdev_attribute *attr,
-	const char *buf, size_t count)
+static ssize_t store_current_governor(struct sysdev_class *class,
+				      const char *buf, size_t count)
 {
 	char gov_name[CPUIDLE_NAME_LEN];
 	int ret = -EINVAL;
@@ -104,8 +103,9 @@ static ssize_t store_current_governor(struct sys_device *dev,
 		return count;
 }
 
-static SYSDEV_ATTR(current_driver, 0444, show_current_driver, NULL);
-static SYSDEV_ATTR(current_governor_ro, 0444, show_current_governor, NULL);
+static SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);
+static SYSDEV_CLASS_ATTR(current_governor_ro, 0444, show_current_governor,
+			 NULL);
 
 static struct attribute *cpuclass_default_attrs[] = {
 	&attr_current_driver.attr,
@@ -113,9 +113,10 @@ static struct attribute *cpuclass_default_attrs[] = {
 	NULL
 };
 
-static SYSDEV_ATTR(available_governors, 0444, show_available_governors, NULL);
-static SYSDEV_ATTR(current_governor, 0644, show_current_governor,
-	store_current_governor);
+static SYSDEV_CLASS_ATTR(available_governors, 0444, show_available_governors,
+			 NULL);
+static SYSDEV_CLASS_ATTR(current_governor, 0644, show_current_governor,
+			 store_current_governor);
 
 static struct attribute *cpuclass_switch_attrs[] = {
 	&attr_available_governors.attr,
