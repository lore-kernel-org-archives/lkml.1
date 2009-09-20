Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZITMdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZITMdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 08:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZITMdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 08:33:14 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52409 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898AbZITMdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 08:33:14 -0400
Date: Sun, 20 Sep 2009 08:30:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Max Laier <max@love2party.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: page_migration question
In-Reply-To: <200909200501.59164.max@love2party.net>
Message-ID: <alpine.DEB.1.10.0909200826540.21574@V090114053VZO-1>
References: <200909200501.59164.max@love2party.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009, Max Laier wrote:

> I read Documentation/vm/page_migration but couldn't find the information I'm
> looking for.  Specifically, what locks am I supposed to hold/not hold while
> calling migrate_prep() and migrate_pages()?  Currently migrate_prep() seems to
> deadlock for reasons beyond me.  Any help appreciated.

No locks need to be held while calling migrate prep. The pages to be
migrated must have been isolated from the LRU and a refcount be taken for
migrate_pages to work. Look at the implementation of sys_migratepages and
sys_mbind and sys_movepages.

