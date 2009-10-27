Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZJ0JUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZJ0JUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932220AbZJ0JUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:20:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37863 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbZJ0JUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 05:20:52 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Chiang <achiang@hp.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/4] pci: remove  min_size for hotplug bridge
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>
	<4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>
	<4AE55D72.7080202@kernel.org> <4AE6A9CA.4060106@kernel.org>
	<4AE6AAF2.7010402@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Oct 2009 02:20:51 -0700
In-Reply-To: <4AE6AAF2.7010402@kernel.org> (Yinghai Lu's message of "Tue\, 27 Oct 2009 01\:10\:26 -0700")
Message-ID: <m163a1kxak.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> revert
>
> | commit 28760489a3f1e136c5ae8581c0fa8f63511f2f4c
> | Author: Eric W. Biederman <ebiederm@aristanetworks.com>
> | Date:   Wed Sep 9 14:09:24 2009 -0700
> |
> |    PCI: pcie: Ensure hotplug ports have a minimum number of resources
>
> we don't need this trick anymore. the bridge BAR will be updated automatically

How so?  We can't reassign resources after they have been allocated as someone
might be using them.  If the firmware doesn't reserve the resource for a hotplug
we need to do it ourselves.


Eric
