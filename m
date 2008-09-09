Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYIIOi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYIIOi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYIIOis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:38:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45969 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIIOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:38:47 -0400
Date: Tue, 9 Sep 2008 08:38:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 04/13] PCI: acpiphp: remove 'name' parameter
Message-ID: <20080909143831.GY2772@parisc-linux.org>
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100022.29542.90739.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909100022.29542.90739.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 04:00:22AM -0600, Alex Chiang wrote:
> We do not need to manage our own name parameter, especially since
> the PCI core can change it on our behalf, in the case of duplicate
> slot names.

Looks good, just a question ...

>  	acpiphp_slot->slot = slot;
> -	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
> +	scnprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
>  

What's the difference between snprintf and scnprintf?

And why were we bothering to use snprintf anyway?  For when we fall into a
parallel universe where a u32 can have more than twenty digits?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
