Return-Path: <linux-kernel-owner+w=401wt.eu-S933435AbZJLWHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbZJLWHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbZJLWHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:07:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339AbZJLWHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:07:42 -0400
Date: Mon, 12 Oct 2009 15:06:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: Add cciss_allow_hpsa module parameter.
Message-Id: <20091012150615.f9572d8a.akpm@linux-foundation.org>
In-Reply-To: <20091012153606.4367.73416.stgit@beardog.cce.hp.com>
References: <20091012153606.4367.73416.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 10:36:25 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> Add cciss_allow_hpsa module parameter.  This parameter causes
> the cciss driver to ignore any Smart Array devices known to be
> supported by the hpsa driver.

An alternative approach would be to ensure that hpsa is loaded first. 
Then when cciss tries to control a device it will fail to acquire that
devices's PCI regions and will bale out in an orderly manner.

I don't know how we can reliably arrange for hpsa to execute first, but
I'm sure someone does ;)

Unless CONFIG_CCISS=y, CONFIG_HPSA=m.  Then we're screwed.
