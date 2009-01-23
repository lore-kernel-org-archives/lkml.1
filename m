Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbZAWGCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbZAWGCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZAWGBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:01:55 -0500
Received: from vena.lwn.net ([206.168.112.25]:53885 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZAWGBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:01:54 -0500
Date: Thu, 22 Jan 2009 23:01:45 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090122230145.7e434dee@tpl>
In-Reply-To: <20090123055404.GL15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122221500.4c62aa54@tpl>
	<20090122213105.74142908.akpm@linux-foundation.org>
	<20090123055404.GL15750@one.firstfloor.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009 06:54:04 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> The state needs to be protected while the per driver ->fasync callback
> runs, otherwise the bit can get out of sync with what the driver
> thinks it is.
> 
> Mind you imho the best way would be to move the bit manipulation for
> that into the drivers, but that would require to change them all.

You know, I'm not sure why I didn't look into that.  Do we want drivers
reaching directly into struct file and making changes?  Maybe a helper
would be better.  Hmm, maybe we could call it fasync_helper() and it
could just do the right thing?  Will investigate further...

jon
