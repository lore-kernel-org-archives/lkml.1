Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbXHZM4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbXHZM4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 08:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXHZM4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 08:56:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40355 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXHZM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 08:56:24 -0400
Date: Sun, 26 Aug 2007 14:56:23 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Michael J. Evans" <mjevans1983@comcast.net>
cc: Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Michael J . Evans" <mjevans1983@gmail.com>
Subject: Re: [patch v2 1/1] md: Software Raid autodetect dev list not array
In-Reply-To: <200708260451.24868.mjevans1983@comcast.net>
Message-ID: <Pine.LNX.4.64.0708261453450.15614@fbirervta.pbzchgretzou.qr>
References: <200708222058.45480.mjevans1983@comcast.net>
 <18126.21113.981032.286298@notabene.brown> <200708260451.24868.mjevans1983@comcast.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 04:51, Michael J. Evans wrote:
> {
>-	if (dev_cnt >= 0 && dev_cnt < 127)
>-		detected_devices[dev_cnt++] = dev;
>+	struct detected_devices_node *node_detected_dev;
>+	node_detected_dev = kzalloc(sizeof(*node_detected_dev), GFP_KERNEL);\

What's the \ good for, besides escaping the newline
that is ignored as whitespace anyway? :-)

>@@ -5772,3 +5790,8 @@ static void autostart_arrays(int part)
>-	for (i = 0; i < dev_cnt; i++) {
>-		dev_t dev = detected_devices[i];
>-
>+		/* FIXME: max 'int' #DEFINEd somewhere?  not   0x7FFFFFFF ? */
>+	while (!list_empty(&all_detected_devices) && i_scanned < 0x7FFFFFFF) {

I doubt someone really has _that_ many devices. Of course, to be on the
safer side, make it an unsigned int. That way, people could put in about
0xFFFFFFFE devs (which is even less likely than 0x7FFFFFFF)

>+		i_scanned++;
>+		node_detected_dev = list_entry(all_detected_devices.next,
>+					struct detected_devices_node, list);
>+		list_del(&node_detected_dev->list);
>+		dev = node_detected_dev->dev;
>+		kfree(node_detected_dev);

	Jan
-- 
