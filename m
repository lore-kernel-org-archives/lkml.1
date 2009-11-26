Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbZKZQsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbZKZQsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZKZQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:48:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:61468 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878AbZKZQsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:48:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eDi70SoNaQ0ypsbbs6FSw6EjHUqrJ45zGtyuBlj4q0O8OLhH7yz7m559mgd/xKWqCy
         uEEMWmCcW9aPJvV32iXRa1tMJD+ZlY9jle5lSkR5F+ru3ysObcemaDj5nNY2Rr4fJmMq
         b6LFfswyzjxHd3b1ecOHkWuhCrk5phV3ViC3M=
Date: Thu, 26 Nov 2009 19:48:46 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: xiyou.wangcong@gmail.com
Cc: jengelh@medozas.de, linux-kernel@vger.kernel.org
Subject: Re: Programs die when max_map_count is too large
Message-ID: <20091126164846.GA22709@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMO, the problem is 'sysctl_max_map_count' is actually signed int,
> while when writing to it, the value is treated as unsigned.

The problem is the loop in simple_strtoul(), some people were so afraid
to touch so they even came up with strict_* variants.

> A better fix which I could imagine is to fix sysctl to understand
> signed int's.

	-	int map_count;
	+	unsigned int map_count;

This is incomplete at least.
