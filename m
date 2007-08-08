Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXHHKOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXHHKOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbXHHKOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:14:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55119 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbXHHKOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:14:43 -0400
Date: Wed, 8 Aug 2007 12:14:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Loic Prylli <loic@myri.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?C=E9dric?= Augonnet <cedric.augonnet@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, brice@myri.com,
       cedric.augonnet@ens-lyon.org
Subject: Re: PAT support for i386 and x86_64
Message-ID: <20070808101441.GA12861@one.firstfloor.org>
References: <f56c1ba00708061903r29baea3dj6b57032be5820983@mail.gmail.com> <20070807083004.GB30085@one.firstfloor.org> <46B97E39.3020905@myri.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B97E39.3020905@myri.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't see why we have to worry about cache corruption in the case at
> hand. Write-combining is needed to map io (typically pci-mem regions)
> which are never mapped cachable anywhere, including in the linear map.

If we WC them using PAT then there would be a UC<->WC conflict with
the direct mapping and possibly others. That's already undefined
and not allowed.

After some very bad experiences in the past I'm not going to take
chances on this.

We really need to keep all possible mappings synchronized.

-Andi

