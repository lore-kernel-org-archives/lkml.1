Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905Ab0ANFNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0ANFNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262Ab0ANFNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:13:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48995 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0ANFNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:13:18 -0500
Date: Thu, 14 Jan 2010 05:13:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/8] vfs: fix too big f_pos handling
Message-ID: <20100114051308.GA14616@ZenIV.linux.org.uk>
References: <20100113140955.GA18593@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113140955.GA18593@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:09:56PM +0800, Wu, Fengguang wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, rw_verify_area() checsk f_pos is negative or not. And if
> negative, returns -EINVAL.
> 
> But, some special files as /dev/(k)mem and /proc/<pid>/mem etc..
> has negative offsets. And we can't do any access via read/write
> to the file(device).
> 
> This patch introduce a flag S_VERYBIG and allow negative file
> offsets.

Ehh...  FMODE_NEG_OFFSET in file->f_mode, perhaps?
