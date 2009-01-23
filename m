Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbZAWFiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbZAWFiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbZAWFiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:38:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39872 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZAWFiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:38:46 -0500
Date: Fri, 23 Jan 2009 06:54:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090123055404.GL15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122221500.4c62aa54@tpl> <20090122213105.74142908.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122213105.74142908.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know what "the fasync() problem" is?

The state needs to be protected while the per driver ->fasync callback
runs, otherwise the bit can get out of sync with what the driver
thinks it is.

Mind you imho the best way would be to move the bit manipulation for
that into the drivers, but that would require to change them all.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
