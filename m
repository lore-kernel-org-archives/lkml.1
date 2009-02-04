Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZBDPpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZBDPpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZBDPpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:45:21 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46312 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753928AbZBDPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:45:20 -0500
Date: Wed, 4 Feb 2009 10:39:19 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Swamy Gowda <swamy@virident.com>, linux-kernel@vger.kernel.org,
       Brice.Goglin@inria.fr, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] release mmap_sem before starting migration (Was
 Re: Need to take mmap_sem lock in move_pages.
In-Reply-To: <20090204185501.837ff5d6.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0902041037150.19633@qirst.com>
References: <28631E6913C8074E95A698E8AC93D091B21561@caexch1.virident.info> <20090204183600.f41e8b7e.kamezawa.hiroyu@jp.fujitsu.com> <20090204184028.09a4bbae.kamezawa.hiroyu@jp.fujitsu.com> <20090204185501.837ff5d6.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, KAMEZAWA Hiroyuki wrote:

> mmap_sem can be released after page table walk ends.

No. read lock on mmap_sem must be held since the migrate functions
manipulate page table entries. Concurrent large scale changes to the page
tables (splitting vmas, remapping etc) must not be possible.


