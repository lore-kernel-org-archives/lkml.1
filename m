Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbXLYWEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbXLYWEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 17:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXLYWE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 17:04:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbXLYWE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 17:04:26 -0500
Date: Tue, 25 Dec 2007 14:03:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001 of 7] md: Support 'external' metadata for md arrays.
Message-Id: <20071225140342.9d0ff789.akpm@linux-foundation.org>
In-Reply-To: <1071214062608.1815@suse.de>
References: <20071214171950.1308.patches@notabene>
	<1071214062608.1815@suse.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 17:26:08 +1100 NeilBrown <neilb@suse.de> wrote:

> +	if (strncmp(buf, "external:", 9) == 0) {
> +		int namelen = len-9;
> +		if (namelen >= sizeof(mddev->metadata_type))
> +			namelen = sizeof(mddev->metadata_type)-1;
> +		strncpy(mddev->metadata_type, buf+9, namelen);
> +		mddev->metadata_type[namelen] = 0;
> +		if (namelen && mddev->metadata_type[namelen-1] == '\n')
> +			mddev->metadata_type[--namelen] = 0;
> +		mddev->persistent = 0;
> +		mddev->external = 1;

size_t would be a more appropriate type for `namelen'.
