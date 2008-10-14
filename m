Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYJNVgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYJNVgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYJNVgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:36:15 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:16380 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYJNVgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:36:14 -0400
X-IronPort-AV: E=Sophos;i="4.33,410,1220227200"; 
   d="scan'208";a="108496814"
From: Roland Dreier <rdreier@cisco.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: question about pci_disable_device
References: <200810131947.44992.oliver@neukum.org>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 14 Oct 2008 14:36:13 -0700
In-Reply-To: <200810131947.44992.oliver@neukum.org> (Oliver Neukum's message
	of "Mon, 13 Oct 2008 19:47:44 +0200")
Message-ID: <ada7i8avoz6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Oct 2008 21:36:13.0925 (UTC) FILETIME=[E1E42950:01C92E44]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > could somebody explain what determines when in the sequence of hot
 > unplugging pci_disable_device() is called?

I'm not positive about this, but pci_disable_device() should be called
as part of the device's driver's .remove method, which is called from
the sequence:

hotplug driver ->
    pci_remove_bus_device() ->
        pci_destroy_dev() ->
            pci_stop_dev() ->
                device_unregister()

 - R.
