Return-Path: <linux-kernel-owner+w=401wt.eu-S1761705AbZASNHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761705AbZASNHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761042AbZASNGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:06:50 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44431 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761599AbZASNGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:06:49 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49747ADA.1080502@s5r6.in-berlin.de>
Date: Mon, 19 Jan 2009 14:06:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Nick Craig-Wood <nick@craig-wood.com>
CC: David Wagner <daw@cs.berkeley.edu>, linux-kernel@vger.kernel.org
Subject: Re: Checking module parameters
References: <bVsVO-15X-19@gated-at.bofh.it> <20090119093814.BC18014CA88@irishsea.home.craig-wood.com> <497453B6.8090403@s5r6.in-berlin.de> <20090119124436.GD1646@craig-wood.com>
In-Reply-To: <20090119124436.GD1646@craig-wood.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Craig-Wood wrote:
> On Mon, Jan 19, 2009 at 11:19:34AM +0100, Stefan Richter wrote:
>> There is also /sys/module/*/parameters/* which can be read and in some
>> cases even be written.
> 
> It doesn't appear to show the force parameter.

You are right.
>From drivers/ata/libata-core.c:

|> static char ata_force_param_buf[PAGE_SIZE] __initdata;
|> /* param_buf is thrown away after initialization, disallow read */
|> module_param_string(force, ata_force_param_buf,
sizeof(ata_force_param_buf), 0);
|> MODULE_PARM_DESC(force, "Force ATA configurations including cable
type, link speed and transfer mode (see
Documentation/kernel-parameters.txt for details)");

The 0 in module_param_string are the sysfs file permissions of libata.force.

And __initdata means that the memory goes away after ata_init() returned.
-- 
Stefan Richter
-=====-==--= ---= =--==
http://arcgraph.de/sr/
