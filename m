Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYIIPIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYIIPIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYIIPIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:08:36 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57446 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYIIPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:08:36 -0400
Date: Tue, 9 Sep 2008 09:08:35 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com
Subject: Re: [PATCH v2 06/13] PCI: cpqphp: stop managing hotplug_slot->name
Message-ID: <20080909150835.GA2772@parisc-linux.org>
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100032.29542.18371.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909100032.29542.18371.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 04:00:32AM -0600, Alex Chiang wrote:
> -static inline void make_slot_name(char *buffer, int buffer_size, struct slot *slot)
> -{
> -	snprintf(buffer, buffer_size, "%d", slot->number);
> -}

> +
> +		scnprintf(name, SLOT_NAME_SIZE, "%d", slot->number);

So ... we're using %d here and %u in acpiphp.  Obviously we don't expect
to get a number above 2 billion, but I think if we do have some utterly
bogus firmware that gives us a number above 2 billion, printing a
positive number is a better user experience than a negative number.

We clearly have a common pattern here where hotplug drivers have a
number insteaqd of a name (I would venture this is the most common).
Maybe we need a common helper?  I think this is a subject for the
long-term todo list, not something that needs to be addressed in the
context of this patch series.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
