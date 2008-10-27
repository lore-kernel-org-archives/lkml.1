Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYJ0TbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYJ0TbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYJ0Ta5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:30:57 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:29275 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbYJ0Ta4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:30:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAL2yBUlR9dge/2dsb2JhbACBdsU/g08
Date: Mon, 27 Oct 2008 20:30:53 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] [WATCHDOG] Fix kdump when using hpwdt
Message-ID: <20081027193053.GA2659@infomag.infomag.iguana.be>
References: <1225033177-5311-1-git-send-email-bwalle@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225033177-5311-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernard,

Tom will have a look at the fix but the below code is wrong:

> -module_param(allow_kdump, int, 0);
> +module_param(allow_kdump, int, 1);
>  MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");

the syntax is: #define module_param(name, type, perm)
perm sets the visibility in sysfs: 000 means it's not there,
read bits mean it's readable, write bits mean it's writable.

perm is not the default value for the integer but a file permission attribute.

Kind regards,
Wim.

