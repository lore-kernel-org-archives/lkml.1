Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab0CMDhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:37:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:40652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806Ab0CMDhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:37:39 -0500
Message-ID: <4B9B0836.7080508@kernel.org>
Date: Fri, 12 Mar 2010 19:36:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland Dreier <rdreier@cisco.com>
CC: Alexander Beregalov <a.beregalov@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>	<86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>	<m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org> <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org> <4B99A7B9.3000802@kernel.org>
In-Reply-To: <4B99A7B9.3000802@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/net/mlx4/main.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/net/mlx4/main.c
===================================================================
--- linux-2.6.orig/drivers/net/mlx4/main.c
+++ linux-2.6/drivers/net/mlx4/main.c
@@ -1023,6 +1023,7 @@ static int mlx4_init_port_info(struct ml
 	info->port_attr.attr.mode = S_IRUGO | S_IWUSR;
 	info->port_attr.show      = show_port_type;
 	info->port_attr.store     = set_port_type;
+	sysfs_attr_init(&info->port_attr.attr);
 
 	err = device_create_file(&dev->pdev->dev, &info->port_attr);
 	if (err) {
