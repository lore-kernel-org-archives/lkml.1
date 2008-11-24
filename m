Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYKXPPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYKXPPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYKXPO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:14:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:41949 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYKXPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:14:56 -0500
Message-ID: <ac3eb2510811240714l76b15469lea541bb4badd328@mail.gmail.com>
Date: Mon, 24 Nov 2008 16:14:54 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Daniel Lezcano" <dlezcano@fr.ibm.com>
Subject: Re: [patch 1/1][RFC]Handle uevent per namespace
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>, "David Miller" <davem@davemloft.net>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Benjamin Thery" <benjamin.thery@bull.net>
In-Reply-To: <492A86FA.5080804@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492A86FA.5080804@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 11:50, Daniel Lezcano <dlezcano@fr.ibm.com> wrote:

 struct kobject {
 	const char		*name;
 	struct list_head	entry;
@@ -63,6 +65,9 @@ struct kobject {
 	struct kset		*kset;
 	struct kobj_type	*ktype;
 	struct sysfs_dirent	*sd;
+#ifdef CONFIG_NET
+	struct net              *net;
+#endif
 	struct kref		kref;
 	unsigned int state_initialized:1;
 	unsigned int state_in_sysfs:1;

We cannot do that. Network specific stuff does not belong into
kobjects. Kobjects are not in any way subsystem specific, and we need
to keep it that way.

Thanks,
Kay
