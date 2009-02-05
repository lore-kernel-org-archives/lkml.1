Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbZBEAiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbZBEAiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbZBEAhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:37:48 -0500
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:44396 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761477AbZBEAhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:37:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hQ04vpI71s8uwf8UpF3M5F5dqQrtI7dgT+7CiTveFJ75oXL8bes1MaQU1YV6v1QPeAVLX1PFcxHWkCsTWYWfI+lOfcEHz0Sw9Q9JKdzh8mvAoMWXN4dBxC/lioUYVFcy;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [RFC PATCH 03/10] PCI: properly clean up ASPM link state on device remove
Date: Wed, 4 Feb 2009 16:37:44 -0800
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>
References: <20090128213814.28003.34634.stgit@bob.kio> <20090128215918.28003.58805.stgit@bob.kio>
In-Reply-To: <20090128215918.28003.58805.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041637.45099.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 28, 2009 1:59 pm Alex Chiang wrote:
> We only want to disable ASPM when the last function is removed from
> the parent's device list. We determine this by checking to see if
> the parent's device list is completely empty.
>
> Unfortunately, we never hit that code because the parent is considered
> an upstream port, and never had an ASPM link_state associated with it.
>
> The early check for !link_state causes us to return early, we never
> discover that our device list is empty, and thus we never remove the
> downstream ports' link_state nodes.
>
> Instead of checking to see if the parent's device list is empty, we can
> check to see if we are the last device on the list, and if so, then we
> know that we can clean up properly.
>
> Cc: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>

Applied to my for-linus branch, thanks.  Let me know if you have a problem 
with it (fast) Shaohua! :)

-- 
Jesse Barnes, Intel Open Source Technology Center
